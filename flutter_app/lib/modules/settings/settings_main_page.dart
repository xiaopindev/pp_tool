import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_app/generated/assets.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';

import 'settings_controller.dart';

class SettingsMainPage extends GetView<SettingsController> {
  const SettingsMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 350,
        leading: Obx(() {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Align(
              alignment: controller.global.langCode.value == 'ar'
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Text(
                'tab_settings'.localized,
                overflow: TextOverflow.ellipsis,
                style: Get.theme.appBarTheme.titleTextStyle,
              ),
            ),
          );
        }),
        actions: [
          IconButton(
            icon: Obx(() {
              var imagePath =
                  controller.global.isVip.value ? A.iconVipOn : A.iconVipOff;
              return Image.asset(imagePath, width: 25, height: 25);
            }),
            onPressed: () {
              controller.global.showSubscriptionPage();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Obx(() {
              if (controller.global.isVip.value) {
                return const SizedBox();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: GestureDetector(
                  onTap: () => controller.global.showSubscriptionPage(),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [HexColor('F5DBB1'), HexColor('F2BA7E')],
                      ), // 背景色
                      borderRadius: BorderRadius.circular(8), // 设置圆角
                      boxShadow: [
                        BoxShadow(
                          color: HexColor('AC5D00').withOpacity(0.45),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: const Offset(0, 2), // 设置阴影的偏移量
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 10, bottom: 5, right: 8),
                            child: Image.asset(A.imageVipCrown),
                          ),
                          Text(
                            'Upgarde Pro',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: HexColor('8F5022')),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: HexColor('8F5022'),
                            size: 20,
                          ),
                          const SizedBox(width: 15)
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                decoration: BoxDecoration(
                  color: Get.theme.cardTheme.color, // 背景色
                  borderRadius: BorderRadius.circular(8), // 设置圆角
                  boxShadow: [
                    BoxShadow(
                      color: (Theme.of(context).shadowColor).withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 2), // 设置阴影的偏移量
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: List.generate(controller.group1.length * 2 - 1,
                        (index) {
                      if (index % 2 == 1) {
                        return const Divider(height: 0.5);
                      } else {
                        var itemIndex = index ~/ 2;
                        var record = controller.group1[itemIndex];
                        return ListTile(
                          leading: ImageIcon(AssetImage(record.icon), size: 30),
                          title: Text(record.title.localized),
                          trailing: Obx(() {
                            var showVip = false;
                            if (!controller.global.isVip.value &&
                                (record.icon == A.iconSettingIndividuation ||
                                    record.icon == A.iconSettingBackup ||
                                    record.icon == A.iconSettingRestore)) {
                              showVip = true;
                            }
                            return showVip
                                ? Image.asset(A.iconVipOn,
                                    width: 25, height: 25)
                                : const SizedBox();
                          }),
                          onTap: () {
                            controller.listItemTap(context, record.title);
                          },
                        );
                      }
                    }),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color, // 背景色
                  borderRadius: BorderRadius.circular(8), // 设置圆角
                  boxShadow: [
                    BoxShadow(
                      color: (Theme.of(context).shadowColor).withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: List.generate(controller.group2.length * 2 - 1,
                        (index) {
                      if (index % 2 == 1) {
                        return const Divider(height: 0.5);
                      } else {
                        var record = controller.group2[index ~/ 2];
                        return ListTile(
                          leading: ImageIcon(AssetImage(record.icon), size: 30),
                          title: Text(record.title.localized),
                          onTap: () {
                            controller.listItemTap(context, record.title);
                          },
                        );
                      }
                    }),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Obx(() {
                  return Text(
                    'Ver ${controller.version}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
