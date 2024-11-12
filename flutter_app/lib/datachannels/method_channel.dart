import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_app/pp_kits/common/logger.dart';

class MethodChannelHandler {
  //单例写法
  static final MethodChannelHandler _instance =
      MethodChannelHandler._internal();
  MethodChannelHandler._internal();
  factory MethodChannelHandler() {
    return _instance;
  }

  final _methodChannel = const MethodChannel('com.mobiunity.musicapp/methods');

  void setupChannel() {
    _methodChannel.setMethodCallHandler(_handleMethodCall);
  }

  void dispose() {
    _methodChannel.setMethodCallHandler(null);
  }

  // 接收原生端调用Flutter端方法
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    try {
      switch (call.method) {
        case 'navigateToPage':
          navigateToPage(call.arguments);
        case 'audioPlayerAction':
          audioPlayerAction(call.arguments);
        default:
          throw PlatformException(
            code: 'Unimplemented',
            details: 'The method ${call.method} is not implemented.',
          );
      }
    } catch (e) {
      Logger.log("Error handling method call: ${e.toString()}");
      return null;
    }
  }

  void navigateToPage(String name) {
    switch (name) {
      case "AutoPaste":
        //设置全局 Navigator key，可以在非界面相关的类种进行页面跳转或者其他更好的方式,以下两种参考
        //Navigator.of(navigatorKey.currentContext!).pushNamed("AutoPaste");
        //navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => AutoPastePage()));
        Logger.log("跳转到AutoPaste页面");
        break;
      default:
    }
  }

  void audioPlayerAction(String event) {
    // final player = Get.find<PlayerController>();
    // switch (event) {
    //   case "prev":
    //     player.seekToPrevious();
    //     break;
    //   case "playOrPause":
    //     player.playOrPause();
    //     break;
    //   case "next":
    //     player.seekToNext();
    //     break;
    //   default:
    // }
  }

  // 导出文件-调用原生端方法
  Future<bool> exportFile(String filePath) async {
    try {
      final Map<String, String> params = {'filePath': filePath};
      final result = await _methodChannel.invokeMethod('exportFile', params);
      Logger.log('exportFile to $result');
      return true;
    } catch (e) {
      Logger.log('Error sending to native: $e');
      return false;
    }
  }

  // 存储当前播放歌曲信息到共享沙盒-调用原生端方法
  Future<void> saveCurrentTrackToAG(
      String title, String artist, String filePath, bool isPlaying) async {
    try {
      final Map<String, dynamic> params = {
        'title': title,
        'artist': artist,
        'filePath': filePath,
        'isPlaying': isPlaying
      };
      final result =
          await _methodChannel.invokeMethod('saveCurrentTrackToAG', params);
      Logger.log('saveCurrentTrackToAG  $result');
    } catch (e) {
      Logger.log('Error sending to native: $e');
    }
  }
}
