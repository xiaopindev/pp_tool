import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_app/configs/bindings.dart';
import 'package:flutter_app/globals/iap_purchase.dart';
import 'package:flutter_app/modules/database/db_helper.dart';

import 'configs/routers.dart';
import 'generated/l10n.dart';
import 'globals/app_global.dart';
import 'modules/common/unknown_page.dart';
import 'modules/launch_load/launch_page.dart';
import 'pp_kits/common/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().initDatabase();
  await Firebase.initializeApp();

  //所支持的语言
  final supportedLocales = [
    const Locale('ar'),
    const Locale('de'),
    const Locale('en'),
    const Locale('es'),
    const Locale('fr'),
    const Locale('it'),
    const Locale('ja'),
    const Locale('ko'),
    const Locale('pt'),
    const Locale('id'),
    const Locale('vi'),
    const Locale('th'),
    const Locale('fil'),
    const Locale('zh', 'Hant')
  ];
  // 获取系统语言代码
  Locale systemLocale = PlatformDispatcher.instance.locale;

  final global = Get.put(AppGlobal(), permanent: true);
  final savedLocale = await global.savedLocale();

  Logger.log('当前存储的语言 $savedLocale, 当前系统设置的语言: $systemLocale');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        Logger.log("应用进入前台");
        //Get.find<NetworkController>().checkConnectivity();
        break;
      case AppLifecycleState.inactive:
        Logger.log("应用进入非活动状态");
        break;
      case AppLifecycleState.paused:
        Logger.log("应用进入后台");
        break;
      case AppLifecycleState.detached:
        Logger.log("应用被终止");
        Get.find<IapPurchaseController>().completeAllPurchases();
        Get.deleteAll();
        break;
      case AppLifecycleState.hidden:
        Logger.log("应用被隐藏");
        break;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852), // 设计稿的尺寸
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final global = Get.find<AppGlobal>();
        return GetMaterialApp(
          //基础配置
          debugShowCheckedModeBanner: false, // 隐藏调试标志
          navigatorObservers: [observer],
          title: 'Flutter App',
          theme: global.themeVC.theme,
          home: const LaunchLoadingPage(),
          defaultTransition: Transition.rightToLeft, //默认路由动画,iOS默认是rightToLeft
          builder: EasyLoading.init(),
          //国际化
          supportedLocales: S.delegate.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            S.delegate
          ],
          //路由配置
          initialBinding: GetBindingsController(),
          initialRoute: AppPages.root,
          getPages: AppPages.routers,
          unknownRoute:
              GetPage(name: AppPages.notFound, page: () => const UnknownPage()),
        );
      },
    );
  }
}
