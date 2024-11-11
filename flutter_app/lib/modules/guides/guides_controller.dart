import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter_app/configs/constants.dart';
import 'package:flutter_app/configs/events.dart';
import 'package:flutter_app/configs/routers.dart';
import 'package:flutter_app/generated/assets.dart';
import 'package:flutter_app/globals/iap_purchase.dart';
import 'package:flutter_app/modules/common/base/base_controller.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';

class GuidesController extends BaseController {
  /* #region 状态属性 */
  var index = 0.obs;
  var imagePath = A.jsonGuide1.obs;
  var guideTitle = "Guides_1".localized.obs;
  var guideText = "Guides_1_text".localized.obs;
  /* #endregion */

  /* #region 私有属性 */
  final iap = Get.find<IapPurchaseController>();
  StreamSubscription<VipStatusChangedEvent>? _subscription;

  Timer? _timer;
  int _secondsRemaining = 0;
  /* #endregion */

  /* #region 公开属性 */
  var guideImages = [
    // A.imageGuides1,
    // A.imageGuides2,
    // A.imageGuides3,
    A.jsonGuide1,
    A.jsonGuide2,
    A.jsonGuide3,
  ];
  /* #endregion */

  /* #region 基类方法 */
  @override
  void onInit() {
    Logger.trace('对象初始化');
    super.onInit();
    global.logEvent('guide_p_enter');
    global.logEvent('guide_show_1');
    iap.fromPage = 1;
  }

  @override
  void onReady() {
    Logger.trace('加载就绪');
    super.onReady();
  }

  @override
  void onClose() {
    Logger.trace('对象销毁');
    _subscription?.cancel();
    _timer?.cancel();
    super.onClose();
  }

  @override
  void initData() {
    super.initData();
    Logger.trace('初始化数据');
  }

  @override
  void startListener() {
    Logger.trace('开启监听');
    super.startListener();
    _subscription ??= eventBus.on<VipStatusChangedEvent>().listen((event) {
      Logger.trace('Received event: ${event.message}');
      app.checkVip();
      if (global.isVip.value) {
        Get.offAllNamed(AppPages.home);
      }
      EasyLoading.dismiss();
    });
  }

  @override
  void reloadData() async {}
  /* #endregion */

  /* #region 自定义方法 */
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 5) {
        // 每秒触发回调事件
        global.logEvent('guide_timer_tick_$_secondsRemaining');
        Logger.trace('guide_timer_tick_$_secondsRemaining');
        _secondsRemaining++;
      } else {
        _timer?.cancel();
      }
    });
  }
  /* #endregion */

  /* #region 自定义事件 */
  void closePage() {
    global.logEvent('guide_tap_close');
    Get.offAllNamed(AppPages.home);
  }

  void next() {
    index.value++;
    imagePath.value = guideImages[index.value];
    guideTitle.value = "Guides_${index.value + 1}".localized;

    if (index.value == 1 && global.xspl.value && global.rate_stars < 5) {
      //第二个引导显示评论 & 在rc标识中 & 没有给过5星
      global.openAppReview(sys: true).then((result) {
        Logger.trace('openAppReview result: $result');
        app.sp?.setInt('rate_star_count', 5);
      });
    }
    if (index.value == 2) {
      if (iap.weeklyPrice == '0' || iap.products[0].storeProduct == null) {
        Logger.trace('如果没有产品信息，跳转首页');
        global.logEvent('guide_noproducts_tohome');
        Get.offAllNamed(AppPages.home);
        return;
      } else {
        global.logEvent('guide_hasproducts_load');
        app.sp?.setBool('GuideSubscribeAlreadyShow', true);
      }
      if (app.isSubscribed) {
        guideText.value = "Guides_${index.value + 1}_text"
            .localized
            .replaceAll('[pWeek]', iap.weeklyPrice);
      } else {
        guideText.value = "Guides_${index.value + 1}_text_free"
            .localized
            .replaceAll('[pWeek]', iap.weeklyPrice);
      }
      _startTimer();
    } else {
      guideText.value = "Guides_${index.value + 1}_text".localized;
    }
    global.logEvent('guide_show_${index.value + 1}');
  }

  void continueAction() {
    if (index.value == 2) {
      EasyLoading.show(status: 'IAP_Purchaseing'.localized);
      var product = iap.products[0];
      if (product.storeProduct == null) {
        EasyLoading.dismiss();
        Logger.trace('没有产品信息，准备重新加载');
        global.logEvent('guide_noproducts');
        iap.requestProducts();
        return;
      }
      iap.runInBackground = false;
      iap.fromPage = 1;
      iap.purchase(product.storeProduct!);
      return;
    }
    next();
  }

  void menuSelected(int index) {
    switch (index) {
      case 0: // 打开隐私政策
        global.logEvent('guide_tap_privacy');
        Get.toNamed(AppPages.web, arguments: {
          "title": 'Privacy_Text1'.localized,
          "url": Consts.urlPrivacy
        });
        break;
      case 1: // 打开用户条款
        global.logEvent('guide_tap_terms');
        Get.toNamed(AppPages.web, arguments: {
          "title": 'Privacy_Text2'.localized,
          "url": Consts.urlEULA
        });
        break;
      case 2: // 恢复购买
        global.logEvent('guide_tap_restore');

        PPAlert.showSysConfirm(
          'IAP_RestoreConfirmTitle'.localized,
          'IAP_RestoreConfirmMsg'.localized,
          onConfirm: () {
            EasyLoading.show(status: 'IAP_Restoring'.localized);
            iap.runInBackground = false;
            iap.restorePurchases();
          },
        );
        break;
      case 3: // 取消订阅流程
        global.logEvent('guide_tap_subs_c');
        Get.toNamed(AppPages.web, arguments: {
          "title": 'Subscribe_Cancel'.localized,
          "url": global.getCancelSubscriptionUrl()
        });
        break;
    }
  }
  /* #endregion */
}
