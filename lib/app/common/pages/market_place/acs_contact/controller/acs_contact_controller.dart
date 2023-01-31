import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:acscallingchatflutter/app/common/pages/base/controller/base_controller.dart';
import 'package:acscallingchatflutter/app/common/utils/constants.dart';
import 'package:acscallingchatflutter/data/helpers/shared_preferences.dart';
import 'package:acscallingchatflutter/domain/entities/product_dao.dart';

class ACSContactController extends BaseController {
  List<ProductDao> similarApps = [];
  List<String> keyPoints = [];


  ACSContactController(super.repo) {

  }

}
