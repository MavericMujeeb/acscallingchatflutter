import 'package:acscallingchatflutter/app/common/utils/constants.dart';
import 'package:flutter/services.dart';


class SharedPreferences {

  static const channel = MethodChannel(Constants.Method_Channel_Name);

  static addString({key:String, value:String}) async {
    await channel.invokeMethod("setString", {"key":key, "value":value});
  }

  static getString({key:String}) async {
    var value = await channel.invokeMethod("getString", {"key":key});
    return value;
  }
}