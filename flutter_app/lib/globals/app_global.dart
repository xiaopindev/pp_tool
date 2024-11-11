import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';
import 'package:flutter_app/pp_kits/utils/device_util.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../configs/constants.dart';
import '../configs/routers.dart';
import '../datachannels/method_channel.dart';
import 'theme/theme_controller.dart';

/*
这个全局对象用于存放全局的属性，方法
*/
class AppGlobal extends GetxController {
  /* #region 属性 */
  var isVip = false.obs;
  var rootIndex = 0.obs;
  var langCode = 'en'.obs;
  var regionCode = 'US'.obs;
  var xspl = false.obs;

  /// 弹出系统评论数
  var rate_stars = 0;

  bool isTestEnvironment =
      const bool.fromEnvironment('dart.vm.product') == false;
  PackageInfo? _packageInfo;

  final themeVC = Get.put(ThemeController());
  /* #endregion */

  @override
  void onInit() async {
    super.onInit();
    Logger.trace('对象初始化');

    //1.初始化方法通道
    MethodChannelHandler().setupChannel();

    //2.获取设备和应用信息
    _packageInfo ??= await PackageInfo.fromPlatform();
    final locale = await savedLocale();

    final deviceInfoPlugin = DeviceInfoPlugin();
    String deviceModel = '';
    String osVersion = '';

    if (GetPlatform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      deviceModel = androidInfo.model;
      osVersion = 'Android ${androidInfo.version.release}';
    } else if (GetPlatform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      deviceModel = DeviceUtil().iosModelName(iosInfo.utsname.machine);
      osVersion = 'iOS ${iosInfo.systemVersion}';
    }

    //3.初始化 Firebase
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    FirebaseAnalytics.instance.setDefaultEventParameters({
      'version': _packageInfo!.version,
      'language': locale.languageCode,
      'device_model': deviceModel,
      'os_version': osVersion,
    });

    //4.初始化评星数
    rate_stars =
        (await SharedPreferences.getInstance()).getInt('rate_star_count') ?? 0;
  }

  @override
  void onClose() {
    MethodChannelHandler().dispose();
    super.onClose();
  }

  Future<void> reportErrorToCrashlytics(
      String errorMsg, dynamic exception, StackTrace stackTrace) async {
    try {
      // 记录非致命错误
      await FirebaseCrashlytics.instance
          .recordError(exception, stackTrace, reason: errorMsg);
      Logger.trace('错误日志上报到 Firebase Crashlytics 成功');
    } catch (e) {
      Logger.trace('错误日志上报到 Firebase Crashlytics 失败: $e');
    }
  }

  void logEvent(String eventName, [Map<String, Object>? parameters]) async {
    _packageInfo ??= await PackageInfo.fromPlatform();

    final String newEventName =
        '${eventName}_${_packageInfo!.version.replaceAll('.', '_')}';
    if (isTestEnvironment) {
      Logger.log('logEvent: $newEventName');
    } else {
      FirebaseAnalytics.instance.logEvent(
        name: newEventName,
        parameters: parameters,
      );
    }
  }

