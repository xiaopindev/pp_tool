import 'package:dynamic_icon_flutter/dynamic_icon_flutter.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_app/configs/events.dart';
import 'package:flutter_app/generated/assets.dart';
import 'package:flutter_app/modules/common/base/base_controller.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';

import '../../globals/theme/theme_controller.dart';

class IndividuationController extends BaseController {
  /* #region 状态属性 */

  var isPlayerFadeInOutEnabled = false.obs;
  var appIconId = 0.obs;
  var playerThemeIndex = 0.obs;

  /* #endregion */

  /* #region 私有属性 */
  final appIcons = [
    A.imageAppIcon0,
    A.imageAppIcon1,
    A.imageAppIcon2,
    A.imageAppIcon3,
    A.imageAppIcon4,
  ];
  final playerThemes = [
    A.imagePlayerTheme0,
    A.imagePlayerTheme1,
    A.imagePlayerTheme2,
  ];
  final playerThemesIds = [
    10000,
    10001,
    10002,
  ];
  /* #endregion */

  /* #region 公开属性 */
  final themeVC = Get.find<ThemeController>();
  /* #endregion */

  /* #region 基类方法 */
  @override
  void onInit() {
    super.onInit();
    appIconId.value = app.appIcon;
    playerThemeIndex.value = playerThemesIds.indexOf(app.playerThemeId);
  }

  @override
  void initData() {
    super.initData();
    Logger.trace('初始化数据');
  }

  @override
  void reloadData() async {}
  /* #endregion */

  /* #region 自定义方法 */

  /* #endregion */

  /* #region 自定义事件 */

  void changeAppearance(bool value) {
    global.logEvent('sets_darkmode_$value');
    if (!global.isVip.value) {
      global.showSubscriptionPage();
      return;
    }
    app.sp?.setBool('isDarkMode', value);
    themeVC.isDarkMode.value = value;
    themeVC.reloadTheme();
    eventBus.send(ThemeChangedEvent('theme_changed'));
    update();
  }

  void changeThemeColorIndex(int index) {
    global.logEvent('sets_themecolor_$index');
    if (!global.isVip.value) {
      global.showSubscriptionPage();
      return;
    }
    app.sp?.setInt('themeColorIndex', index);
    themeVC.colorIndex.value = index;
    themeVC.reloadTheme();
    eventBus.send(ThemeChangedEvent('theme_changed'));
    update();
  }

  void changePlayerTheme(int index) {
    final id = playerThemesIds[index];
    if (!global.isVip.value) {
      global.showSubscriptionPage();
      return;
    }
    global.logEvent('sets_playerthemeid_$id');
    app.setPlayerThemeId(id);
    // Get.find<PlayerThemeController>().buildThemeById(id);
    // playerThemeIndex.value = index;
  }

  void setAppIcon(int index) async {
    global.logEvent('sets_setappicon');
    if (!global.isVip.value) {
      global.showSubscriptionPage();
      return;
    }
    try {
      if (index == 0) {
        if (await DynamicIconFlutter.supportsAlternateIcons) {
          await DynamicIconFlutter.setAlternateIconName(null);
          Logger.log("Change app icon back to default");
          app.setAppIcon(0);
          appIconId.value = 0;
          return;
        } else {
          Logger.log("Failed to change app icon");
        }

        return;
      }
      //换图标风格的话：icon2这个要改名
      final iconName = 'icon2_0$index';
      Logger.log('iconName $iconName');
      if (await DynamicIconFlutter.supportsAlternateIcons) {
        await DynamicIconFlutter.setAlternateIconName(iconName);
        app.setAppIcon(index);
        appIconId.value = index;
        Logger.log("App icon change successful");
      } else {
        Logger.log("Current device does not support alternate icons");
      }
    } on PlatformException catch (e) {
      if (await DynamicIconFlutter.supportsAlternateIcons) {
        await DynamicIconFlutter.setAlternateIconName(null);
        Logger.log("Change app icon back to default");
        app.setAppIcon(0);
        appIconId.value = 0;
        return;
      } else {
        Logger.log("Failed to change app icon ${e.toString()}");
      }
    }
  }
  /* #endregion */
}
