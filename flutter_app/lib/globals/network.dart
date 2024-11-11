import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_app/globals/app_global.dart';
import 'dart:async';

import 'package:flutter_app/pp_kits/pp_kits.dart';

enum NetworkStatus {
  mobile,
  wifi,
  ethernet,
  vpn,
  bluetooth,
  none // 用于无网络和未知网络类型
}

class NetworkController extends GetxController {
  var isConnected = false.obs;
  var status = NetworkStatus.none.obs;
  late final Connectivity _connectivity;
  late final StreamSubscription<List<ConnectivityResult>>
      _connectivitySubscription;

  final global = Get.find<AppGlobal>();

  @override
  void onInit() {
    super.onInit();
    _connectivity = Connectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      Logger.trace('onConnectivityChanged');
      _updateNetworkStatus(results);
    });
    Logger.log('网络初始化完成, 开启监听中...');
  }

  void _updateNetworkStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.mobile)) {
      status.value = NetworkStatus.mobile;
      Logger.trace('连接的移动网络');
      global.logEvent('net_cellular');
    } else if (results.contains(ConnectivityResult.wifi)) {
      status.value = NetworkStatus.wifi;
      Logger.trace('连接的Wifi网络');
      global.logEvent('net_wifi');
    } else if (results.contains(ConnectivityResult.ethernet)) {
      status.value = NetworkStatus.ethernet;
      Logger.trace('连接的以太网');
      global.logEvent('net_ethernet');
    } else if (results.contains(ConnectivityResult.vpn)) {
      status.value = NetworkStatus.vpn;
      Logger.trace('连接的VPN网络');
      global.logEvent('net_vpn');
    } else if (results.contains(ConnectivityResult.bluetooth)) {
      status.value = NetworkStatus.bluetooth;
      Logger.trace('连接的蓝牙网络');
      global.logEvent('net_bluetooth');
    } else if (results.contains(ConnectivityResult.other)) {
      status.value = NetworkStatus.none;
      global.logEvent('net_unavailable');
    } else if (results.contains(ConnectivityResult.none)) {
      status.value = NetworkStatus.none;
      global.logEvent('net_notreachable');
    }
    if (status.value == NetworkStatus.none) {
      Logger.trace('网络已断开');
      isConnected.value = false;
    } else {
      Logger.trace('网络已连接: ${status.value}');
      isConnected.value = true;
    }
  }

  @override
  void onClose() {
    Logger.trace('NetworkController资源释放');
    _connectivitySubscription.cancel();
    super.onClose();
  }

  void checkConnectivity() async {
    final List<ConnectivityResult> results =
        await (_connectivity.checkConnectivity());
    _updateNetworkStatus(results);
  }
}
/*
Obx(() {
  switch (networkController.status.value) {
    case NetworkStatus.mobile:
      return Text("Mobile network available");
    case NetworkStatus.wifi:
      return Text("Wi-Fi is available");
    case NetworkStatus.ethernet:
      return Text("Ethernet connection available");
    case NetworkStatus.vpn:
      return Text("VPN connection active");
    case NetworkStatus.bluetooth:
      return Text("Bluetooth connection available");
    case NetworkStatus.none:
      return Text("No network or unknown network type");
    default:
      return Text("Checking network status...");
  }
});
*/