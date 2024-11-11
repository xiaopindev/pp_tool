import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter_app/configs/constants.dart';
import 'package:flutter_app/configs/routers.dart';
import 'package:flutter_app/globals/application.dart';
import 'package:flutter_app/modules/ads/ads_manager.dart';
import 'package:flutter_app/modules/common/base/base_controller.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';

class LaunchController extends BaseController {
  Timer? _timer;
  final _maxTick = 6;

  @override
  void onInit() {
    super.onInit();
    _startTimer();

    global.logEvent('init_${Consts.appleID}');
    global.logEvent('loading_p_enter');
    app.initEasyLoading();
    // TODO: 生产环境注释
    // if (global.isTestEnvironment) {
    //   app.clearVip();
    // }
  }

  @override
  void onClose() {
    Logger.trace('释放资源');
    _timer?.cancel();
    super.onClose();
  }

  @override
  void handleConnectivityChanged(bool isConnected) {
    Logger.trace('handleConnectivityChanged $isConnected');
    _startTimer();
  }

  void _startTimer() {
    if (!network.isConnected.value) {
      Logger.trace('Timer no network');
      global.logEvent('loading_net_disconnect');
      return;
    }
    AdsManager().checkConsent();

    // 检查定时器是否已经在运行
    if (_timer != null && _timer!.isActive) {
      Logger.trace('Timer is already running');
      return;
    }
    global.logEvent('loading_net_connected');
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      Logger.log("timer tick:${timer.tick}");
      //如果广告已经显示了，停止定时器
      if (timer.tick <= 3) {
        //前3秒不处理任何事情
        return;
      } else if (timer.tick >= _maxTick) {
        //时间到了进入下一页
        toNextPage();
        return;
      }
      //如果是会员，进入下一页
      var app = Get.find<XPApplication>();
      if (app.isVip) {
        toNextPage();
        return;
      }
      //如果有广告，显示广告
    });
  }

  void toNextPage() {
    _timer?.cancel();
    final app = Get.find<XPApplication>();
    var canShowGuide = true;
    if (!app.isFirstLaunch) {
      Logger.trace('不是第一次加载...');
      var currentTime = DateTime.now().millisecondsSinceEpoch;
      var nextShowTime = app.sp?.getInt("NextGuidePageShowTime") ?? 0;
      var alreadyShow = app.sp?.getBool("GuideSubscribeAlreadyShow") ?? false;
      if (nextShowTime > currentTime) {
        canShowGuide = false;
        if (!alreadyShow) {
          //如果因为网络不好，没有加载到产品，下次继续显示引导
          canShowGuide = true;
        }
      }
    }
    // TODO: 生产环境注释
    // if (global.isTestEnvironment) {
    //   canShowGuide = true;
    // }
    if (canShowGuide) {
      var nextShowTime =
          DateTime.now().add(const Duration(days: 3)).millisecondsSinceEpoch;
      app.sp?.setInt("NextGuidePageShowTime", nextShowTime);

      Get.offAllNamed(AppPages.guides);
      Get.delete<LaunchController>();
      return;
    }

    if (!global.isVip.value) {
      Get.offAllNamed(AppPages.subscription, arguments: {'firstLaunch': true});
    } else {
      Get.offAllNamed(AppPages.home);
    }
    Get.delete<LaunchController>();
  }
}
