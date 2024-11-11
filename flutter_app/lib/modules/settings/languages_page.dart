import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:get/get.dart';
import 'package:flutter_app/globals/app_global.dart';
import 'package:flutter_app/globals/application.dart';
import 'package:flutter_app/globals/iap_purchase.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';

class LanguagesPage extends StatefulWidget {
  const LanguagesPage({super.key});

  @override
  State<LanguagesPage> createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage> {
  var _currentCode = 'sys';

  final _languages = [
    (code: "sys", name: "Follow_System", remark: "跟随系统", checked: true),
    (code: "en", name: "English", remark: "英语", checked: false),
    (code: "de", name: "Deutsch", remark: "德语", checked: false),
    (code: "fr", name: "français", remark: "法语", checked: false),
    (code: "es", name: "español", remark: "西班牙语", checked: false),
    (code: "pt", name: "português", remark: "葡萄牙语", checked: false),
    (code: "it", name: "italiano", remark: "意大利语", checked: false),
    (code: "ar", name: "العربية", remark: "阿拉伯语", checked: false),
    (code: "ja", name: "日本語", remark: "日语", checked: false),
    (code: "ko", name: "한국어", remark: "韩语", checked: false),
    (code: "id", name: "Indonesia", remark: "印度尼西亚语", checked: false),
    (code: "vi", name: "Tiếng Việt", remark: "越南语", checked: false),
    (code: "fil", name: "Filipino", remark: "菲律宾语", checked: false),
    (code: "th", name: "ไทย", remark: "泰语", checked: false),
    (code: "zh-Hant", name: "繁體中文", remark: "中文", checked: false),
  ];

  void switchTo(Locale locale) async {
    Logger.log('switchTo语言: $locale');
    await S.load(locale);
    await Get.updateLocale(locale);

    final iap = Get.find<IapPurchaseController>();
    iap.requestProducts();
  }

  @override
  Widget build(BuildContext context) {
    _currentCode = Get.find<XPApplication>().languageCode;
    Logger.log('_currentCode: $_currentCode');

    return Scaffold(
      appBar: AppBar(
        title: Text("settings_language".localized),
      ),
      body: ListView(
        children: [
          Column(
            children: List.generate(_languages.length * 2 - 1, (index) {
              if (index % 2 == 1) {
                return const Divider(height: 0.5);
              } else {
                var record = _languages[index ~/ 2];
                bool isSelected = _currentCode == record.code;
                Logger.log(
                    '_currentCode: $_currentCode record.code: ${record.code}');
                return ListTile(
                  leading: Icon(isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off),
                  title: Text(
                    record.code == 'sys' ? record.name.localized : record.name,
                  ),
                  onTap: () async {
                    if (!isSelected) {
                      Logger.log('切换语言: ${record.code}');
                      Get.find<XPApplication>().setLanguageCode(record.code);
                      final savedLocale =
                          await Get.find<AppGlobal>().savedLocale();
                      switchTo(savedLocale);
                    }
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
