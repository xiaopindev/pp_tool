import 'package:flutter/material.dart';
import 'package:flutter_app/modules/common/temps/tab1_main_page.dart';
import 'package:flutter_app/modules/common/temps/tab2_main_page.dart';
import 'package:flutter_app/modules/common/temps/tab3_main_page.dart';
import 'package:get/get.dart';
import 'package:flutter_app/globals/app_global.dart';
import 'package:flutter_app/globals/application.dart';
import 'package:flutter_app/generated/assets.dart';
import 'package:flutter_app/modules/ads/ads_manager.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';
import 'package:flutter_app/pp_kits/widgets/elastic_dialog.dart';

import '../settings/settings_main_page.dart';
import 'home_vip_alert.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final global = Get.find<AppGlobal>();
  final app = Get.find<XPApplication>();
  var _selectedIndex = 0;
  late PageController _pageController;

  final List<Widget> _pages = [
    const Tab1MainPage(),
    const Tab2MainPage(),
    const Tab3MainPage(),
    const SettingsMainPage()
  ];

  @override
  void initState() {
    super.initState();
    global.logEvent('home_p_enter');

    AdsManager.instance.fetchInterstitialAd();

    _pageController = PageController(initialPage: _selectedIndex);
    app.setIsFirstLaunch(false).then((_) {
      Logger.log('isFirstLaunch has been updated. value is false.');
    });

    if (!app.isSubscribed) {
      //只针对从未订阅过的用户
      Future.delayed(const Duration(seconds: 1), () {
        showVipAlert();
      });
    }
  }

  void showVipAlert() async {
    global.logEvent('home_vip_alert');
    Get.dialog(
      Align(
        alignment: Alignment.center,
        child: Transform.translate(
          offset: const Offset(0, -50), // 水平不变，垂直向上偏移 -50
          child: Dialog(
            elevation: 1,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: const ElasticDialog(
              child: HomeVipAlert(),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (value) {
          _selectedIndex = value;
          global.logEvent('switch_tabbar_$value');
          Logger.log('RootPage onPageChanged: $value');
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const ImageIcon(AssetImage(A.iconTabBarTrack)),
            label: 'tab_track'.localized,
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(AssetImage(A.iconTabBarPlaylist)),
            label: 'tab_playlist'.localized,
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(AssetImage(A.iconTabBarImport)),
            label: 'tab_import'.localized,
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(AssetImage(A.iconTabBarSetting)),
            label: 'tab_settings'.localized,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
