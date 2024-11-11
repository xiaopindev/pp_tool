import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_app/configs/constants.dart';
import 'package:flutter_app/configs/routers.dart';
import 'package:flutter_app/modules/common/base/base_controller.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_review.dart';

class AppReviewController extends BaseController {
  var isFullStar = false.obs;
  var starCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    Logger.trace('对象初始化');
  }

  /// 功能使用记录埋点
  void useRecord(String featureName) async {
    final sp = await SharedPreferences.getInstance();
    var list = sp.getStringList('features_use_records') ?? [];
    if (list.contains(featureName)) {
      return;
    }
    list.add(featureName);
    await sp.setStringList('features_use_records', list);
    Logger.trace('当前功能使用记录埋点: $list');
  }

  Future<bool> _canAlertRate() async {
    /*
    评论逻辑：
    体验核心功能后，弹出评论，24小时内只弹一次，如果没卸载APP，最多只弹5次
    给过5星，以后也不需要弹。
    如果是VIP，不用弹
    评论5星后点击跳转直接跳转到https://itunes.apple.com/app/id\(AppleID)?action=write-review
    */
    if (app.isVip) {
      Logger.trace('当前用户为VIP，无需弹出');
      global.logEvent('rate_already_vip');
      return false;
    }

    final sp = await SharedPreferences.getInstance();

    //检查是否给了5星
    var starCount = sp.getInt('rate_star_count') ?? 0;
    if (starCount == 5) {
      Logger.trace('已经给过5星，无需弹出');
      global.logEvent('rate_already_5star');
      return false;
    }

    //检查是否到了下次检测时间
    var nextCheckTime = sp.getInt('rate_next_check_time') ?? 0;
    if (nextCheckTime > DateTime.now().millisecondsSinceEpoch) {
      Logger.trace('还未到下次检测时间，无需弹出');
      return false;
    }

    //检查弹出次数，安装以后可弹出5次
    var alertCount = sp.getInt('rate_alert_count') ?? 0;
    alertCount += 1;
    if (alertCount >= 5) {
      Logger.trace('已经弹出5次，无需弹出');
      sp.setInt('rate_alert_count', 5);
      return false;
    }
    sp.setInt('rate_next_check_time',
        DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch);
    sp.setInt('rate_alert_count', alertCount);
    global.logEvent('rate_alert_$alertCount');
    Logger.trace('弹出次数:$alertCount， 最高星：$starCount');
    return true;
  }

  void closeAppReview() {
    global.logEvent('rate_tap_close');
    Get.back();
  }

  void showRateView() async {
    Logger.trace('弹出评价');
    if (await _canAlertRate()) {
      global.logEvent('rate_p_enter');
      showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        backgroundColor: Get.theme.colorScheme.surface,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.4,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: const AppReviewPage(),
            ),
          );
        },
      );
    }
  }

  void updateRateValue(double value) {
    Logger.trace('rate value: $value');
    starCount.value = value.toInt();
    if (value == 5.0) {
      isFullStar.value = true;
    } else {
      isFullStar.value = false;
    }
  }

  void buttonAction() {
    if (starCount <= 0) {
      return;
    }
    global.logEvent('rate_star_$starCount');
    Get.back();
    if (isFullStar.value) {
      app.sp?.setInt('rate_star_count', 5);
      global.logEvent('rate_tap_tostore');
      global.openUrl(Consts.appStoreReviewUrl);
    } else {
      global.logEvent('rate_tap_tofeedback');
      Get.toNamed(AppPages.feedback);
    }
  }
}
