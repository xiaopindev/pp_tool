import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_app/pp_kits/common/logger.dart';

class EventChannelHandler {
  //单例写法
  static final EventChannelHandler _instance = EventChannelHandler._internal();
  EventChannelHandler._internal();
  factory EventChannelHandler() => _instance;

  final _eventChannel = const EventChannel('com.example.app/events');
  StreamSubscription? _streamSubscription;

  void setupChannel() {
    _cancelPreviousSubscription(); // 取消之前的订阅
    _streamSubscription = _eventChannel.receiveBroadcastStream().listen(
          _onEvent,
          onError: _onError,
          onDone: _onDone,
        );
  }

  void dispose() {
    _cancelPreviousSubscription();
  }

  /*
  flutter: Received event: Hello from iOS
  flutter: Received event: 123
  flutter: Received event: true
  flutter: Received event: [item1, item2, 123, true]
  flutter: Received event: {key1: value1, key3: false, key2: 123}
  flutter: Received event: null
  */
  void _onEvent(dynamic event) {
    Logger.log('Received event: $event');
    // 这里可以根据事件进行相应的处理
  }

  void _onError(Object error) {
    Logger.log('Received error: $error');
  }

  void _onDone() {
    Logger.log('Event channel closed');
  }

  void _cancelPreviousSubscription() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }
}
