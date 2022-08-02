// @dart = 2.12
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_pei_yang_flutter/feedback/view/components/widget/april_fool_dialog.dart';
import 'package:we_pei_yang_flutter/main.dart';
import 'package:we_pei_yang_flutter/auth/view/info/tju_rebind_dialog.dart';
import 'package:we_pei_yang_flutter/commons/network/wpy_dio.dart'
    show WpyDioError;
import 'package:we_pei_yang_flutter/commons/preferences/common_prefs.dart';
import 'package:we_pei_yang_flutter/commons/util/router_manager.dart';
import 'package:we_pei_yang_flutter/commons/util/toast_provider.dart';
import 'package:we_pei_yang_flutter/commons/util/font_manager.dart';
import 'package:we_pei_yang_flutter/gpa/view/classes_need_vpn_dialog.dart';
import 'package:we_pei_yang_flutter/schedule/extension/logic_extension.dart';
import 'package:we_pei_yang_flutter/schedule/model/course_provider.dart';
import 'package:we_pei_yang_flutter/schedule/model/edit_provider.dart';
import 'package:we_pei_yang_flutter/schedule/view/course_detail_widget.dart';
import 'package:we_pei_yang_flutter/schedule/view/edit_bottom_sheet.dart';
import 'package:we_pei_yang_flutter/schedule/view/week_select_widget.dart';

