import 'package:acscallingchatflutter/app/common/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  void showToast(BuildContext context, String strMsg, bool status) async {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 315),
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
              child: Text(
                strMsg.toString(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
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