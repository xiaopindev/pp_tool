import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_app/globals/app_global.dart';
import 'package:flutter_app/generated/assets.dart';
import 'package:flutter_app/modules/guides/guides_controller.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';
import 'package:lottie/lottie.dart';

class GuidesPage extends StatefulWidget {
  const GuidesPage({super.key});

  @override
  State<GuidesPage> createState() => _GuidesPageState();
}

class _GuidesPageState extends State<GuidesPage> {
  final controller = Get.put(GuidesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              A.imageBigBg,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 15.w, right: 15.w),
                      child: Obx(() {
                        return RichText(
                          textAlign: TextAlign.left,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(children: [
                            TextSpan(
                              text: controller.guideTitle.value,
                              style: TextStyle(
                                height: 4.0,
                                color: Get.theme.textTheme.titleLarge?.color,
                                fontSize: context.isLandscape ? 30 : 22.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(
                              text: '\n',
                            ),
                            TextSpan(
                              text: controller.guideText.value,
                              style: TextStyle(
                                color: Get.theme.textTheme.bodyMedium?.color,
                                fontSize: context.isLandscape ? 22 : 18.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ]),
                        );
                      })),
                ),
                // Expanded(
                //   flex: 6,
                //   child: Container(
                //     color: Colors.transparent,
                //     child: FittedBox(
                //       fit: BoxFit.scaleDown,
                //       child: Obx(() {
                //         return ConstrainedBox(
                //           constraints: const BoxConstraints(
                //               minWidth: 100, minHeight: 100),
                //           child: Image.asset(controller.imagePath.value)
                //               .animate(
                //                   key: ValueKey(controller.imagePath.value))
                //               .scale(
                //                 begin: const Offset(2, 0),
                //                 curve: Curves.elasticOut,
                //                 duration: 1500.ms,
                //               ),
                //         );
                //       }),
                //     ),
                //   ),
                // ),
                Expanded(
                  flex: 9,
                  child: Container(
                    color: Colors.transparent,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(minWidth: 100, minHeight: 100),
                        child: Obx(() {
                          return Lottie.asset(
                            controller.imagePath.value,
                            fit: BoxFit.fill,
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: SizedBox(
                        width: context.isLandscape ? 240 : 240.sp,
                        height: context.isLandscape ? 50 : 50.sp,
                        child: ElevatedButton(
                          onPressed: controller.continueAction,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Get.theme.colorScheme.onPrimary,
                            backgroundColor: Get.theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  context.isLandscape ? 25 : 25.sp),
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 26.0),
                            fixedSize: Size.fromHeight(
                                context.isLandscape ? 50 : 50.sp),
                          ),
                          child: Text(
                            'Continue'.localized,
                            style: TextStyle(
                              fontSize: context.isLandscape ? 16 : 16.sp,
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
          SafeArea(
            child: Container(
              color: Colors.transparent,
              child: Obx(
                () => controller.index.value == 2
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildCloseButton(),
                          PopupMenuView(),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder<dynamic> buildCloseButton() {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 5)), // 5秒后触发显示
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Get.find<AppGlobal>().logEvent('guide_close_show');
          return Opacity(
            opacity: 0.1,
            child: IconButton(
              iconSize: 25,
              color: Colors.grey[700],
              icon: const Icon(Icons.close),
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

class PopupMenuView extends StatelessWidget {
  final controller = Get.find<GuidesController>();
  PopupMenuView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.help_outline),
      onOpened: () {
        controller.global.logEvent('guide_tap_help');
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
