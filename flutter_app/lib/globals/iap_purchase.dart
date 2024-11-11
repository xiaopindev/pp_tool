import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_app/configs/events.dart';
import 'package:flutter_app/modules/common/base/base_controller.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class Product {
  final String pid;
  ProductDetails? storeProduct;

  Product({required this.pid, this.storeProduct});
}

class IapPurchaseController extends BaseController {
  /* #region 单例创建方法 */
  static final IapPurchaseController _instance =
      IapPurchaseController._internal();
  factory IapPurchaseController() => _instance;
  IapPurchaseController._internal();
  /* #endregion */

  /* #region 私有属性变量 */
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  final _iap = InAppPurchase.instance;
  final _productIds = [
    //'music_vip_weekly',
    'offline_music_weekly',
    'offline_music_annually'
  ];
  var _productDetails = <ProductDetails>[];
  final _purchingDetails = <PurchaseDetails>[];
  var _isRestoring = false;
  /* #endregion */

  /* #region 私有方法 */

  void _startListen() {
    Logger.trace('开始交易监听...');

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) async {
      Logger.trace('监听到交易记录数: ${purchaseDetailsList.length}');
      //_purchaseDetails = purchaseDetailsList;
      await _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () async {
      Logger.trace('监听完毕');
      await _subscription.cancel();
      _hideLoading();
    }, onError: (error) async {
      Logger.trace('监听出错 error: $error');
      await _subscription.cancel();
      _hideLoading();
    });
  }

  Future<void> _checkSubscription() async {
    if (app.isSubscribed) {
      Logger.trace('已经订阅过周会员，不享受免费权益');
      return;
    }
    // 每次启动时，先检查是否已经订阅过
    Logger.trace('开始检测交易记录是否订阅过周会员...');
    try {
      String receiptData = await SKReceiptManager.retrieveReceiptData();
      await _verifyProductionOnApple(receiptData);
    } catch (e) {
      Logger.trace('没有获取到凭证 $e');
      // 请求刷新凭证
      try {
        Logger.trace('尝试刷新凭证...');
        await SKRequestMaker().startRefreshReceiptRequest();
        // 再次尝试获取凭证
        String receiptData = await SKReceiptManager.retrieveReceiptData();
        await _verifyProductionOnApple(receiptData);
      } catch (refreshError) {
        Logger.trace('刷新凭证失败 $refreshError');
      }
    }
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    if (_isRestoring && purchaseDetailsList.isEmpty) {
      PPAlert.showSysAlert(
          'IAP_RestoreFailedTitle'.localized, 'IAP_RestoreFailedMsg'.localized);
      _isRestoring = false;
      _hideLoading();
      return;
    }
    for (var purchaseDetails in purchaseDetailsList) {
      if (_isRestoring) {
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
        _isRestoring = false;
      }
      if (purchaseDetails.status == PurchaseStatus.pending) {
        Logger.trace('pending 正在购买 ${purchaseDetails.productID}');
        _purchingDetails.add(purchaseDetails);
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          Logger.trace('交易失败 ${purchaseDetails.purchaseID}');
          _hideLoading();
          final iapError = purchaseDetails.error;
          if (iapError != null) {
            String localDescription = iapError.details.toString();
            if (iapError.details is Map) {
              if (iapError.details.containsKey('NSLocalizedDescription')) {
                localDescription = iapError.details['NSLocalizedDescription'];
              }
            }
            global.logEvent('${_fek()}iap_buy_error_${iapError.code}',
                {'errorMsg': iapError.toString()});
            global.reportErrorToCrashlytics(
                localDescription, iapError, StackTrace.current);
            runInBackground = true;
            _isRestoring = true;
            _iap.restorePurchases();
            PPAlert.showSysAlert(
                'IAP_PurchaseFailedTitle'.localized, localDescription);
          } else {
            global.logEvent('${_fek()}iap_buy_error_unkown');
          }
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          Logger.trace('交易取消 ${purchaseDetails.purchaseID}');
          global.logEvent('${_fek()}iap_buy_cancel');
          _hideLoading();
        } else if (purchaseDetails.status == PurchaseStatus.restored) {
          _handleRestored(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          _handlePurchased(purchaseDetails);
        }
        //对没有完成的订单设置为完成
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
        _purchingDetails.removeWhere(
            (item) => item.transactionDate == purchaseDetails.transactionDate);
      }
    }
  }

  // 验证购买成功凭据
  Future<void> _handleRestored(PurchaseDetails purchaseDetails) async {
    //最后一次购买时间大于当前交易凭据的购买时间，不做处理
    if (app.lastPurchaseTime > int.parse(purchaseDetails.transactionDate!)) {
      Logger.trace(
          '无效的交易ID: ${purchaseDetails.purchaseID}, 购买时间:${int.parse(purchaseDetails.transactionDate!).toDateStr()}, 当前最新购买时间: ${app.lastPurchaseTime.toDateStr()} 状态: ${purchaseDetails.status}');
      return;
    }
    Logger.trace('restored 恢复交易凭据 ${purchaseDetails.purchaseID}');
    bool isValid = await _verifyReceipt(purchaseDetails);
    if (isValid) {
      Logger.trace('当前运行模式：${runInBackground ? '后台运行' : '前台运行'}');
      if (!runInBackground) {
        //如果不是后台运行，自动更新状态值并刷新界面
        global.isVip.value = app.isVip;
        update();
        PPAlert.showSysAlert('IAP_RestoreSuccessTitle'.localized,
            'IAP_RestoreSuccessMsg'.localized, onOK: () {
          eventBus.send(VipStatusChangedEvent('尊贵的会员，欢迎归来！'));
        });
        global.logEvent('${_fek()}iap_restore_ok');
      } else {
        //默认只要将会员状态和过期时间存储到本地即可，且保持后台持续运行来监听过期状态
        //如果有需要更新也可以手动global.checkVip()更新
      }
      Logger.trace(
          '验证成功 ${purchaseDetails.purchaseID}, 会员 ${global.isVip.value} 有效期至：${app.expireTime.toDateStr()}');
    } else {
      Logger.trace('验证失败 ${purchaseDetails.purchaseID}');
      global.logEvent('${_fek()}iap_restore_failed');
      if (!runInBackground) {
        PPAlert.showSysAlert('IAP_RestoreFailedTitle'.localized,
            'IAP_RestoreFailedMsg'.localized);
      }
    }
    _hideLoading();
  }

  //验证恢复凭据
  Future<void> _handlePurchased(PurchaseDetails purchaseDetails) async {
    //最后一次购买时间大于当前交易凭据的购买时间，不做处理
    if (app.lastPurchaseTime > int.parse(purchaseDetails.transactionDate!)) {
      Logger.trace(
          '无效的交易ID: ${purchaseDetails.purchaseID}, 购买时间:${int.parse(purchaseDetails.transactionDate!).toDateStr()}, 当前最新购买时间: ${app.lastPurchaseTime.toDateStr()} 状态: ${purchaseDetails.status}');
      return;
    }
    Logger.trace('purchased 已购买交易凭据 ${purchaseDetails.purchaseID}');
    bool isValid = await _verifyReceipt(purchaseDetails);
    if (isValid) {
      Logger.trace('当前运行模式：${runInBackground ? '后台运行' : '前台运行'}');
      if (!runInBackground) {
        //如果不是后台运行，自动更新状态值并刷新界面
        global.isVip.value = app.isVip;
        update();
      } else {
        //默认只要将会员状态和过期时间存储到本地即可，且保持后台持续运行来监听过期状态
        //如果有需要更新也可以手动global.checkVip()更新
      }
      Logger.trace(
          '验证成功 ${purchaseDetails.purchaseID}, 会员 ${global.isVip.value} 有效期至：${app.expireTime.toDateStr()}');
      eventBus.send(VipStatusChangedEvent('尊贵的会员，欢迎加入我们的世界！'));
      global.logEvent('${_fek()}iap_buy_ok');
      global.logEvent('${_fek()}iap_ok_${purchaseDetails.productID}');
      if (app.isSubscribed) {
        global.logEvent('${_fek()}iap_buy_ok_new');
      } else {
        global.logEvent('${_fek()}iap_buy_ok_old');
      }
    } else {
      Logger.trace('验证失败 ${purchaseDetails.purchaseID}');
      global.logEvent('${_fek()}iap_buy_failed');
    }
    _hideLoading();
  }

  /// 验证交易凭据
  Future<bool> _verifyReceipt(PurchaseDetails purchaseDetails) async {
    var retVal = false;

    DateTime time = DateTime.fromMillisecondsSinceEpoch(
        int.parse(purchaseDetails.transactionDate!));
    Logger.trace(
        '交易凭据明细:\n 交易ID:${purchaseDetails.purchaseID} 产品ID:${purchaseDetails.productID} 购买时间:$time 购买状态:${purchaseDetails.status} 购买来源：${purchaseDetails.verificationData.source} 完成状态:${purchaseDetails.pendingCompletePurchase}');
    Logger.trace(
        '开始验证交易 ${purchaseDetails.purchaseID} 验证地址: https://buy.itunes.apple.com/verifyReceipt \n\n');

    // 检查是否在测试环境（本地测试时用）
    // if (global.isTestEnvironment &&
    //     purchaseDetails.verificationData.source == 'app_store') {
    //   Logger.trace('使用 StoreKit Configuration 文件进行测试，跳过实际验证');
    //   await app.setIsVip(true);
    //   await app.setExpireTime(DateTime.now()
    //       .add(const Duration(minutes: 3))
    //       .millisecondsSinceEpoch);
    //   return true; // 模拟验证成功
    // }

    // 构建验证请求的凭据
    final receiptData = purchaseDetails.verificationData.localVerificationData;
    retVal = await _verifyProductionOnApple(receiptData);
    return retVal;
  }

  /// 验证生产环境交易凭据
  Future<bool> _verifyProductionOnApple(String receiptData) async {
    var retVal = false;
    // 发送验证请求到生产环境服务器
    try {
      final response = await Dio().post(
        'https://buy.itunes.apple.com/verifyReceipt',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
        ),
        data: jsonEncode(<String, dynamic>{
          'receipt-data': receiptData,
          'exclude-old-transactions': true,
          'password': 'cacdf80cba1241718168a283e80762cf',
        }),
      );

      if (response.statusCode != 200) {
        Logger.trace('验证请求失败，HTTP状态码: ${response.statusCode}');
        if (response.statusCode != null) {
          global.logEvent('${_fek()}iap_verify_err_1000_$response.statusCode');
        } else {
          global.logEvent('${_fek()}iap_verify_err_1000',
              {'code': response.statusCode ?? '!=200'});
        }
        return retVal;
      }
      final Map<String, dynamic> responseBody = response.data;

      if (responseBody['status'] == 21007) {
        global.logEvent('${_fek()}iap_verify_err_1001_21007');
        Logger.trace(
            '21007: 收据信息是测试用(sandbox), 开启沙盒验证: https://sandbox.itunes.apple.com/verifyReceipt');
        retVal = await _verifySandboxOnApple(receiptData);
      } else if (responseBody['status'] == 0) {
        var receiptInfos = responseBody['latest_receipt_info'];
        Logger.trace('成功获取凭据，数量 ${receiptInfos.length}');

        // 根据 purchase_date_ms 购买时间进行降序排列
        receiptInfos.sort((a, b) {
          var purchaseDateA = int.parse(a['purchase_date_ms']);
          var purchaseDateB = int.parse(b['purchase_date_ms']);
          return purchaseDateB.compareTo(purchaseDateA);
        });

        for (var receiptInfo in receiptInfos) {
          var purchaseDateMs = int.parse(receiptInfo['purchase_date_ms']);
          var expiresDateMs = int.parse(receiptInfo['expires_date_ms']);
          String productId = receiptInfo['product_id'];
          bool isTrialPeriod = bool.parse(receiptInfo['is_trial_period']);

          //如果是周会员, 获取是否为试用期状态, 存储到本地
          if (productId == 'offline_music_weekly') {
            Logger.trace('检测到周会员交易记录, 是否为试用期: $isTrialPeriod');
            //await app.setIsTrialPeriod(isTrialPeriod);
            await app.setIsSubscribed(true);
          }

          //如果购买大于本地购买时间，则更新本地购买时间，规避重装无最后一次购买时间
          if (purchaseDateMs > app.lastPurchaseTime) {
            await app.setLastPurchaseTime(purchaseDateMs);
          }

          if (!global.isTestEnvironment) {
            expiresDateMs += 3600 * 1000;
          }

          if (expiresDateMs > DateTime.now().millisecondsSinceEpoch) {
            await app.setIsVip(true);
            await app.setLastPurchaseTime(purchaseDateMs);
            await app.setExpireTime(expiresDateMs);
            Logger.trace('验证成功，购买凭证有效期至：${expiresDateMs.toDateStr()}');
            retVal = true;
            break;
          }
        }
      } else {
        Logger.trace('验证失败，状态码: ${responseBody['status']}');
        int status = responseBody['status'];
        global.logEvent(
            '${_fek()}iap_verify_err_1001_$status', {'error': status});
      }
    } catch (e) {
      Logger.trace('验证请求出错: $e');
      global.logEvent('${_fek()}iap_verify_err_1002', {'error': e});
    }
    return retVal;
  }

  /// 验证沙盒环境凭据
  Future<bool> _verifySandboxOnApple(String receiptData) async {
    var retVal = false;
    try {
      final response = await Dio().post(
        'https://sandbox.itunes.apple.com/verifyReceipt',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
        ),
        data: jsonEncode(<String, dynamic>{
          'receipt-data': receiptData,
          'exclude-old-transactions': true,
          'password': 'cacdf80cba1241718168a283e80762cf',
        }),
      );

      if (response.statusCode != 200) {
        Logger.trace('沙盒环境验证请求失败，HTTP状态码: ${response.statusCode}');
        return retVal;
      }

      final Map<String, dynamic> responseBody = response.data;
      if (responseBody['status'] == 0) {
        var receiptInfos = responseBody['latest_receipt_info'];
        Logger.trace('成功获取凭据，数量 ${receiptInfos.length}');

        // 根据 purchase_date_ms 进行降序排列
        receiptInfos.sort((a, b) {
          var purchaseDateA = int.parse(a['purchase_date_ms']);
          var purchaseDateB = int.parse(b['purchase_date_ms']);
          return purchaseDateB.compareTo(purchaseDateA);
        });

        for (var receiptInfo in receiptInfos) {
          var transactionId = int.parse(receiptInfo['transaction_id']);
          var originTransId = int.parse(receiptInfo['original_transaction_id']);
          var purchaseDateMs = int.parse(receiptInfo['purchase_date_ms']);
          var expiresDateMs = int.parse(receiptInfo['expires_date_ms']);
          String productId = receiptInfo['product_id'];
          bool isTrialPeriod = bool.parse(receiptInfo['is_trial_period']);

          //如果是周会员, 获取是否为试用期状态, 存储到本地
          if (productId == 'offline_music_weekly') {
            Logger.trace('检测到周会员交易记录, 是否为试用期: $isTrialPeriod');
            //await app.setIsTrialPeriod(isTrialPeriod);
            await app.setIsSubscribed(true);
          }

          //如果购买时间大于本地存储的购买时间，则更新本地购买时间，规避重装无最后一次购买时间
          if (purchaseDateMs > app.lastPurchaseTime) {
            await app.setLastPurchaseTime(purchaseDateMs);
          }

          //过期时间加1分钟
          expiresDateMs += 60 * 1000;
          if (expiresDateMs > DateTime.now().millisecondsSinceEpoch) {
            await app.setIsVip(true);
            await app.setLastPurchaseTime(purchaseDateMs);
            await app.setExpireTime(expiresDateMs);
            Logger.trace(
                '沙盒验证成功，产品ID: $productId 购买凭证有效期至: ${expiresDateMs.toDateStr()} 购买时间: ${purchaseDateMs.toDateStr()} 原始ID: $originTransId 交易ID: $transactionId');
            retVal = true;
            break;
          } else {
            Logger.trace(
                '沙盒验证失败，产品ID: $productId 购买凭证有效期至: ${expiresDateMs.toDateStr()} 购买时间: ${purchaseDateMs.toDateStr()} 原始ID: $originTransId 交易ID: $transactionId');
          }
        }
      } else {
        Logger.trace('沙盒环境验证失败，状态码: ${responseBody['status']}');
      }
    } catch (e) {
      Logger.trace('沙盒环境验证请求出错: $e');
    }
    return retVal;
  }

  /// 隐藏加载状态
  void _hideLoading() {
    if (runInBackground) {
      return;
    }
    EasyLoading.dismiss();
    runInBackground = true;
  }

  /// 获取事件头标志
  String _fek() {
    if (fromPage == 1) {
      return 'g';
    } else if (fromPage == 2) {
      return 'h';
    }
    return '';
  }

  /* #endregion */

  @override
  void onInit() {
    super.onInit();
    Logger.trace('应用内购买对象创建成功');
    _startListen();
    //_completePendingPurchases();
    //requestProducts();
  }

  @override
  void onClose() {
    Logger.trace('资源释放');
    _subscription.cancel();
    super.onClose();
  }

  @override
  void handleConnectivityChanged(bool isConnected) {
    Logger.trace('监听到网络变化 isConnected = $isConnected');
    if (isConnected) {
      requestProducts();
    }
  }

  /* #region 公开属性 */
  /// 默认在后台运行，如果需要前台运行，请设置为false，并控制加载状态效果或其他逻辑
  var runInBackground = true;
  //0.默认订阅页，1.引导页，2.首页
  var fromPage = 0;
  // 界面显示需要的内容属性
  var weeklyPrice = '0';
  var weeklyProductText = 'Subscribe_Product2';
  var aunnalProductText = 'Subscribe_Product1';
  var products = [
    Product(pid: 'offline_music_weekly'),
    Product(pid: 'offline_music_annually'),
  ];
  /* #endregion */

  /* #region 公开方法 */

  /// 请求产品信息
  Future<void> requestProducts() async {
    await _checkSubscription();

    Logger.trace('准备请求产品信息...');
    if (network.isConnected.value == false) {
      Logger.trace('网络不可用，等待网络恢复...');
      global.logEvent('iap_req_pro_netlost');
      return;
    }

    //没有产品，请求产品信息
    Logger.trace('开始请求产品信息...');
    global.logEvent('iap_req_pro_start');
    final ProductDetailsResponse response =
        await _iap.queryProductDetails(_productIds.toSet());
    if (response.notFoundIDs.isNotEmpty) {
      Logger.trace('未请求到产品ID: ${response.notFoundIDs}');
      global.logEvent('iap_req_products_failed');
      return;
    }
    _productDetails = response.productDetails;
    Logger.trace('请求产品信息成功:');
    global.logEvent('iap_req_products_ok');

    for (var item in _productDetails) {
      if (item.id == products[0].pid) {
        products[0].storeProduct = item;
        weeklyPrice = item.price;
        if (app.isSubscribed) {
          weeklyProductText =
              'Subscribe_Product2'.localized.replaceAll('[pWeek]', item.price);
        } else {
          weeklyProductText = 'Subscribe_Product2_free'
              .localized
              .replaceAll('[pWeek]', item.price);
        }
      } else if (item.id == products[1].pid) {
        products[1].storeProduct = item;
        aunnalProductText =
            'Subscribe_Product1'.localized.replaceAll('[pYear]', item.price);
        aunnalProductText = aunnalProductText.replaceAll('[pWeek]',
            item.currencySymbol + (item.rawPrice / 52.0).toStringAsFixed(2));
      }
      eventBus.send(ProductChangedEvent('Request Products done!'));
      Logger.trace(
          'ProductDetails: id>${item.id} title>${item.title} description>${item.description} price>${item.price} rawPrice>${item.rawPrice} currencyCode>${item.currencyCode} currencySymbol>${item.currencySymbol}');
    }
  }

  /// 购买产品
  Future<void> purchase(ProductDetails productDetails) async {
    app.checkVip();
    if (app.isVip) {
      eventBus.send(VipStatusChangedEvent('点击订阅检测到时会员'));
      _hideLoading();
      return;
    }

    if (network.isConnected.value == false) {
      Logger.trace('网络不可用，等待网络恢复...');
      global.logEvent('${_fek()}iap_network_lost');
      PPAlert.showSysAlert(
          'NetworkNotAvailable'.localized, 'Network_Lost'.localized);
      _hideLoading();
      return;
    }

    Logger.trace('开始购买 ${productDetails.id}...');
    try {
      global.logEvent('${_fek()}iap_start_buy');
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productDetails);
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e, stackTrace) {
      global.logEvent('${_fek()}iap_buy_crash', {'msg': e.toString()});
      Logger.trace('购买过程中发生异常: ${e.toString()}');
      Logger.trace('Stack trace: $stackTrace');
      global.reportErrorToCrashlytics(e.toString(), e, stackTrace);
      PPAlert.showSysAlert(
          'IAP_PurchaseCrashTitle'.localized, 'IAP_PurchaseCrashMsg'.localized,
          onOK: () {
        EasyLoading.show(status: 'IAP_Restoring'.localized);
        runInBackground = false;
        restorePurchases();
      });
      _hideLoading();
    }
  }

  /// 恢复购买
  Future<void> restorePurchases() async {
    app.checkVip();
    if (app.isVip) {
      eventBus.send(VipStatusChangedEvent('恢复检测到时会员'));
      _hideLoading();
      return;
    }
    if (network.isConnected.value == false) {
      Logger.trace('网络不可用，等待网络恢复...');
      global.logEvent('${_fek()}iap_network_lost');
      PPAlert.showSysAlert(
          'NetworkNotAvailable'.localized, 'Network_Lost'.localized);
      _hideLoading();
      return;
    }

    try {
      Logger.trace('开始恢复购买中...');
      _isRestoring = true;
      global.logEvent('${_fek()}iap_start_restore');
      await _iap.restorePurchases();
    } catch (e, stackTrace) {
      Logger.trace('恢复购买error: ${e.toString()} $stackTrace');
      global.logEvent('${_fek()}iap_restore_crash', {'error': e.toString()});
      PPAlert.showSysAlert(
          'IAP_RestoreFailedTitle'.localized, 'IAP_RestoreFailedMsg'.localized);
      _hideLoading();
    }
  }

  void completeAllPurchases() async {
    if (_purchingDetails.isNotEmpty) {
      Logger.trace('completeAllPurchases ...');
    }
    for (var pd in _purchingDetails) {
      InAppPurchase.instance.completePurchase(pd);
    }
    Logger.trace("completeAllPurchases done");
  }
  /* #endregion */
}
