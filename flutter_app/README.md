# flutter_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 系统配置

ios打包出口许可去除：

``` bash
# Info.plist中配置
<key>ITSAppUsesNonExemptEncryption</key>
 <false/>
```

## 清理重载命令

``` bash
  
rm -rf ~/Library/Developer/Xcode/DerivedData/ && flutter clean && flutter pub get && cd ios && pod install && open Runner.xcworkspace && cd ..
```

```
cd ios
pod deintegrate
pod clean
pod install
```

## JSON对象生成命令

``` bash
dart run build_runner build --delete-conflicting-outputs
```

## 发布到测试命令

``` bash
flutter_distributor release --name dev
```

## 正式发布打包命令

打包之前搜索：“生产环境注释”， 并注释测试代码

运行命令行 `flutter build ipa` 之后会在 `build/ios/archive` 文件夹下生成一个 Xcode 构建归档（.xcarchive 文档），在 `build/ios/ipa` 文件夹下会生成一个 App Store 销售套装文件（.ipa 文件）。

混淆你的应用程序
要混淆你的应用程序，请在 release 模式下使用 flutter build 命令，并使用 --obfuscate 和 --split-debug-info 选项。 --split-debug-info 选项指定了 Flutter 输出调试文件的目录。在混淆的情况下，它会输出一个符号表。请参考以下命令：

有没有目录先创建存放目录：

``` bash
mkdir -p symbols/ios
```

有目录直接运行命令：

``` bash
flutter build ipa --obfuscate --split-debug-info=symbols/ios
```

```
flutter_app/
├── lib/
│   └── main.dart
├── ios/
│   ├── Runner/
│   │   └── AppDelegate.swift
│   ├── Runner.xcodeproj/
│   ├── Runner.xcworkspace/
│   └── WidgetsExtension/
│       ├── Info.plist
│       ├── Localizable.strings (English)
│       ├── Localizable.strings (Chinese)
│       └── PlayerSmallWidget.swift
├── symbols/
│   └── ios/
│       ├── app.dill
│       ├── app.dill.deps
│       ├── app.dill.map
│       └── ...
└── pubspec.yaml
```

一旦你混淆了二进制文件，请务必 保存符号表文件。如果你将来需要解析混淆后的堆栈跟踪，你将需要该文件。

## 订阅内购

/*
responseBody['status']
内购验证凭据返回结果状态码说明
    0 成功验证。收据是有效的，且购买信息正确。
21000 App Store无法读取你提供的JSON数据
21002 收据数据不符合格式
21003 收据无法被验证
21004 你提供的共享密钥和账户的共享密钥不一致
21005 收据服务器当前不可用
21006 收据是有效的，但订阅服务已经过期。当收到这个信息时，解码后的收据信息也包含在返回内容中
21007 收据信息是测试用（sandbox），但却被发送到产品环境中验证
21008 收据信息是产品环境中使用，但却被发送到测试环境中验证
21010 收据无法被验证。这通常意味着提供的收据信息不正确或已被篡改
*/

```
latest_receipt_info:
{
    "quantity": "1",
    "product_id": "offline_music_weekly",
    "transaction_id": "2000000670671756",
    "original_transaction_id": "2000000663983510",
    "purchase_date": "2024-07-30 01:54:42 Etc/GMT",
    "purchase_date_ms": "1722304482000",
    "purchase_date_pst": "2024-07-29 18:54:42 America/Los_Angeles",
    "original_purchase_date": "2024-07-23 02:31:16 Etc/GMT",
    "original_purchase_date_ms": "1721701876000",
    "original_purchase_date_pst": "2024-07-22 19:31:16 America/Los_Angeles",
    "expires_date": "2024-07-30 01:57:42 Etc/GMT",
    "expires_date_ms": "1722304662000",
    "expires_date_pst": "2024-07-29 18:57:42 America/Los_Angeles",
    "web_order_line_item_id": "2000000069096309",
    "is_trial_period": "false",
    "is_in_intro_offer_period": "false",
    "in_app_ownership_type": "PURCHASED",
    "subscription_group_identifier": "21514252"
}
quantity: 购买的商品数量。
product_id: 商品的唯一标识符。
transaction_id: 交易的唯一标识符。
original_transaction_id: 原始交易的唯一标识符（用于恢复购买）。
purchase_date: 购买日期（UTC 时间）。
purchase_date_ms: 购买日期的毫秒时间戳。
purchase_date_pst: 购买日期（太平洋标准时间）。
original_purchase_date: 原始购买日期（UTC 时间）。
original_purchase_date_ms: 原始购买日期的毫秒时间戳。
original_purchase_date_pst: 原始购买日期（太平洋标准时间）。
expires_date: 订阅到期日期（UTC 时间）。
expires_date_ms: 订阅到期日期的毫秒时间戳。
expires_date_pst: 订阅到期日期（太平洋标准时间）。
web_order_line_item_id: Web 订单行项目的唯一标识符。
is_trial_period: 是否为试用期（true 或 false）。
is_in_intro_offer_period: 是否在介绍优惠期（true 或 false）。
in_app_ownership_type: 应用内购买的所有权类型（例如，PURCHASED）。
subscription_group_identifier: 订阅组标识符。
这些字段提供了有关购买的详细信息，包括购买时间、到期时间、交易标识符等。你可以根据这些信息来验证和处理用户的购买。
```
