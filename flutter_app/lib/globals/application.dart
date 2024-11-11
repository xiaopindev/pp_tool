import 'dart:async';
import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_app/globals/app_global.dart';
import 'package:flutter_app/globals/network.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class XPApplication {
  static final XPApplication _instance = XPApplication._internal();
  factory XPApplication() => _instance;
  XPApplication._internal() {
    init();
  }

  SharedPreferences? sp;
  PackageInfo? packageInfo;
  Timer? _vipExpiryTimer;
  final network = Get.find<NetworkController>();

  /* #region isFirstLaunch */
  bool _isFirstLaunch = true;
  bool get isFirstLaunch => _isFirstLaunch;
  Future<void> setIsFirstLaunch(bool value) async {
    if (_isFirstLaunch != value) {
      _isFirstLaunch = value;
      await sp?.setBool('isFirstLaunch', value);
    }
  }
  /* #endregion */

  /* #region languageCode */
  var _languageCode = 'sys';
  String get languageCode => _languageCode;
  Future<void> setLanguageCode(String value) async {
    if (_languageCode != value) {
      _languageCode = value;
      await sp?.setString('languageCode', value);
    }
  }
  /* #endregion */

  /* #region isVip */
  bool _isVip = false;
  bool get isVip => _isVip;
  Future<void> setIsVip(bool value) async {
    if (_isVip != value) {
      _isVip = value;
      await sp?.setBool('isVip', value);
      setPlayFadeInout(true);
    }
  }

  //是否已经订阅过周会员
  bool _isSubscribed = false;
  bool get isSubscribed => _isSubscribed;
  Future<void> setIsSubscribed(bool value) async {
    if (_isSubscribed != value) {
      _isSubscribed = value;
      await sp?.setBool('isSubscribed', value);
    }
  }

  //最后一次订阅时间
  int _lastPurchaseTime = 0;
  int get lastPurchaseTime => _lastPurchaseTime;
  Future<void> setLastPurchaseTime(int value) async {
    if (_lastPurchaseTime != value) {
      _lastPurchaseTime = value;
      await sp?.setInt('lastPurchaseTime', value);
    }
  }

  //会员过期时间
  int _expireTime = 0;
  int get expireTime => _expireTime;
  Future<void> setExpireTime(int value) async {
    if (_expireTime != value) {
      _expireTime = value;
      await sp?.setInt('expireTime', value);
    }
  }
  /* #endregion */

  /* #region 版本下次检测时间 */
  int _verNextCheckTime = 0;
  int get verNextCheckTime => _verNextCheckTime;
  Future<void> setVerNextCheckTime(int value) async {
    if (_verNextCheckTime != value) {
      _verNextCheckTime = value;
      await sp?.setInt('verNextCheckTime', value);
    }
  }
  /* #endregion */

  /* #region 应用图标ID */
  int _appIcon = 0;
  int get appIcon => _appIcon;
  Future<void> setAppIcon(int value) async {
    if (_appIcon != value) {
      _appIcon = value;
      await sp?.setInt('currentAppIcon', value);
    }
  }
  /* #endregion */

  /* #region 播放器主题ID */
  int _playerThemeId = 10000;
  int get playerThemeId => _playerThemeId;
  Future<void> setPlayerThemeId(int value) async {
    _playerThemeId = value;
    await sp?.setInt('playerThemeId', value);
  }
  /* #endregion */

  /* #region 播放淡入淡出 */
  bool _playFadeInout = true;
  bool get playFadeInout => _playFadeInout;
  Future<void> setPlayFadeInout(bool value) async {
    if (_playFadeInout != value) {
      _playFadeInout = value;
      await sp?.setBool('playFadeInout', value);
    }
  }

  /* #endregion */

  Future<void> init() async {
    Logger.trace('对象初始化');
    sp = await SharedPreferences.getInstance();
    packageInfo = await PackageInfo.fromPlatform();

    // 初始化时加载值
    _isFirstLaunch = sp?.getBool('isFirstLaunch') ?? true;
    _isVip = sp?.getBool('isVip') ?? false;
    _isSubscribed = sp?.getBool('isSubscribed') ?? false;
    _lastPurchaseTime = sp?.getInt('lastPurchaseTime') ?? 0;
    _expireTime = sp?.getInt('expireTime') ?? 0;
    _languageCode = sp?.getString('languageCode') ?? 'sys';
    _verNextCheckTime = sp?.getInt('verNextCheckTime') ?? 0;
    _appIcon = sp?.getInt('currentAppIcon') ?? 0;
    _playerThemeId = sp?.getInt('playerThemeId') ?? 10000;

    checkVip();
    checkAndStartVipExpiryListener();
    initEasyLoading();

    ever(network.isConnected, handleConnectivityChanged);

    Logger.log(
        'XPApplication init done isVip:$_isVip, 过期时间:${DateTime.fromMillisecondsSinceEpoch(_expireTime)}, languageCode:$_languageCode');
  }

  void clearVip() async {
    await setIsVip(false);
    await setLastPurchaseTime(0);
    await setExpireTime(0);

    final global = Get.find<AppGlobal>();
    global.isVip.value = isVip;
  }

  void checkVip() async {
    _isVip = sp?.getBool('isVip') ?? false;
    _expireTime = sp?.getInt('expireTime') ?? 0;
    if (isVip) {
      if (expireTime < DateTime.now().millisecondsSinceEpoch) {
        await setIsVip(false);
        await setExpireTime(0);
        Logger.log('检测到会员过期，会员状态重置');
      } else {
        Logger.log(
            '检测到是会员， 过期时间为: ${DateTime.fromMillisecondsSinceEpoch(expireTime)}');
      }
    } else {
      Logger.log('检测到不是会员');
    }
    final global = Get.find<AppGlobal>();
    global.isVip.value = isVip;
  }

  void checkAndStartVipExpiryListener() {
    _expireTime = sp?.getInt('expireTime') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final timeDifference = _expireTime - now;

    if (timeDifference > 0 && timeDifference <= 15 * 60 * 1000) {
      // 如果在15分钟之内，开启实时监听
      _vipExpiryTimer?.cancel();
      _vipExpiryTimer = Timer(Duration(milliseconds: timeDifference), () async {
        await setIsVip(false);
        await setExpireTime(0);
        Logger.log('会员已过期，状态已重置');
      });
      Logger.log('已开启会员过期实时监听');
    } else {
      Logger.log('会员过期时间不在15分钟之内，无需开启实时监听');
      _vipExpiryTimer?.cancel();
      _vipExpiryTimer = null;
    }
  }

  void initEasyLoading() {
    /*
    loadingStyle = EasyLoadingStyle.dark;
    indicatorType = EasyLoadingIndicatorType.fadingCircle;
    maskType = EasyLoadingMaskType.none;
    toastPosition = EasyLoadingToastPosition.center;
    animationStyle = EasyLoadingAnimationStyle.opacity;
    textAlign = TextAlign.center;
    indicatorSize = 40.0;
    radius = 5.0;
    fontSize = 15.0;
    progressWidth = 2.0;
    lineWidth = 4.0;
    displayDuration = const Duration(milliseconds: 2000);
    animationDuration = const Duration(milliseconds: 200);
    textPadding = const EdgeInsets.only(bottom: 10.0);
    contentPadding = const EdgeInsets.symmetric(
      vertical: 15.0,
      horizontal: 20.0,
    );
    */
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 1000)
      ..indicatorType = EasyLoadingIndicatorType.circle
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 12.0
      ..progressColor = Get.theme.colorScheme.onPrimary
      ..backgroundColor = Get.theme.colorScheme.primary
      ..indicatorColor = Get.theme.colorScheme.onPrimary
      ..textColor = Get.theme.colorScheme.onPrimary
      ..maskType = EasyLoadingMaskType.custom
      ..maskColor = Colors.black.withOpacity(0.1)
      ..userInteractions = false
      ..dismissOnTap = false;
  }

  Future<void> handleConnectivityChanged(bool isConnected) async {
    if (!isConnected) {
      return;
    }
    final global = Get.find<AppGlobal>();
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await remoteConfig.setDefaults({"recfg": ''});
    try {
      await remoteConfig.fetchAndActivate();
      global.logEvent('rcfg_loaded_normal');
      String recfgStr = remoteConfig.getString('recfg');
      Map<String, dynamic> recfgMap = jsonDecode(recfgStr);
      String plStr = recfgMap['pl'].toString();
      Logger.trace('Fetched recfg map: $recfgMap plStr: $plStr');
      if (plStr == 'quan') {
        global.xspl.value = true;
        Logger.trace('Xspl: ${global.xspl.value}');
        return;
      }
      if (plStr.isEmpty) {
        global.xspl.value = false;
        Logger.trace('Xspl: ${global.xspl.value}');
        return;
      }
      var plStrs = plStr.split(',');
      global.xspl.value =
          plStrs.contains(global.regionCode.value.toLowerCase());
      Logger.trace(
          'Xspl: ${global.xspl.value} plStrs $plStrs regionCode: ${global.regionCode.value.toLowerCase()}');
    } catch (e) {
      global.logEvent('rcfg_loaded_error');
      Logger.trace('Failed to fetch rc: $e');
    }
  }
}
