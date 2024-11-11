import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter_app/globals/app_global.dart';
import 'package:flutter_app/globals/application.dart';
import 'package:flutter_app/globals/network.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';

class BaseController extends GetxController {
  final EventBus eventBus = EventBus();
  final global = Get.find<AppGlobal>();
  final app = Get.find<XPApplication>();
  final network = Get.find<NetworkController>();

  var updateTag = 0.obs;

  @override
  void onInit() {
    //Logger.trace('基类对象初始化');
    super.onInit();
    initData();
    startListener();
    _checkLocalNetworkPermission();
    reloadData();
  }

  @override
  void onReady() {
    //Logger.trace('基类加载就绪');
    super.onReady();
  }

  @override
  void onClose() {
    //Logger.trace('基类对象销毁');
    super.onClose();
  }

  /// 初始化数据
  void initData() {}

  /// 启动监听器
  void startListener() {
    ever(network.isConnected, handleConnectivityChanged);
  }

  void _checkLocalNetworkPermission() async {
    try {
      // 使用 RawDatagramSocket 触发本地网络权限请求
      final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      socket.close();
    } catch (e) {
      print('本地网络权限请求失败: $e');
    }
  }

  /// 重新加载数据
  void reloadData() {}

  void handleConnectivityChanged(bool isConnected) {}
}
