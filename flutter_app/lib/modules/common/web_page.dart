import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

// 导入特定于平台的功能包
/* #region platform_features */
import 'package:webview_flutter_android/webview_flutter_android.dart'; // Android 特有功能
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'; // iOS 特有功能
/* #endregion */

// 定义一个 StatefulWidget，因为 WebView 页面可能需要根据用户交互来更新状态
class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

// WebViewPage 的状态类
class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController
      _controller; // 声明一个 WebViewController，用于控制 WebView
  var _progress = 0.0; // 添加一个新的状态变量来跟踪加载进度

  // 使用 GetX 获取从上一个页面传递过来的参数
  final _title = Get.arguments['title']; // 获取标题
  final _url = Get.arguments['url']; // 获取要加载的 URL

  @override
  void initState() {
    super.initState();

    // 根据平台选择合适的 WebView 控制器创建参数
    /* #region platform_features */
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      // iOS 平台的特定参数设置
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true, // 允许内联媒体播放
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{}, // 不需要用户操作即可播放的媒体类型
      );
    } else {
      // 其他平台使用默认参数
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    /* #endregion */

    // 配置 WebView 控制器
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // 允许运行 JavaScript
      ..setBackgroundColor(const Color(0x00000000)) // 设置背景颜色
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)'); // 打印加载进度
            setState(() {
              _progress = progress / 100.0; // 更新进度
            });
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url'); // 页面开始加载时打印
            setState(() {
              _progress = 0.0; // 页面开始加载时重置进度
            });
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url'); // 页面加载完成时打印
            setState(() {
              _progress = 1.0; // 页面加载完成时设置进度为100%
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
            Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
          '''); // 页面资源加载错误时打印详细信息
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint(
                  'blocking navigation to ${request.url}'); // 阻止导航到 YouTube
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}'); // 允许导航到其他 URL
            return NavigationDecision.navigate;
          },
          onHttpError: (HttpResponseError error) {
            debugPrint(
                'Error occurred on page: ${error.response?.statusCode}'); // HTTP 错误时打印状态码
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}'); // URL 变更时打印
          },
          onHttpAuthRequest: (HttpAuthRequest request) {}, // HTTP 认证请求处理
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(message.message)), // 接收到 JavaScript 消息时显示 Snackbar
          );
        },
      )
      ..loadRequest(Uri.parse(_url)); // 加载指定 URL

    // 根据平台启用特定功能
    /* #region platform_features */
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true); // Android 平台启用调试
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false); // 允许自动播放媒体
    }
    /* #endregion */

    _controller = controller; // 初始化控制器
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title), // 设置页面标题
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(); // 点击返回按钮，返回上一个页面
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: _progress < 1.0
              ? LinearProgressIndicator(value: _progress) // 显示进度条
              : const SizedBox.shrink(), // 加载完成后不显示进度条
        ),
      ),
      body: WebViewWidget(controller: _controller), // 显示 WebView
    );
  }
}
