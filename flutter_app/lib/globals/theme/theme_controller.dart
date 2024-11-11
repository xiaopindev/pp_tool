import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_datas.dart';

/*
主题是基于某个主题色，可设置暗黑和高亮色
*/
class ThemeController extends GetxController {
  final _themeData = ThemeDatas.orange1Light.obs; // 默认主题

  ThemeData get theme => _themeData.value;

  //橙，蓝，绿，紫，粉，红
  final colorStrs = [
    'FF8217',
    '3FA9EF',
    '38BE29',
    'BE63F6',
    'E03DB3',
    'EF3E6E'
  ];
  final lightThemes = [
    ThemeDatas.orange1Light,
    ThemeDatas.blue1Light,
    ThemeDatas.green1Light,
    ThemeDatas.purple1Light,
    ThemeDatas.pink1Light,
    ThemeDatas.red1Light,
  ];
  final darkThemes = [
    ThemeDatas.orange1Dark,
    ThemeDatas.blue1Dark,
    ThemeDatas.green1Dark,
    ThemeDatas.purple1Dark,
    ThemeDatas.pink1Dark,
    ThemeDatas.red1Dark,
  ];

  var isDarkMode = true.obs;
  var colorIndex = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    Logger.trace('初始化');

    final sp = await SharedPreferences.getInstance();
    isDarkMode.value = sp.getBool('isDarkMode') ?? true;
    colorIndex.value = sp.getInt('themeColorIndex') ?? 0;

    _themeData.value = isDarkMode.value
        ? darkThemes[colorIndex.value]
        : lightThemes[colorIndex.value];
  }

  void reloadTheme() {
    _themeData.value = isDarkMode.value
        ? darkThemes[colorIndex.value]
        : lightThemes[colorIndex.value];
    Get.changeTheme(_themeData.value);
    Get.forceAppUpdate();
  }
}
