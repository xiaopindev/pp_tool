import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter_app/configs/constants.dart';
import 'package:flutter_app/configs/events.dart';
import 'package:flutter_app/configs/routers.dart';
import 'package:flutter_app/globals/iap_purchase.dart';
import 'package:flutter_app/modules/common/base/base_controller.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';

class SubscriptionController extends BaseController {
  /* #region 状态属性 */
  var selectedIndex = 0.obs;
  var titleWeekly = 'Weekly'.obs;
  var titleAnnual = 'Annual'.obs;
  var firstLaunch = false;

  /* #endregion */

  /* #region 私有属性 */
  StreamSubscription<ProductChangedEvent>? _subscription;
  /* #endregion */

  /* #region 公开属性 */
  final iap = Get.find<IapPurchaseController>();
  /* #endregion */

  /* #region 基类方法 */

  @override
  void onInit() {
    super.onInit();
    global.logEvent('subs_p_enter');
    if (Get.arguments != null) {
      firstLaunch = Get.arguments['firstLaunch'] ?? false;
    }
  }

  @override
  void onClose() {
    Logger.trace('对象销毁');
    _subscription?.cancel();
    global.logEvent('subs_exit');
    super.onClose();
  }

  @override
  void initData() {
    super.initData();
    Logger.trace('初始化数据');

    if (iap.weeklyPrice == '0' || iap.products[0].storeProduct == null) {
      Logger.trace('进入订阅页如果产品信息为空，主动请求产品信息');
      iap.requestProducts();
    }

    //监听到会员状态变化以后就关闭页面
    ever(global.isVip, (bool isVip) {
      if (isVip) {
        Get.back();
      }
    });
  }

  @override
  void startListener() {
    Logger.trace('开启监听');
    super.startListener();
    _subscription ??= eventBus.on<ProductChangedEvent>().listen((event) {
      Logger.trace('Received event: ${event.message}');
      reloadData();
    });
  }

  @override
  void reloadData() async {
    if (GetPlatform.isMobile && Get.context!.isPhone) {
      titleWeekly.value = iap.weeklyProductText;
      titleAnnual.value = iap.aunnalProductText;
    } else {
      titleWeekly.value = iap.weeklyProductText.replaceAll('\n', '');
      titleAnnual.value = iap.aunnalProductText.replaceAll('\n', '');
    }
  }
  /* #endregion */

  /* #region 自定义方法 */
  void closePage() {
    global.logEvent('subs_exit');
    if (firstLaunch) {
      Get.offAllNamed(AppPages.home);
      firstLaunch = false;
    } else {
      Get.back();
    }
  }
  /* #endregion */

  /* #region 自定义事件 */
  void buyProduct() {
    // TODO: 生产环境注释
    // if (global.isTestEnvironment) {
    //   global.isVip.value = true;
    //   eventBus.send(VipStatusChangedEvent('尊贵的会员，欢迎归来！'));
    //   return;
    // }

    EasyLoading.show(status: 'IAP_Purchaseing'.localized);
    var product = iap.products[selectedIndex.value];
    if (product.storeProduct == null) {
      EasyLoading.dismiss();
      Logger.trace('没有产品信息，准备重新加载');
      global.logEvent('subs_noproducts');
      iap.requestProducts();
      return;
    }
    global.logEvent(
        'subs_buy_${selectedIndex.value == 0 ? 'weeklyvip' : 'annualvip'}');
    iap.runInBackground = false;
    iap.purchase(product.storeProduct!);
  }

  void restore() {
    PPAlert.showSysConfirm(
      'IAP_RestoreConfirmTitle'.localized,
      'IAP_RestoreConfirmMsg'.localized,
      onConfirm: () {
        EasyLoading.show(status: 'IAP_Restoring'.localized);
        global.logEvent('subs_tap_restore');
        iap.runInBackground = false;
        iap.restorePurchases();
      },
    );
  }

  void menuSelected(int index) {
    switch (index) {
      case 0: // 打开隐私政策
        global.logEvent('subs_tap_privacy');
        Get.toNamed(AppPages.web, arguments: {
          "title": 'Privacy_Text1'.localized,
          "url": Consts.urlPrivacy
        });
        break;
      case 1: // 打开用户条款
        global.logEvent('subs_tap_terms');
        Get.toNamed(AppPages.web, arguments: {
          "title": 'Privacy_Text2'.localized,
          "url": Consts.urlEULA
        });
        break;
      case 2: // 恢复购买
        restore();
        break;
      case 3: // 取消订阅流程
        global.logEvent('subs_tap_cancel');
        Get.toNamed(AppPages.web, arguments: {
          "title": 'Subscribe_Cancel'.localized,
          "url": global.getCancelSubscriptionUrl()
        });
        break;
    }
  }
  /* #endregion */
}