  Future<Locale> savedLocale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String savedCode = prefs.getString('languageCode') ?? 'sys';
    if (savedCode == 'sys') {
      // 获取系统语言代码
      Locale systemLocale = PlatformDispatcher.instance.locale;
      final supportedCodes = [
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'it',
        'ja',
        'ko',
        'pt',
        'id',
        'vi',
        'th',
        'fil',
        'zh'
      ];
      langCode.value = systemLocale.languageCode;
      regionCode.value = systemLocale.countryCode ?? 'US';
      if (supportedCodes.contains(systemLocale.languageCode)) {
        if (systemLocale.languageCode == 'zh') {
          return const Locale('zh', 'Hant');
        }
        return Locale(systemLocale.languageCode);
      }
    } else if (savedCode == 'zh-Hant') {
      langCode.value = savedCode;
      return const Locale('zh', 'Hant');
    }
    langCode.value = savedCode;
    return Locale(savedCode);
  }

  void showSubscriptionPage() {
    if (isVip.value) {
      return;
    }
    Logger.log('打开订阅页');
    Get.toNamed(AppPages.subscription);
  }

  void share(BuildContext context,
      {String text = '', String subject = '', String url = ''}) async {
    ShareResult shareResult;
    //检查是否是iPad
    if (GetPlatform.isIOS && Get.context?.isTablet == true) {
      // 获取屏幕尺寸
      final Size screenSize = MediaQuery.of(context).size;

      // 自定义固定值的 sharePositionOrigin
      final Rect sharePositionOrigin = Rect.fromCenter(
        center: Offset(screenSize.width / 2, screenSize.height / 2), // 屏幕中心点
        width: screenSize.width / 2, // 屏幕宽度的一半
        height: screenSize.height / 2, // 屏幕高度的一半
      );

      if (url.isNotEmpty) {
        shareResult = await Share.shareUri(
          Uri.parse(url),
          sharePositionOrigin: sharePositionOrigin,
        );
      } else {
        shareResult = await Share.share(
          text,
          subject: subject,
          sharePositionOrigin: sharePositionOrigin,
        );
      }
    } else {
      if (url.isNotEmpty) {
        shareResult = await Share.shareUri(Uri.parse(url));
      } else {
        shareResult = await Share.share(text, subject: subject);
      }
    }

    if (shareResult.status == ShareResultStatus.success) {
      Logger.log('Thank you for sharing my website!');
    }
  }

  Future<bool> openAppReview({bool sys = false}) async {
    final InAppReview inAppReview = InAppReview.instance;
    final isAvailable = await inAppReview.isAvailable();
    Logger.trace('openAppReview isAvailable: $isAvailable');
    if (sys) {
      if (isAvailable) {
        inAppReview.requestReview();
        logEvent('inappreview_requested');
      }
      logEvent('open_appreview_${regionCode.value}_$isAvailable');
    } else {
      inAppReview.openStoreListing(
          appStoreId: Consts.appleID, microsoftStoreId: null);
    }
    return isAvailable;
  }

  void openAppStore() async {
    String url = '';
    if (GetPlatform.isIOS) {
      url = Consts.appStoreDownUrl;
    } else if (GetPlatform.isAndroid) {
      url = Consts.gplayStoreDownUrl;
    }

    if (GetUtils.isURL(url)) {
      try {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          throw 'Could not launch $url';
        }
      } catch (e) {
        Logger.log('error: $e');
      }
    }
  }

  void openUrl(String url) async {
    if (GetUtils.isURL(url)) {
      try {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          throw 'Could not launch $url';
        }
      } catch (e) {
        Logger.log('error: $e');
      }
    }
  }

  String getCancelSubscriptionUrl() {
    final String languageCode = Get.locale?.languageCode ?? 'en';
    //final String countryCode = Get.locale?.countryCode ?? 'us';
    /*
      https://support.apple.com/en-us/118428
      https://support.apple.com/zh-hk/118428
      https://support.apple.com/ar-sa/118428
      https://support.apple.com/de-de/118428
      https://support.apple.com/fr-fr/118428
      https://support.apple.com/it-it/118428
      https://support.apple.com/es-es/118428
      https://support.apple.com/pt-pt/118428
      https://support.apple.com/ja-jp/118428
      https://support.apple.com/ko-kr/118428
    */

    // 定义支持的语言和国家代码
    final Map<String, String> supportedLocales = {
      'en': 'en-us',
      'zh': 'zh-hk',
      'ar': 'ar-sa',
      'de': 'de-de',
      'fr': 'fr-fr',
      'it': 'it-it',
      'es': 'es-es',
      'pt': 'pt-pt',
      'ja': 'ja-jp',
      'ko': 'ko-kr',
    };

    // 获取匹配的语言代码，如果没有匹配项则默认使用 'en-us'
    final String localeCode = supportedLocales[languageCode] ?? 'en-us';

    return 'https://support.apple.com/$localeCode/118428';
  }
}
