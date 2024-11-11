import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_app/configs/constants.dart';
import 'package:flutter_app/globals/app_global.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';
import 'package:package_info_plus/package_info_plus.dart';

class NewVerPage extends GetView<NewVerController> {
  const NewVerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.close, color: Get.textTheme.bodyMedium?.color)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'NewVer_Text'.localized,
              style: TextStyle(
                  fontSize: 16, color: Get.textTheme.bodyMedium?.color),
            ),
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            controller.openStore();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            fixedSize: const Size.fromHeight(50),
          ),
          child: Text(
            'NewVer_BtnText1'.localized,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Get.theme.textTheme.bodyMedium?.color,
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            fixedSize: const Size.fromHeight(50),
          ),
          child: Text(
            'NewVer_BtnText2'.localized,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class NewVerController extends GetxController {
  @override
  void onInit() {
    Logger.trace('对象初始化');
    super.onInit();
  }

  @override
  void onClose() {
    Logger.trace('对象销毁');
    super.onClose();
  }

  void openStore() {
    final global = Get.find<AppGlobal>();
    global.logEvent('update_app');
    global.openAppStore();
    Get.back();
  }

  void fetchAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String localVersion = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      Logger.log(
          'App Info: $appName, $packageName, $localVersion, $buildNumber');

      String url;
      if (GetPlatform.isAndroid) {
        // 替换为你的Android应用的包名
        String androidPackageName = 'com.example.yourapp';
        url =
            'https://play.google.com/store/apps/details?id=$androidPackageName&hl=en';
      } else if (GetPlatform.isIOS) {
        String appStoreId = Consts.appleID;
        url = 'https://itunes.apple.com/lookup?id=$appStoreId';
      } else {
        throw UnsupportedError('Unsupported platform');
      }
      Logger.log('App Info Url: $url');

      dio.Dio http = dio.Dio();
      dio.Response response = await http.get(url);
      //Logger.log('response: ${response.data}');

      //获取商店的版本信息
      String storeVersion = '';
      if (GetPlatform.isAndroid) {
        // 解析Android版本信息
        // 这里需要解析HTML内容，具体实现可能需要使用html包
        // storeVersion = parseAndroidVersion(response.data);
      } else if (GetPlatform.isIOS) {
        // 解析iOS版本信息
        final Map<String, dynamic> data = jsonDecode(response.data);
        storeVersion = data['results'][0]['version'];
      }

      //对比版本号
      if (storeVersion.isNotEmpty && storeVersion.compareTo(localVersion) > 0) {
        Logger.log('New version available: $storeVersion');
        Get.dialog(
          Dialog(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity,
              height: 270,
              child: const NewVerPage(),
            ),
          ),
          barrierDismissible: true,
          barrierColor: Colors.transparent,
        );
      } else {
        Logger.log('App is up to date');
      }
    } catch (e) {
      Logger.log('Error fetching app store info: $e');
    }
  }
}
