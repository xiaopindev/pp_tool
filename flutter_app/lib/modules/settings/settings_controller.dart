import 'dart:async';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_app/configs/constants.dart';
import 'package:flutter_app/configs/events.dart';
import 'package:flutter_app/configs/routers.dart';
import 'package:flutter_app/datachannels/method_channel.dart';
import 'package:flutter_app/generated/assets.dart';
import 'package:flutter_app/modules/common/base/base_controller.dart';
import 'package:flutter_app/modules/database/db_helper.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../app_review/app_review_controller.dart';

class SettingsController extends BaseController {
  final appRevew = Get.find<AppReviewController>();

  final group1 = [
    (icon: A.iconSettingBackup, title: 'settings_backup'),
    (icon: A.iconSettingRestore, title: 'settings_restore'),
    (icon: A.iconSettingIndividuation, title: 'settings_individuation'),
    (icon: A.iconSettingFeedback, title: 'settings_feedback'),
    (icon: A.iconSettingLanguage, title: 'settings_language'),
    (icon: A.iconSettingAppReview, title: 'settings_appreview'),
    (icon: A.iconSettingShare, title: 'settings_share'),
  ];

  final group2 = [
    (icon: A.iconSettingPrivacy, title: 'settings_privacy'),
    (icon: A.iconSettingTermsOfUse, title: 'settings_eula'),
  ];

  var version = '1.0.0'.obs;

  @override
  void onInit() {
    Logger.trace('对象初始化');
    super.onInit();
  }

  @override
  void onReady() {
    Logger.trace('加载就绪');
    super.onReady();
    appRevew.useRecord('Settings');

    version.value = app.packageInfo?.version ?? '1.0.0';
  }

  @override
  void onClose() {
    Logger.trace('对象销毁');
    super.onClose();
  }

  void listItemTap(BuildContext context, String title) {
    switch (title) {
      case 'settings_backup':
        global.logEvent('sets_backup');
        backupData();
        break;
      case 'settings_restore':
        global.logEvent('sets_restore');
        restoreData();
        break;
      case 'settings_individuation':
        global.logEvent('sets_individuation');
        Get.toNamed(AppPages.individuation);
        break;
      case 'settings_feedback':
        global.logEvent('sets_feedback');
        Get.toNamed(AppPages.feedback);
        break;
      case 'settings_language':
        global.logEvent('sets_languages');
        Get.toNamed(AppPages.languages);
        break;
      case 'settings_appreview':
        global.logEvent('sets_comment');
        global.openAppReview();
        break;
      case 'settings_share':
        global.logEvent('sets_share');
        global.share(context, url: Consts.appStoreDownUrl);
        break;
      case 'settings_privacy':
        global.logEvent('sets_privacy');
        Get.toNamed(AppPages.web, arguments: {
          "title": 'Privacy_Text1'.localized,
          "url": Consts.urlPrivacy
        });
        break;
      case 'settings_eula':
        global.logEvent('sets_agreement');
        Get.toNamed(AppPages.web, arguments: {
          "title": 'Privacy_Text2'.localized,
          "url": Consts.urlEULA
        });
        break;
      default:
    }
  }

  static Future<Map<String, dynamic>> zipFiles(
      Map<String, String> params) async {
    final directoryPath = params['directoryPath']!;
    final tracksDir = Directory('$directoryPath/tracks');
    final musicDbFile = File('$directoryPath/music.db');

    final encoder = ZipEncoder();
    final archive = Archive();

    if (tracksDir.existsSync()) {
      tracksDir.listSync(recursive: true).forEach((file) {
        if (file is File) {
          final fileBytes = file.readAsBytesSync();
          final relativePath = file.path.replaceFirst(directoryPath, '');
          final archiveFile =
              ArchiveFile(relativePath, fileBytes.length, fileBytes);
          archive.addFile(archiveFile);
        }
      });
    }

    if (musicDbFile.existsSync()) {
      final fileBytes = musicDbFile.readAsBytesSync();
      final relativePath = musicDbFile.path.replaceFirst(directoryPath, '');
      final archiveFile =
          ArchiveFile(relativePath, fileBytes.length, fileBytes);
      archive.addFile(archiveFile);
    }

    final zipBytes = encoder.encode(archive);

    if (zipBytes == null) {
      return {'zipSizeMB': 0.0, 'zipFilePath': ''};
    }
    final String formattedDate = DateFormat('yyyyMMdd').format(DateTime.now());
    final String fileName =
        'htmusic_${formattedDate}_${Consts.dbVersion}.htbak';
    final zipFilePath = '$directoryPath/$fileName';
    final zipFile = File(zipFilePath);
    await zipFile.writeAsBytes(zipBytes);

    final int zipSize = zipBytes.length;
    final double zipSizeMB = zipSize / (1024 * 1024); // MB
    return {'zipSizeMB': zipSizeMB, 'zipFilePath': zipFilePath};
  }