/// 课表总页面
class CoursePage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  /// 进入课程表页面后重设选中周并自动刷新数据
  _CoursePageState() {
    var provider =
        WePeiYangApp.navigatorState.currentContext!.read<CourseProvider>();
    provider.quietResetWeek();
    provider.refreshCourse();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      /// 初次使用课表时展示办公网dialog
      if (CommonPreferences.firstUse.value) {
        CommonPreferences.firstUse.value = false;
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => ClassesNeedVPNDialog());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: WePeiYangApp.screenWidth,
          height: WePeiYangApp.screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(44, 126, 223, 1),
                Color.fromRGBO(166, 207, 255, 1),
                Color.fromRGBO(166, 207, 255, 1),
              ],
            ),
          ),
        ),
        Positioned(
          left: WePeiYangApp.screenWidth - 518,
          top: -42,
          height: 500,
          width: 500,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10000),
            child: Container(
              color: Color.fromRGBO(44, 126, 223, 0.5),
            ),
          ),
        ),
        Positioned(
          left: WePeiYangApp.screenWidth - 481,
          top: WePeiYangApp.screenHeight * 0.65,
          height: 512,
          width: 434,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10000),
            child: Container(
              color: Color.fromRGBO(199, 213, 235, 1),
            ),
          ),
        ),
        Positioned(
          left: 37,
          top: WePeiYangApp.screenHeight * 0.5,
          height: 436,
          width: 436,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10000),
            child: Container(
              color: Color.fromRGBO(129, 187, 255, 0.5),
            ),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(color: Colors.transparent),
          ),
        ),
        Scaffold(
          appBar: _CourseAppBar(),
          backgroundColor: Colors.transparent,
          body: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              _TitleWidget(),
              WeekSelectWidget(),
              Container(
                decoration: CommonPreferences.isSkinUsed.value
                    ? BoxDecoration(
                        image: DecorationImage(
                            image:
                                NetworkImage(CommonPreferences.skinClass.value),
                            fit: BoxFit.cover),
                      )
                    : BoxDecoration(),
                child: Column(
                  children: [CourseDetailWidget(), _HoursCounterWidget()],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 课表页默认AppBar
class _CourseAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    var leading = Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(),
          padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
          child: Image.asset(
            'assets/images/schedule/back.png',
            height: 18,
            width: 18,
            color: Colors.white,
          ),
        ),
      ),
    );

    var actions = [
      GestureDetector(
        onTap: () {
          if (CommonPreferences.isAprilFoolClass.value &&
              DateTime.now().day == 1 &&
              DateTime.now().month == 4) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AprilFoolDialog(
                    content: "愚人节快乐呀！",
                    confirmText: "返回真实课表",
                    cancelText: "保留多色",
                    confirmFun: () {
                      CommonPreferences.isAprilFoolClass.value = false;
                      Navigator.pop(context);
                      Navigator.popAndPushNamed(context, HomeRouter.home);
                    },
                  );
                });
          }
          if (!CommonPreferences.isBindTju.value) {
            ToastProvider.error("请绑定办公网");
            Navigator.pushNamed(context, AuthRouter.tjuBind);
            return;
          }
          context.read<CourseProvider>().refreshCourse(
              hint: true,
              onFailure: (e) {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) => TjuRebindDialog(
                    reason: e is WpyDioError ? e.error.toString() : null,
                  ),
                );
              });
        },
        child: Container(
          decoration: BoxDecoration(),
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            'assets/images/schedule/refresh.png',
            height: 20,
            width: 20,
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ScheduleRouter.customCourse);
        },
        child: Container(
          decoration: BoxDecoration(),
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            'assets/images/schedule/list.png',
            height: 20,
            width: 20,
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          var pvd = context.read<EditProvider>();
          pvd.init();
          showModalBottomSheet(
            context: context,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            isDismissible: false,
            enableDrag: false,
            isScrollControlled: false,
            builder: (context) => EditBottomSheet(pvd.nameSave, pvd.creditSave),
          );
        },
        child: Container(
          decoration: BoxDecoration(),
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            'assets/images/schedule/add.png',
            height: 20,
            width: 20,
          ),
        ),
      ),
      SizedBox(width: 5),
    ];

    return AppBar(
      backgroundColor: Colors.transparent,
      brightness: Brightness.light,
      elevation: 0,
      leading: leading,
      leadingWidth: 40,
      actions: actions,
      title: Text(
        "HELLO, ${CommonPreferences.nickname.value}",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
      ),
      titleSpacing: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// 课表页标题栏
class _TitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
      child: Row(
        children: [
          Text('Schedule',
              style: FontManager.YaQiHei.copyWith(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 18,
                  fontWeight: FontWeight.w900)),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: Builder(builder: (context) {
              var currentWeek =
                  context.select<CourseProvider, int>((p) => p.currentWeek);
              return Text('WEEK $currentWeek',
                  style: FontManager.Texta.copyWith(
                      color: Color.fromRGBO(202, 202, 202, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.bold));
            }),
          ),
          Builder(builder: (context) {
            var provider = context.watch<CourseDisplayProvider>();
            return GestureDetector(
                onTap: () {
                  provider.shrink = !provider.shrink;
                },
                child: Container(
                  decoration: BoxDecoration(),
                  padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                  child: Image.asset(
                      provider.shrink
                          ? 'assets/images/schedule/up.png'
                          : 'assets/images/schedule/down.png',
                      color: Colors.white,
                      height: 18,
                      width: 18),
                ));
          })
        ],
      ),
    );
  }
}

/// 课表页底部学时统计栏
class _HoursCounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var provider = context.watch<CourseProvider>();
    // if (provider.schoolCourses.length == 0) return Container();
    // int currentHours = getCurrentHours(
    //     provider.currentWeek, DateTime.now().weekday, provider.schoolCourses);
    // int totalHours = getTotalHours(provider.schoolCourses);

    int currentHours = 35;
    int totalHours = 100;

    double totalWidth = WePeiYangApp.screenWidth - 2 * 15;
    double leftWidth = totalWidth * currentHours / totalHours;
    if (leftWidth > totalWidth) leftWidth = totalWidth;

    /// 如果学期还没开始，则不显示学时
    if (isBeforeTermStart) leftWidth = 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.centerLeft,
              child: Text("Total Class Hours: $totalHours",
                  style: FontManager.Aspira.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold))),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 12,
                width: totalWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black12),
              ),
              Container(
                height: 8,
                width: leftWidth,
                margin: EdgeInsets.only(left: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white54],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 45)
        ],
      ),
    );
  }
}
