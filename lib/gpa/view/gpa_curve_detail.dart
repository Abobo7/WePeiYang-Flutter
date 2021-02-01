import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wei_pei_yang_demo/gpa/model/gpa_notifier.dart';
import 'dart:math';
import '../../home/model/home_model.dart';

/// 构建wpy_page中的gpa部分
class GPAPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[CurveText(), GPACurve(isPreview: true), GPAIntro()]);
  }
}

/// 曲线上面的文字，说明当前曲线的内容
class CurveText extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(30.0, 25.0, 0.0, 20.0),
        alignment: Alignment.centerLeft,
        child: Consumer<GPANotifier>(builder: (context, notifier, _) {
          return Text("${notifier.typeName()} Curve",
              style: TextStyle(
                  fontSize: 17.0,
                  color: Color.fromRGBO(53, 59, 84, 1.0),
                  fontWeight: FontWeight.bold));
        }),
      );
}

/// wpy_page中显示数值信息
class GPAIntro extends StatelessWidget {
  static const textStyle = TextStyle(
      color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13.0);

  static const numStyle = TextStyle(
      color: Color.fromRGBO(53, 59, 84, 1.0),
      fontWeight: FontWeight.bold,
      fontSize: 25.0);

  @override
  Widget build(BuildContext context) {
    return Consumer<GPANotifier>(builder: (context, gpaNotifier, _) {
      var weighted = "不";
      var grade = "知";
      var credit = "道";
      if (gpaNotifier.totalWithNotify != null) {
        weighted = gpaNotifier.totalWithNotify.weighted.toString();
        grade = gpaNotifier.totalWithNotify.gpa.toString();
        credit = gpaNotifier.totalWithNotify.credits.toString();
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('Total Weighted', style: textStyle),
              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(weighted, style: numStyle))
            ],
          ),
          Column(
            children: <Widget>[
              Text('Total Grade', style: textStyle),
              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(grade, style: numStyle))
            ],
          ),
          Column(
            children: <Widget>[
              Text('Total Credit', style: textStyle),
              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(credit, style: numStyle))
            ],
          )
        ],
      );
    });
  }
}

/// GPA曲线的总体由[Stack]构成
/// Stack的底层为静态的[_GPACurvePainter],由cubic曲线和黑点构成
/// Stack的顶层为动态的[_GPAPopupPainter],用补间动画控制移动
class GPACurve extends StatefulWidget {
  /// 是否在wpy_page中显示（false的话就是在gpa_page中呗）
  final bool isPreview;

  GPACurve({@required this.isPreview});

  @override
  _GPACurveState createState() => _GPACurveState();
}