  void backupData() async {
    if (!global.isVip.value) {
      global.showSubscriptionPage();
      return;
    }
    EasyLoading.show(status: 'backup_loading'.localized);
    Logger.log('开始备份');
    try {
      final directory = await getApplicationDocumentsDirectory();
      final zipInfo = await compute(
          SettingsController.zipFiles, {'directoryPath': directory.path});
      final zipSize = zipInfo['zipSizeMB'];
      final zipFilePath = zipInfo['zipFilePath'];

      EasyLoading.dismiss();
      Logger.log('完成压缩计算');
      // 提示用户需要的存储空间
      bool? userConfirmed = await showDialog<bool>(
        context: Get.context!,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'backup_tip_title'.localized,
            style: TextStyle(color: HexColor('555555')),
          ),
          content: Text(
            'backup_tip_text'
                .localizedWithArgs(args: ['${zipSize.toStringAsFixed(2)} MB']),
            style: TextStyle(color: HexColor('555555')),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                fixedSize: const Size.fromHeight(40),
              ),
              child: Text(
                'Cancel'.localized,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                fixedSize: const Size.fromHeight(40),
              ),
              child: Text(
                'OK'.localized,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

      if (userConfirmed != true) return;

      bool result = await MethodChannelHandler().exportFile(zipFilePath);
      if (result) {
        EasyLoading.showSuccess('Done'.localized);
      } else {
        EasyLoading.showError('Failed'.localized);
      }
    } catch (e) {
      Logger.log('备份过程中发生错误: $e');
      EasyLoading.dismiss();
    }
  }

  /// 恢复数据
  /// 一定要是相同数据结构的备份文件
  /// 如果新版本数据结构变化，考虑增加一个版本号_v1.htbak, _v2.htbak
  void restoreData() async {
    if (!global.isVip.value) {
      global.showSubscriptionPage();
      return;
    }

    // 提示还原风险
    bool? userConfirmed = await showDialog<bool>(
      context: Get.context!,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'restore_tip_title'.localized,
          style: const TextStyle(color: Colors.red),
        ),
        content: Text(
          'restore_tip_text'.localized,
          style: const TextStyle(color: Colors.red),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              fixedSize: const Size.fromHeight(40),
            ),
            child: Text(
              'Cancel'.localized,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              fixedSize: const Size.fromHeight(40),
            ),
            child: Text(
              'OK'.localized,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (userConfirmed != true) return;

    // 选择备份文件
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null || result.files.single.path == null) {
      Logger.log('没有选择恢复文件');
      return;
    }
    final filePath = result.files.single.path!;
    final directory = await getApplicationDocumentsDirectory();
    final zipFile = File(filePath);

    //判断如果后缀名不是_v1.htbak，拦截
    const endStr = '_${Consts.dbVersion}.htbak';
    if (!zipFile.path.endsWith(endStr)) {
      PPAlert.showSysAlert('Tips'.localized,
          'tip_restore_error'.localizedWithArgs(args: ['*$endStr']));
      return;
    }

    EasyLoading.show(status: 'restore_tip_loading'.localized);
    await DatabaseHelper().close();
    try {
      // 读取 zip 文件
      final bytes = zipFile.readAsBytesSync();
      final archive = ZipDecoder().decodeBytes(bytes);

      //删除Documents目录下的music.db文件和tracks目录
      File('${directory.path}/music.db').deleteSync();
      Directory('${directory.path}/tracks').deleteSync(recursive: true);

      // 解压到 Documents 目录
      for (final file in archive) {
        final relativePath =
            file.name.startsWith('/') ? file.name.substring(1) : file.name;
        final filename = '${directory.path}/$relativePath';
        Logger.log('解压文件目录:$filename');
        if (file.isFile) {
          final data = file.content as List<int>;
          File(filename)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          Directory(filename).create(recursive: true);
        }
      }
      //删除备份文件
      zipFile.deleteSync();

      await Future.delayed(const Duration(seconds: 2), () {
        EasyLoading.dismiss();
      });
      Logger.log('Restore completed');
      EasyLoading.showSuccess('Restore completed'.localized);
      await DatabaseHelper().initDatabase();
      eventBus.send(TrackChangedEvent('恢复数据'));
      eventBus.send(AlbumChangedEvent('恢复数据'));
      eventBus.send(PlaylistChangedEvent('恢复数据'));
    } catch (e) {
      Logger.log('解压过程中发生错误: $e');
      EasyLoading.showError('Restore failed'.localized);
    }
  }
}
