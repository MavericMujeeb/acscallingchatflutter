import 'package:acscallingchatflutter/app/common/utils/constants.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  static Flushbar? snackBar;

  void showToast(BuildContext context, String strMsg, bool status) async {
    if (snackBar != null) {
      return;
    }
    snackBar = Flushbar<bool>(
      message: strMsg,
      duration: const Duration(seconds: 4),
      backgroundColor: status ? AppColor.green_toast : AppColor.red_toast,
      margin: const EdgeInsets.fromLTRB(16, 70, 16, 0),
      borderRadius: BorderRadius.circular(10),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.decelerate,
      isDismissible: false,
      onStatusChanged: (status) => callBackStatusHandler(status),
      mainButton: MaterialButton(
        onPressed: () {
          snackBar!.dismiss(true); // result = true
        },
        child: const Icon(
          Icons.close,
          size: 25,
          color: Colors.white,
        ),
      ),
    ) // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
      ..show(context).then((result) {});
  }

  void callBackStatusHandler(FlushbarStatus? status) {
    switch (status!) {
      case FlushbarStatus.SHOWING:
        {
          break;
        }
      case FlushbarStatus.IS_APPEARING:
        {
          break;
        }
      case FlushbarStatus.IS_HIDING:
        {
          break;
        }
      case FlushbarStatus.DISMISSED:
        {
          snackBar = null;
          break;
        }
    }
  }
}