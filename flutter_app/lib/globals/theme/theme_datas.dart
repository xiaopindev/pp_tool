import 'package:flutter/material.dart';

/*
根据primaryColor主题色自动生成搭配颜色值
https://material-foundation.github.io/material-theme-builder/

开发过程中，可以参考色块面板进行使用哪个值

加一个颜色主题，就往datas中创建该颜色的light和dark模式的颜色值配置
*/

part 'datas/orange1_light.dart';
part 'datas/orange1_dark.dart';
part 'datas/blue1_light.dart';
part 'datas/blue1_dark.dart';
part 'datas/green1_light.dart';
part 'datas/green1_dark.dart';
part 'datas/purple1_light.dart';
part 'datas/purple1_dark.dart';
part 'datas/pink1_light.dart';
part 'datas/pink1_dark.dart';
part 'datas/red1_light.dart';
part 'datas/red1_dark.dart';

class ThemeDatas {
  static final ThemeData orange1Light = _orange1Light;
  static final ThemeData orange1Dark = _orange1Dark;
  static final ThemeData blue1Light = _blue1Light;
  static final ThemeData blue1Dark = _blue1Dark;
  static final ThemeData green1Light = _green1Light;
  static final ThemeData green1Dark = _green1Dark;
  static final ThemeData purple1Light = _purple1Light;
  static final ThemeData purple1Dark = _purple1Dark;
  static final ThemeData pink1Light = _pink1Light;
  static final ThemeData pink1Dark = _pink1Dark;
  static final ThemeData red1Light = _red1Light;
  static final ThemeData red1Dark = _red1Dark;

  //模版说明
  static final ThemeData template = ThemeData(
    // 启用 Material 3 主题
    useMaterial3: true,

    // 亮度，表示颜色方案是亮色还是暗色
    brightness: Brightness.light,

    // 用于生成 ColorScheme 的种子颜色
    colorSchemeSeed: Colors.blue,

    // 画布颜色，通常用于 Scaffold 的背景颜色
    canvasColor: Colors.white,

    // 卡片颜色，通常用于 Card 组件的背景颜色
    cardColor: Colors.white,

    // 对话框背景颜色
    dialogBackgroundColor: Colors.white,

    // 禁用状态的颜色
    disabledColor: Colors.grey,

    // 分隔符颜色
    dividerColor: Colors.grey,

    // 焦点颜色
    focusColor: Colors.blue,

    // 高亮颜色
    highlightColor: Colors.blueAccent,

    // 提示颜色，通常用于输入框的提示文本颜色
    hintColor: Colors.grey,

    // 悬停颜色
    hoverColor: Colors.blue[100],

    // 指示器颜色，通常用于进度条等
    indicatorColor: Colors.blue,

    // 主要颜色，用于应用的主要部分，如 AppBar、按钮等
    primaryColor: Colors.blue,

    // 主要颜色的暗色变体
    primaryColorDark: Colors.blue[700],

    // 主要颜色的亮色变体
    primaryColorLight: Colors.blue[100],

    // Scaffold 的背景颜色
    scaffoldBackgroundColor: Colors.white,

    // 次要标题颜色
    secondaryHeaderColor: Colors.blueAccent,

    // 阴影颜色
    shadowColor: Colors.black,

    // 水波纹颜色
    splashColor: Colors.blueAccent,

    // 未选中组件的颜色
    unselectedWidgetColor: Colors.grey,

    // 字体家族
    fontFamily: 'Roboto',

    // 主要颜色的色板
    primarySwatch: Colors.blue,

    // 颜色方案
    colorScheme: ColorScheme(
      primary: Colors.blue, // 主要颜色
      primaryContainer: Colors.blue[700], // 主要颜色容器
      secondary: Colors.green, // 次要颜色
      secondaryContainer: Colors.green[700], // 次要颜色容器
      surface: Colors.white, // 背景颜色
      error: Colors.red, // 错误颜色
      onPrimary: Colors.white, // 主要颜色上的内容颜色
      onSecondary: Colors.black, // 次要颜色上的内容颜色
      onSurface: Colors.black, // 背景颜色上的内容颜色
      onError: Colors.white, // 错误颜色上的内容颜色
      brightness: Brightness.light, // 亮度
    ),
  );
}
