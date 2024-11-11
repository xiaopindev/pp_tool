import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_app/generated/assets.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';

import 'individuation_controller.dart';

class IndividuationPage extends StatelessWidget {
  final controller = Get.put(IndividuationController());

  IndividuationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('individuation_title'.localized),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //外观模式
                buildAppearanceView(context),
                //主题色
                buildThemeColorView(context),
                //播放器主题
                buildPlayerThemeView(context),
                //应用图标设置
                buildAppIconView(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card buildAppIconView(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'individuation_appicon'.localized,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 95,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // 每行一个项目
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  mainAxisExtent: 65, // 设置项目的固定宽度
                ),
                itemCount: controller.appIcons.length,
                itemBuilder: (context, index) {
                  var name = controller.appIcons[index];
                  return GestureDetector(
                    onTap: () => controller.setAppIcon(index),
                    child: Obx(() {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5), // 设置圆角
                              child: Image.asset(name),
                            ),
                            const SizedBox(height: 6),
                            controller.appIconId.value == index
                                ? Icon(Icons.check_circle_rounded,
                                    color: Theme.of(context).primaryColor)
                                : Icon(
                                    Icons.radio_button_unchecked,
                                    color: Theme.of(context).primaryColor,
                                  )
                          ],
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card buildPlayerThemeView(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'individuation_playertheme'.localized,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 255,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // 每行一个项目
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  mainAxisExtent: 110, // 设置项目的固定宽度
                ),
                itemCount: controller.playerThemes.length,
                itemBuilder: (context, index) {
                  var name = controller.playerThemes[index];
                  return GestureDetector(
                    onTap: () => controller.changePlayerTheme(index),
                    child: Obx(() {
                      return Column(
                        children: [
                          Expanded(child: Image.asset(name)),
                          const SizedBox(height: 10),
                          controller.playerThemeIndex.value == index
                              ? Icon(Icons.check_circle_rounded,
                                  color: Theme.of(context).primaryColor)
                              : Icon(
                                  Icons.radio_button_unchecked,
                                  color: Theme.of(context).primaryColor,
                                )
                        ],
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card buildThemeColorView(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'individuation_themecolor'.localized,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 50,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // 每行一个项目
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  mainAxisExtent: 50, // 设置项目的固定宽度
                ),
                itemCount: controller.themeVC.colorStrs.length,
                itemBuilder: (context, index) {
                  var colorStr = controller.themeVC.colorStrs[index];
                  return GestureDetector(
                    onTap: () => controller.changeThemeColorIndex(index),
                    child: Obx(() {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 49,
                            height: 49,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  controller.themeVC.colorIndex.value == index
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent,
                            ),
                          ),
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: HexColor(colorStr),
                              border: Border.all(
                                color:
                                    controller.themeVC.colorIndex.value == index
                                        ? Colors.white
                                        : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  );
                },
              ),
            ),
            const SizedBox(height: 15)
          ],
        ),
      ),
    );
  }

  Card buildAppearanceView(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'individuation_appearance'.localized,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
              childAspectRatio: 156 / 140,
              children: [
                GestureDetector(
                  onTap: () => controller.changeAppearance(false),
                  child: Column(
                    children: [
                      Image.asset(A.iconSettingLight),
                      const SizedBox(height: 8),
                      Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            !controller.themeVC.isDarkMode.value
                                ? Icon(Icons.check_circle_rounded,
                                    color: Theme.of(context).primaryColor)
                                : Icon(
                                    Icons.radio_button_unchecked,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            const SizedBox(width: 3),
                            Text('appearance_light'.localized),
                          ],
                        );
                      })
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.changeAppearance(true),
                  child: Column(
                    children: [
                      Image.asset(A.iconSettingDark),
                      const SizedBox(height: 8),
                      Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            controller.themeVC.isDarkMode.value
                                ? Icon(Icons.check_circle_rounded,
                                    color: Theme.of(context).primaryColor)
                                : Icon(
                                    Icons.radio_button_unchecked,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            const SizedBox(width: 3),
                            Text('appearance_dark'.localized),
                          ],
                        );
                      })
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
