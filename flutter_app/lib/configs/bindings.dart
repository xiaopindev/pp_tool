import 'package:get/get.dart';

import '../globals/application.dart';
import '../globals/iap_purchase.dart';
import '../globals/network.dart';
import '../modules/app_review/app_review_controller.dart';
import '../modules/app_versioin/new_version.dart';
import '../modules/settings/settings_controller.dart';

class GetBindingsController implements Bindings {
  @override
  void dependencies() {
    //一定要注意依赖关系的先后顺序
    Get.put(NetworkController(), permanent: true);
    Get.put(XPApplication(), permanent: true);
    Get.put(IapPurchaseController(), permanent: true);

    Get.lazyPut<NewVerController>(() => NewVerController());
    Get.lazyPut<AppReviewController>(() => AppReviewController());

    //Get.put(PlayerThemeController());

    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