class _GPACurveState extends State<GPACurve>
    with SingleTickerProviderStateMixin {
  static const Color _popupCardPreview = Colors.white;
  static const Color _popupTextPreview = Color.fromRGBO(53, 59, 84, 1.0);

  static const Color _popupCardColor = Color.fromRGBO(150, 160, 120, 1);
  static const Color _popupTextColor = Colors.white;

  static const double _canvasHeight = 120; // 用于控制曲线canvas的高度

  /// 上次 / 本次选中的点
  int _lastTaped = 1;
  int _newTaped = 1;

  @override
  Widget build(BuildContext context) {
    return Consumer<GPANotifier>(builder: (context, gpaNotifier, _) {
      if (gpaNotifier.currentDataWithNotify == null)
        return Container(height: 20);
      if (_lastTaped == _newTaped) {
        _lastTaped = gpaNotifier.indexWithNotify + 1;
        _newTaped = _lastTaped;
      }
      List<Point<double>> points = [];
      List<double> curveData = gpaNotifier.curveDataWithNotify;
      _initPoints(points, curveData);
      return GestureDetector(

          /// 点击监听
          onTapDown: (TapDownDetails detail) {
            RenderBox renderBox = context.findRenderObject();
            var localOffset = renderBox.globalToLocal(detail.globalPosition);
            var result = _judgeTaped(localOffset, points, r: 50);
            if (result != 0) {
              setState(() => _newTaped = result);
              gpaNotifier.indexWithNotify = result - 1;
            }
          },
          //TODO 滑动监听，出了点问题，总之先砍掉（selected已经删了）
          // onHorizontalDragUpdate: (DragUpdateDetails detail) {
          //   RenderBox renderBox = context.findRenderObject();
          //   var localOffset = renderBox.globalToLocal(detail.globalPosition);
          //   setState(() {
          //     selected = judgeSelected(localOffset);
          //   });
          // },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Stack(
              children: <Widget>[
                /// Stack底层
                CustomPaint(
                  painter: _GPACurvePainter(
                      isPreview: widget.isPreview,
                      points: points,
                      taped: _newTaped),
                  size: Size(double.maxFinite, _canvasHeight),
                ),

                /// Stack顶层
                TweenAnimationBuilder(
                  duration: Duration(milliseconds: 300),
                  tween: Tween(
                      begin: 0.0, end: (_lastTaped == _newTaped) ? 0.0 : 1.0),
                  onEnd: () => setState(() => _lastTaped = _newTaped),
                  builder: (BuildContext context, value, Widget child) {
                    var lT = points[_lastTaped], nT = points[_newTaped];
                    return Transform.translate(
                      /// 计算两次点击之间的偏移量Offset
                      /// 40.0和55.0用来对准黑白圆点的圆心(与下方container大小有关)
                      offset: Offset(lT.x - 40 + (nT.x - lT.x) * value,
                          lT.y - 55 + (nT.y - lT.y) * value),
                      child: Container(
                        width: 80,
                        height: 70,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 80,
                              height: 40,
                              child: Card(
                                color: widget.isPreview
                                    ? _popupCardPreview
                                    : _popupCardColor,
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: Text('${curveData[_newTaped - 1]}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: widget.isPreview
                                              ? _popupTextPreview
                                              : _popupTextColor,
                                          fontWeight: FontWeight.w900)),
                                ),
                              ),
                            ),
                            CustomPaint(
                              painter:
                                  _GPAPopupPainter(isPreview: widget.isPreview),
                              size: Size(80, 30),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ));
    });
  }

  /// Canvas上下各留高度为20的空白区域，并在中间进行绘制

  _initPoints(List<Point<double>> points, List<double> list) {
    var width = GlobalModel().screenWidth;
    var step = width / (list.length + 1);
    var h1 = _canvasHeight - 20; // canvas除去上面的空白
    var h2 = _canvasHeight - 40; // canvas中间区域大小

    /// 求gpa最小值（算上起止）与最值差，使曲线高度符合比例
    var minStat = list.reduce(min);
    var maxStat = list.reduce(max);
    var gap = maxStat - minStat;
    points.add(Point(0, h1 - (list.first - minStat) / gap * h2));
    for (var i = 0; i < list.length; i++) {
      points.add(Point((i + 1) * step, h1 - (list[i] - minStat) / gap * h2));
    }
    points.add(Point(width, h1 - (list.last - minStat) / gap * h2));
  }

  /// 判断触碰位置是否在任意圆内, 此处的r大于点的默认半径radius,使圆点易触
  int _judgeTaped(Offset touchOffset, List<Point<double>> points,
      {double r = 15.0}) {
    var sx = touchOffset.dx;
    var sy = touchOffset.dy;
    for (var i = 1; i < points.length - 1; i++) {
      var x = points[i].x;
      var y = points[i].y;
      if (!((sx - x) * (sx - x) + (sy - y) * (sy - y) > r * r)) return i;
    }
    return 0;
  }
}

/// 绘制GPACurve栈上层的可移动点
class _GPAPopupPainter extends CustomPainter {
  final bool isPreview;

  _GPAPopupPainter({@required this.isPreview});

  /// 在wpy_page显示的颜色
  static const Color _outerPreview = Color.fromRGBO(53, 59, 84, 1.0);
  static const Color _innerPreview = Colors.white;

  // TODO 多搞几套主题颜色
  /// 在gpa_page显示的颜色
  static const Color _outerColor = Colors.white;
  static const Color _innerColor = Color.fromRGBO(125, 140, 85, 1);

  static const _outerWidth = 4.0;
  static const _innerRadius = 5.0;
  static const _outerRadius = 7.0;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint innerPaint = Paint()
      ..color = isPreview ? _innerPreview : _innerColor
      ..style = PaintingStyle.fill;
    final Paint outerPaint = Paint()
      ..color = isPreview ? _outerPreview : _outerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _outerWidth;
    canvas.drawCircle(size.center(Offset.zero), _innerRadius, innerPaint);
    canvas.drawCircle(size.center(Offset.zero), _outerRadius, outerPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) => false;
}

/// 绘制GPACurve栈底层的曲线、黑点
class _GPACurvePainter extends CustomPainter {
  final bool isPreview;
  final List<Point<double>> points;
  final int taped;

  const _GPACurvePainter(
      {@required this.isPreview, @required this.points, @required this.taped});

  static const Color _linePreview = Color.fromRGBO(230, 230, 230, 1.0);
  static const Color _pointPreview = Color.fromRGBO(116, 119, 138, 1.0);

  static const Color _lineColor = Color.fromRGBO(136, 147, 100, 1);
  static const Color _pointColor = Colors.white;

  _drawLine(Canvas canvas, List<Point<double>> points) {
    final Paint paint = Paint()
      ..color = isPreview ? _linePreview : _lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    final Path path = Path()
      ..moveTo(0, points[0].y)
      ..cubicThrough(points);
    canvas.drawPath(path, paint);
  }

  /// 默认黑点半径为6.0，选中后为8.0
  _drawPoint(Canvas canvas, List<Point<double>> points, int selected,
      {double radius = 6.0}) {
    final Paint paint = Paint()
      ..color = isPreview ? _pointPreview : _pointColor
      ..style = PaintingStyle.fill;
    for (var i = 1; i < points.length - 1; i++) {
      if (i == selected)
        canvas.drawCircle(
            Offset(points[i].x, points[i].y), radius + 2.0, paint);
      else
        canvas.drawCircle(Offset(points[i].x, points[i].y), radius, paint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawLine(canvas, points);
    _drawPoint(canvas, points, taped);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) => false;
}

/// 利用点坐标数组绘制三阶贝塞尔曲线
/// cp1和cp2为辅助点
extension Cubic on Path {
  cubicThrough(List<Point<double>> list) {
    for (var i = 0; i < list.length - 1; i++) {
      var point1 = list[i];
      var point2 = list[i + 1];

      ///调整bias可以控制曲线起伏程度
      var biasX = (point2.x - point1.x) * 0.3;
      var biasY = (point1.y == point2.y) ? 2 : 0;
      var cp1 = Point(point1.x + biasX, point1.y - biasY);
      var cp2 = Point(point2.x - biasX, point2.y + biasY);
      cubicTo(cp1.x, cp1.y, cp2.x, cp2.y, point2.x, point2.y);
    }
  }
}