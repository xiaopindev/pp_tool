/// 网络状态改变事件
class NetworkChangedEvent {
  final String message;

  NetworkChangedEvent(this.message);
}

/// 主题改变事件
class ThemeChangedEvent {
  final String message;

  ThemeChangedEvent(this.message);
}

/// VIP状态改变事件
class VipStatusChangedEvent {
  final String message;

  VipStatusChangedEvent(this.message);
}

/// 产品信息改变事件
class ProductChangedEvent {
  final String message;

  ProductChangedEvent(this.message);
}
