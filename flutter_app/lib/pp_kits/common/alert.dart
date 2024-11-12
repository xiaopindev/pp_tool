import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_app/pp_kits/extensions/extension_on_string.dart';

//（待开发）
class PPAlert {
  static var isLoading = false;
  static var isAlerted = false;
  // 显示加载中
  static void showLoading(
      {String? text, int? timeoutSeconds, Function? onTimeout}) {
    isLoading = true;
    EasyLoading.show(status: text ?? 'Loading...');

    // 设置超时
    if (timeoutSeconds != null) {
      Future.delayed(Duration(seconds: timeoutSeconds), () {
        if (isLoading) {
          hideLoading();
          if (onTimeout != null) {
            onTimeout();
          }
        }
      });
    }
  }

  // 隐藏加载
  static void hideLoading() {
    isLoading = false;
    EasyLoading.dismiss();
  }

  // 显示成功提示
  static void showSuccess(String message) {
    EasyLoading.showSuccess(message);
  }

  // 显示错误提示
  static void showError(String message) {
    EasyLoading.showError(message);
  }

  // 显示信息提示
  static void showInfo(String message) {
    EasyLoading.showInfo(message);
  }

  // 显示警告提示
  static void showWarning(String message) {
    EasyLoading.showToast(message,
        toastPosition: EasyLoadingToastPosition.center);
  }

  // 显示进度
  static void showProgress(double progress, {String? status}) {
    EasyLoading.showProgress(progress, status: status);
  }

  static void showSysAlert(String title, String text, {Function? onOK}) async {
    if (isAlerted) {
      return;
    }
    isAlerted = true;
    await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
          content: Text(
            text,
            style: const TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                isAlerted = false;
                if (onOK != null) {
                  onOK();
                }
              },
              child: Text('OK'.localized, style: const TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }

  static void showSysConfirm(String title, String text,
      {Function? onCancel, required Function onConfirm}) async {
    if (isAlerted) {
      return;
    }
    isAlerted = true;
    await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
          content: Text(
            text,
            style: const TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                isAlerted = false;
                Navigator.of(context).pop();
                if (onCancel != null) {
                  onCancel();
                }
              },
              child: Text(
                'Cancel'.localized,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                isAlerted = false;
                Navigator.of(context).pop();
                onConfirm();
              },
              child: Text(
                'OK'.localized,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }
}
