import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app/globals/app_global.dart';
import 'package:lottie/lottie.dart';
import 'package:open_settings_plus/open_settings_plus.dart';
import 'package:flutter_app/generated/assets.dart';
import 'package:flutter_app/globals/network.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';

import 'launch_controller.dart';

class LaunchLoadingPage extends StatefulWidget {
  const LaunchLoadingPage({super.key});

  @override
  State<LaunchLoadingPage> createState() => _LaunchLoadingPageState();
}

class _LaunchLoadingPageState extends State<LaunchLoadingPage> {
  final networkController = Get.find<NetworkController>();
  final launchController = Get.put(LaunchController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(),
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: LaunchLogoNameView(),
              ),
              Obx(() {
                if (networkController.status.value == NetworkStatus.none) {
                  Get.find<AppGlobal>().logEvent('loading_show_network');
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: NetworkErrorView(),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: SpinKitThreeInOut(
                        color: Get.theme.colorScheme.primary, size: 30),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class NetworkErrorView extends StatelessWidget {
  const NetworkErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Network_Lost'.localized,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Get.theme.textTheme.bodySmall?.color,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            openNetworkSettings();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Get.theme.colorScheme.onPrimary,
            backgroundColor: Get.theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            fixedSize: const Size.fromHeight(50),
          ),
          child: Text(
            'Network settings'.localized,
            style: const TextStyle(
              fontSize: 16, // 字体大小设置为16
              fontWeight: FontWeight.bold, // 字体加粗
            ),
          ),
        ),
      ],
    );
  }

  void openNetworkSettings() {
    Get.find<AppGlobal>().logEvent('loading_tap_network');
    var settings = OpenSettingsPlus.shared;
    switch (settings.runtimeType) {
      case OpenSettingsPlusAndroid:
        (settings as OpenSettingsPlusAndroid).appSettings();
        break;
      case OpenSettingsPlusIOS:
        (settings as OpenSettingsPlusIOS).appSettings();
        break;
      default:
        throw Exception('Platform not supported');
    }
  }
}

class LaunchLogoNameView extends StatelessWidget {
  const LaunchLogoNameView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Image.asset(
        //   A.imageAppLogo,
        //   width: 128,
        //   height: 128,
        // ),
        Lottie.asset(
          A.jsonLogo,
          width: 180,
          height: 180,
          fit: BoxFit.fill,
          repeat: false,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
