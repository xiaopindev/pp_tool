import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_app/generated/assets.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';

import 'subscription_controller.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final controller = Get.put(SubscriptionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildCloseButton(),
                    PopupMenuView(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  Positioned(
                    left: 5,
                    top: 35,
                    width: 68,
                    height: 32,
                    child: Image.asset(A.imageSubVipLeftTop),
                  ),
                  Positioned(
                    right: 15,
                    bottom: 18,
                    width: 75,
                    height: 35,
                    child: Image.asset(A.imageSubVipRightBottom),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(35.0),
                    child: PrivilegesListView(),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    width: 150,
                    height: 118,
                    child: Image.asset(A.imageSubVipRightTop),
                  ),
                  Positioned(
                      left: 35,
                      bottom: 35,
                      width: 35,
                      height: 35,
                      child: Image.asset(A.imageSubVipLeftBottom))
                ]),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const ProductListView(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(A.imageSubVipGou, width: 20, height: 20),
                        const SizedBox(width: 5),
                        Obx(() {
                          var text = controller.selectedIndex.value == 0
                              ? 'Subscribe_Status_Nopay'.localized
                              : 'Subscribe_Year_Tip'.localized;
                          return Text(
                            text,
                            style: TextStyle(
                                fontSize: 16, color: HexColor('#555555')),
                          );
                        })
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: SizedBox(
                    width: 240,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.buyProduct,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 26.0),
                        fixedSize: const Size.fromHeight(50),
                      ),
                      child: Text(
                        'Continue'.localized,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<dynamic> buildCloseButton() {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 1)), // 5秒后触发显示
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Opacity(
            opacity: 0.1,
            child: IconButton(
              icon: const Icon(Icons.close),
              color: Get.theme.colorScheme.onPrimary.withOpacity(1.0),
              onPressed: () {
                controller.closePage();
              },
            ),
          );
        }
        return const SizedBox.shrink(); // 默认隐藏
      },
    );
  }
}

class PrivilegesListView extends StatelessWidget {
  const PrivilegesListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(35, 15, 15, 15), // 内边距
      width: double.infinity, // 自动宽度
      height: double.infinity, // 固定高度
      decoration: BoxDecoration(
        color: Get.theme.cardTheme.color, // 背景色
        borderRadius: BorderRadius.circular(8), // 设置圆角
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C2C2C).withOpacity(0.2), // 设置阴影颜色和透明度
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2), // 设置阴影的偏移量
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 40,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Subscribe_Title'.localized,
                style: TextStyle(
                  color: Get.theme.textTheme.titleLarge?.color,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
              child: ListView.builder(
                itemCount: 9,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  'Subscribe_Desc${index + 1}'.localized,
                                  textStyle: const TextStyle(fontSize: 15),
                                  colors: [
                                    Get.theme.colorScheme.onPrimary,
                                    Colors.blue,
                                    Colors.yellow,
                                    Colors.red
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5)
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductListView extends StatelessWidget {
  const ProductListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubscriptionController>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Obx(() {
            return subscriptionOption(
              title: 'Weekly',
              description: controller.titleWeekly.value,
              isSelected: controller.selectedIndex.value == 0,
              onTap: () {
                controller.global.logEvent('subs_select_weekly');
                controller.selectedIndex.value = 0;
              },
            );
          }),
          const SizedBox(height: 20),
          Obx(() {
            return subscriptionOption(
              title: 'Annual',
              description: controller.titleAnnual.value,
              isSelected: controller.selectedIndex.value == 1,
              isBestDeal: true,
              onTap: () {
                controller.global.logEvent('subs_select_aunnal');
                controller.selectedIndex.value = 1;
              },
            );
          }),
        ],
      ),
    );
  }

  Widget subscriptionOption({
    required String title,
    required String description,
    required bool isSelected,
    bool isBestDeal = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15), //内边距
        width: double.infinity, //自动宽度
        height: 64, //固定高度
        decoration: BoxDecoration(
          color: Get.theme.cardTheme.color, //背景色
          borderRadius: BorderRadius.circular(8), // 设置圆角
          border: isSelected
              ? Border.all(
                  color: Get.theme.primaryColor, // 边框颜色
                  width: 1, // 边框宽度
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2C2C2C).withOpacity(0.2), // 设置阴影颜色和透明度
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 2), // 设置阴影的偏移量
            ),
          ],
        ),
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            Positioned(
              left: 0,
              child: isSelected
                  ? Icon(
                      Icons.radio_button_checked,
                      color: Get.theme.primaryColor,
                      size: 20,
                    )
                  : Icon(
                      Icons.radio_button_off,
                      color: HexColor('c2c2c2'),
                      size: 20,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  description,
                  style: TextStyle(
                      fontSize: 14, color: Get.textTheme.titleLarge?.color),
                  maxLines: 2,
                ),
              ),
            ),
            if (isBestDeal)
              Positioned(
                top: 0,
                right: 0,
                width: 96,
                height: 17,
                child: Image.asset(A.imageSubVipBestPrice),
              ),
          ],
        ),
      ),
    );
  }
}

class PopupMenuView extends StatelessWidget {
  final controller = Get.find<SubscriptionController>();

  PopupMenuView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.help_outline),
      onOpened: () {
        controller.global.logEvent('subs_help_open');
      },
      onSelected: (String value) {
        controller.menuSelected(int.parse(value));
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: '0',
          child: Text('Privacy_Text1'.localized),
        ),
        PopupMenuItem<String>(
          value: '1',
          child: Text('Privacy_Text2'.localized),
        ),
        PopupMenuItem<String>(
          value: '2',
          child: Text('Subscribe_Restore'.localized),
        ),
        PopupMenuItem<String>(
          value: '3',
          child: Text('Subscribe_Cancel'.localized),
        ),
      ],
    );
  }
}
