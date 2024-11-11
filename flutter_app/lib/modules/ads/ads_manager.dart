import 'dart:async';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_app/globals/app_global.dart';
import 'package:flutter_app/modules/ads/consent_manager.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';

class AdsManager {
  /*
  测试
  <key>GADApplicationIdentifier</key>
  <string>ca-app-pub-3940256099942544~1458002511</string>
  正式：
  <key>GADApplicationIdentifier</key>
  <string>ca-app-pub-8059260699035496~5004424059</string>
  插屏广告：ca-app-pub-8059260699035496/8145592710
  */

  /* #region Singleton */
  static final AdsManager _instance = AdsManager._internal();
  factory AdsManager() => _instance;
  AdsManager._internal();
  static AdsManager get instance => _instance;
  /* #endregion */

  /* #region Properties */
  Timer? _adTimer;

  var allowLoadAd = false;
  var isOver60 = false;
  var _isMobileAdsInitializeCalled = false;
  var _isPrivacyOptionsRequired = false;

  final global = Get.find<AppGlobal>();
  final _consentManager = ConsentManager();
  InterstitialAd? _interstitialAd;
  /* #endregion */

  /* #region Private Methods */
  /// Redraw the app bar actions if a privacy options entry point is required.
  void _getIsPrivacyOptionsRequired() async {
    if (await _consentManager.isPrivacyOptionsRequired()) {
      _isPrivacyOptionsRequired = true;
    }
    /*
    showPrivacyOptionsForm 方法通常用于显示用户隐私选项的表单，特别是在涉及广告和用户数据收集的应用中。
    这个方法通常是由一个 ConsentManager 类或类似的隐私管理类提供的，用于处理用户的隐私设置和同意。
    目前不知道如何用
    _consentManager.showPrivacyOptionsForm((formError) {
      if (formError != null) {
        debugPrint("${formError.errorCode}: ${formError.message}");
      }
      //_resumeGame();
    });
    */
  }

  /// Initialize the Mobile Ads SDK if the SDK has gathered consent aligned with
  /// the app's configured messages.
  void _initializeMobileAdsSDK() async {
    if (_isMobileAdsInitializeCalled) {
      return;
    }

    if (!(await _consentManager.canRequestAds())) {
      return;
    }
    _isMobileAdsInitializeCalled = true;

    MobileAds.instance.initialize();

    allowLoadAd = true;
    Logger.trace('allowLoadAd');

    _startAdTimer();

    global.logEvent('allow_load_ad');
  }

  /// Start the timer to set isOver60 to true every 60 seconds.
  void _startAdTimer() {
    isOver60 = false;
    _adTimer?.cancel();
    _adTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      isOver60 = true;
      Logger.trace('isOver60 set to true');
    });
  }
  /* #endregion */

  /* #region Public Methods */
  /// 检查许可, 请求授权
  /// 加载页网络连接的时候调用检查许可
  void checkConsent() {
    _consentManager.gatherConsent((consentGatheringError) {
      if (consentGatheringError != null) {
        // Consent not obtained in current session.
        Logger.trace(
            "${consentGatheringError.errorCode}: ${consentGatheringError.message}");
      }
      // Check if a privacy options entry point is required.
      _getIsPrivacyOptionsRequired();

      // Attempt to initialize the Mobile Ads SDK.
      _initializeMobileAdsSDK();
    });

    // This sample attempts to load ads using consent obtained in the previous session.
    _initializeMobileAdsSDK();
  }

  void fetchInterstitialAd() {
    if (!allowLoadAd) {
      Logger.trace('Cannot load ad yet');
      checkConsent();
      return;
    }
    if (global.isVip.value) {
      Logger.trace('isVip');
      return;
    }
    //正式广告ID
    String adUnitId = 'ca-app-pub-8059260699035496/8145592710';
    if (global.isTestEnvironment) {
      adUnitId = 'ca-app-pub-3940256099942544/4411468910';
    }
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialAd!.setImmersiveMode(true);
          global.logEvent('ad_loaded_interstitialAd');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  void showInterstitialAd({Function? onAdClosed}) {
    if (_interstitialAd == null) {
      fetchInterstitialAd();
      if (onAdClosed != null) {
        onAdClosed();
      }
      return;
    }
    if (!isOver60) {
      Logger.trace('isOver60 is false');
      if (onAdClosed != null) {
        onAdClosed();
      }
      return;
    }

    if (global.isVip.value) {
      Logger.trace('isVip');
      if (onAdClosed != null) {
        onAdClosed();
      }
      return;
    }

    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {},
      onAdClicked: (ad) {},
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _interstitialAd = null;
        _startAdTimer();
        if (onAdClosed != null) {
          onAdClosed();
        }
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _interstitialAd = null;
        if (onAdClosed != null) {
          onAdClosed();
        }
      },
    );

    _interstitialAd?.show();
  }

  /* #endregion */
}
