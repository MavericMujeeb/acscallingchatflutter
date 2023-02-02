import 'package:acscallingchatflutter/app/common/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  void showToast(BuildContext context, String strMsg, bool status) async {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 350),
      duration: const Duration(seconds: 30),
      dismissDirection: DismissDirection.startToEnd,
      content: Container(
        // margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 75),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: status ? AppColor.green_toast : AppColor.red_toast),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Container(
                width: MediaQuery.of(context).size.width - 120,
                child: Text(
                  strMsg.toString(),
                  style: TextStyle(fontSize: 13),
                  softWrap: true,
                  maxLines: 5,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 1000,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}