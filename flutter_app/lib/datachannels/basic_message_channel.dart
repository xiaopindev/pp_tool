import 'package:flutter/services.dart';
import 'package:flutter_app/pp_kits/common/logger.dart';

class BasicMessageChannelHandler {
  // 单例模式实现
  static final BasicMessageChannelHandler _instance =
      BasicMessageChannelHandler._internal();
  BasicMessageChannelHandler._internal();
  factory BasicMessageChannelHandler() => _instance;

  final BasicMessageChannel<String> _messageChannel =
      const BasicMessageChannel<String>(
          'com.example.app/messages', StringCodec());

  void setupChannel() {
    _messageChannel.setMessageHandler((String? message) async {
      Logger.log('Received message: $message');
      // 可以根据接收到的消息进行处理
      return 'Response from Flutter';
    });
  }

  Future<String?> sendMessage(String message) async {
    try {
      final String? response = await _messageChannel.send(message);
      Logger.log('Received response: $response');
      return response;
    } catch (e) {
      Logger.log('Error sending message: $e');
      return null;
    }
  }

  // 添加清理方法
  void dispose() {
    _messageChannel.setMessageHandler(null);
  }
}
