import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_app/globals/app_global.dart';
import 'package:flutter_app/generated/assets.dart';
import 'package:flutter_app/globals/iap_purchase.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';

class HomeVipAlert extends StatefulWidget {
  const HomeVipAlert({super.key});

  @override
  State<HomeVipAlert> createState() => _HomeVipAlertState();
}

class _HomeVipAlertState extends State<HomeVipAlert>
    with SingleTickerProviderStateMixin {
  final global = Get.find<AppGlobal>();
  late AnimationController _controller;

  void buyAgain() {
    global.logEvent('home_buy_weekly2');
    final iap = Get.find<IapPurchaseController>();
    EasyLoading.show(status: 'IAP_Purchaseing'.localized);
    var product = iap.products[0];
    if (product.storeProduct == null) {
      EasyLoading.dismiss();
      Logger.trace('没有产品信息，准备重新加载');
      global.logEvent('home_noproducts');
      iap.requestProducts();
      return;
    }
    iap.runInBackground = false;
    iap.fromPage = 2;
    iap.purchase(product.storeProduct!);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(); // 循环动画
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: 375,
      child: IntrinsicHeight(
        // 使用IntrinsicHeight使Container根据内容自适应高度
        child: Stack(
          children: [
            Positioned.fill(
              child: RotationTransition(
                turns: _controller,
                child: Image.asset(A.imageVipAlertBg0),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(A.imageVipAlertBg1),
                Container(
                  decoration: BoxDecoration(
                    color: HexColor('202020'),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 2,
                      color: HexColor('FFE9B9'),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 15, right: 15),
                        child: Text(
                          'Guides_AlertTitle'.localized,
                          style: TextStyle(
                            color: Get.theme.colorScheme.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Text(
                          'Guides_AlertText'.localized,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          buyAgain();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 26.0),
                          fixedSize: const Size.fromHeight(40),
                        ),
                        child: Text(
                          'Subscribe_FreeTrail'.localized,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              top: 0,
              child: IconButton(
                onPressed: () {
                  global.logEvent('home_vip_alert_close');
                  Get.find<IapPurchaseController>().fromPage = 0;
                  Get.back();
                },
                icon: Image.asset(
                  A.iconAlertClose,
                  width: 25,
                  height: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
