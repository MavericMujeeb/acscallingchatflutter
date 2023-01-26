import 'package:acscallingchatflutter/app/common/navigation/navigation.dart';
import 'package:acscallingchatflutter/app/common/pages/base/controller/base_controller.dart';

class LoginController extends BaseController{

  bool isPassVisible = true;

  LoginController(super.repo) {}

  updateVisibility() {
    if(isPassVisible) {
      isPassVisible = false;
    } else {
      isPassVisible = true;
    }
    refreshUI();
  }

}