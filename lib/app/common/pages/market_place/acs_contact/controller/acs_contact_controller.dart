import 'package:acscallingchatflutter/app/common/pages/base/controller/base_controller.dart';
import 'package:acscallingchatflutter/domain/entities/product_dao.dart';

class ACSContactController extends BaseController {
  List<ProductDao> similarApps = [];
  List<String> keyPoints = [];


  ACSContactController(super.repo) {

  }

}
