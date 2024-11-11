import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';

class SubscriptionMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    Logger.log('SubscriptionMiddleware');
    var isVip = false;
    if (isVip) {
      return null; //跳转到以前的路由，啥事都不做
    } else {
      return const RouteSettings(name: '/subscription', arguments: {});
    }
  }
}
