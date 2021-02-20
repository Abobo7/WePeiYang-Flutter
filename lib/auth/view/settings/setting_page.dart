import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:wei_pei_yang_demo/commons/preferences/common_prefs.dart';
import 'package:wei_pei_yang_demo/gpa/model/gpa_notifier.dart';
import 'package:wei_pei_yang_demo/schedule/model/schedule_notifier.dart';

class SettingPage extends StatefulWidget {
  final _state = _SettingPageState();

  @override
  _SettingPageState createState() => _state;
}

class _SettingPageState extends State<SettingPage> {
  var pref = CommonPreferences();

  @override
  Widget build(BuildContext context) {
    const titleTextStyle = TextStyle(
        fontSize: 14,
        color: Color.fromRGBO(177, 180, 186, 1),
        fontWeight: FontWeight.bold);
    const mainTextStyle = TextStyle(
        fontSize: 15,
        color: Color.fromRGBO(98, 103, 122, 1),
        fontWeight: FontWeight.bold);
    const hintTextStyle =
        TextStyle(fontSize: 10.5, color: Color.fromRGBO(205, 206, 212, 1));
    const arrow = Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 22);
    return Scaffold(
      appBar: AppBar(
          title: Text('设置',
              style: TextStyle(
                  fontSize: 19,
                  color: Color.fromRGBO(36, 43, 69, 1),
                  fontWeight: FontWeight.bold)),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: GestureDetector(
                child: Icon(Icons.arrow_back,
                    color: Color.fromRGBO(53, 59, 84, 1.0), size: 32),
                onTap: () => Navigator.pop(context)),
          )),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
            alignment: Alignment.centerLeft,
            child: Text('通用', style: titleTextStyle),
          ),
          Container(
            height: 80,
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)),
              child: InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, '/language_setting').then((_) {
                  /// 使用pop返回此页面时进行rebuild
                  widget._state.setState(() {});
                }),
                splashFactory: InkRipple.splashFactory,
                borderRadius: BorderRadius.circular(9),
                child: Row(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 150,
                            margin: const EdgeInsets.only(left: 15),
                            child: Text('系统语言', style: mainTextStyle)),
                        Container(
                            width: 150,
                            margin: const EdgeInsets.only(left: 15, top: 3),
                            child: Text('${pref.language.value}',
                                style: hintTextStyle,
                                textAlign: TextAlign.left))
                      ],
                    ),
                    Expanded(child: Text('')),
                    Padding(
                        padding: const EdgeInsets.only(right: 26), child: arrow)
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 80,
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)),
              child: InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, '/color_setting').then((_) {
                  /// 使用pop返回此页面时进行rebuild
                  widget._state.setState(() {});
                }),
                splashFactory: InkRipple.splashFactory,
                borderRadius: BorderRadius.circular(9),
                child: Row(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: 230,
                            margin: const EdgeInsets.only(left: 15),
                            child: Text('调色板', style: mainTextStyle)),
                        Container(
                            width: 230,
                            margin: const EdgeInsets.only(left: 15, top: 3),
                            child: Text('给课表、GPA以及黄页自定义喜欢的颜色',
                                style: hintTextStyle))
                      ],
                    ),
                    Expanded(child: Text('')),
                    Padding(
                        padding: const EdgeInsets.only(right: 26), child: arrow)
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 80,
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Container(
                        width: 150,
                        child: Text('首页不显示GPA', style: mainTextStyle)),
                  ),
                  Expanded(child: Text('')),
                  Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Switch(
                        value: pref.hideGPA.value,
                        onChanged: (value) {
                          setState(() => pref.hideGPA.value = value);
                          Provider.of<GPANotifier>(context, listen: false).hideGPAWithNotify = value;
                        },
                        activeColor: Color.fromRGBO(105, 109, 127, 1),
                        inactiveThumbColor: Color.fromRGBO(205, 206, 212, 1),
                        activeTrackColor: Color.fromRGBO(240, 241, 242, 1),
                        inactiveTrackColor: Color.fromRGBO(240, 241, 242, 1),
                      ))
                ],
              ),
            ),
          ),
          Container(
            height: 80,
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)),
              child: Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 210,
                          margin: const EdgeInsets.only(left: 15),
                          child: Text('开启夜猫子模式', style: mainTextStyle)),
                      Container(
                          width: 210,
                          margin: const EdgeInsets.only(left: 15, top: 3),
                          child: Text(
                            '晚上9:00以后首页课表将展示第二天课程安排',
                            style: hintTextStyle,
                          ))
                    ],
                  ),
                  Expanded(child: Text('')),
                  Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Switch(
                        value: pref.nightMode.value,
                        onChanged: (value) {
                          setState(() => pref.nightMode.value = value);
                          Provider.of<ScheduleNotifier>(context, listen: false).nightMode =
                              value;
                        },
                        activeColor: Color.fromRGBO(105, 109, 127, 1),
                        inactiveThumbColor: Color.fromRGBO(205, 206, 212, 1),
                        activeTrackColor: Color.fromRGBO(240, 241, 242, 1),
                        inactiveTrackColor: Color.fromRGBO(240, 241, 242, 1),
                      ))
                ],
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(20, 17, 20, 5),
              alignment: Alignment.centerLeft,
              child: Text('课程表', style: titleTextStyle)),
          Container(
            height: 80,
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)),
              child: InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, '/schedule_setting').then((_) {
                  /// 使用pop返回此页面时进行rebuild
                  widget._state.setState(() {});
                }),
                splashFactory: InkRipple.splashFactory,
                borderRadius: BorderRadius.circular(9),
                child: Row(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 150,
                            margin: const EdgeInsets.only(left: 15),
                            child: Text('每周显示天数', style: mainTextStyle)),
                        Container(
                            width: 150,
                            margin: const EdgeInsets.only(left: 15, top: 3),
                            child: Text('${pref.dayNumber.value}',
                                style: hintTextStyle))
                      ],
                    ),
                    Expanded(child: Text('')),
                    Padding(
                        padding: const EdgeInsets.only(right: 26), child: arrow)
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 80,
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)),
              child: Row(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 210,
                              margin: const EdgeInsets.only(left: 15),
                              child: Text('课表显示非本周课程', style: mainTextStyle)),
                          Container(
                              width: 210,
                              margin: const EdgeInsets.only(left: 15, top: 3),
                              child: Text('课表中将会展示当周并未开课的课程',
                                  style: hintTextStyle))
                        ],
                      ),
                    ],
                  ),
                  Expanded(child: Text('')),
                  Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Switch(
                        value: pref.otherWeekSchedule.value,
                        onChanged: (value) {
                          setState(() => pref.otherWeekSchedule.value = value);
                        },
                        activeColor: Color.fromRGBO(105, 109, 127, 1),
                        inactiveThumbColor: Color.fromRGBO(205, 206, 212, 1),
                        activeTrackColor: Color.fromRGBO(240, 241, 242, 1),
                        inactiveTrackColor: Color.fromRGBO(240, 241, 242, 1),
                      ))
                ],
              ),
            ),
          ),
          Container(
            height: 80,
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)),
              child: Row(
                children: <Widget>[
                  Container(
                      width: 150,
                      margin: const EdgeInsets.only(left: 15),
                      child: Text('开课前提醒', style: mainTextStyle)),
                  Expanded(child: Text('')),
                  Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Switch(
                        value: pref.remindBeforeStart.value,
                        onChanged: (value) {
                          setState(() => pref.remindBeforeStart.value = value);
                        },
                        activeColor: Color.fromRGBO(105, 109, 127, 1),
                        inactiveThumbColor: Color.fromRGBO(205, 206, 212, 1),
                        activeTrackColor: Color.fromRGBO(240, 241, 242, 1),
                        inactiveTrackColor: Color.fromRGBO(240, 241, 242, 1),
                      ))
                ],
              ),
            ),
          ),
          Card(
              margin: EdgeInsets.fromLTRB(20, 5, 20, 30),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: 150,
                          margin: const EdgeInsets.only(left: 15),
                          child: Text('课前提醒', style: mainTextStyle)),
                      Expanded(child: Text('')),
                      Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Switch(
                            value: pref.remindBefore.value,
                            onChanged: (value) {
                              setState(() => pref.remindBefore.value = value);
                            },
                            activeColor: Color.fromRGBO(105, 109, 127, 1),
                            inactiveThumbColor:
                                Color.fromRGBO(205, 206, 212, 1),
                            activeTrackColor: Color.fromRGBO(240, 241, 242, 1),
                            inactiveTrackColor:
                                Color.fromRGBO(240, 241, 242, 1),
                          ))
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
                    height: 1.0,
                    color: Color.fromRGBO(212, 214, 226, 1),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Text('课前提醒时间', style: mainTextStyle)),
                      Expanded(child: Text('')),
                      Container(
                          margin: const EdgeInsets.only(right: 25),
                          child: Text('15分钟', style: hintTextStyle)),
                    ],
                  ),
                  Container(height: 15)
                ],
              )),
        ],
      ),
    );
  }
}