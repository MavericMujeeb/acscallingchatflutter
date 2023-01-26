import 'package:acscallingchatflutter/app/common/navigation/pages.dart';
import 'package:flutter/material.dart';

void navigateToLoginScreen(context) {
  Navigator.of(context)
      .pushNamedAndRemoveUntil(Pages.screen_login, (route) => false);
}

void navigateToNavigatorScreen(context) {
  Navigator.of(context)
      .pushNamedAndRemoveUntil(Pages.screen_navigator, (route) => false);
}

void navigateToProductDetailScreen(context) {
  Navigator.of(context)
      .pushNamed(Pages.screen_product_detail);
}

void navigateToContactCernterScreen(context) {
  Navigator.of(context).pushNamed(Pages.screen_contact_center);
}

void navigateToBookingScreen(context) {
  Navigator.of(context).pushNamed(Pages.screen_booking);
}

void navigateToProductIntegrationProcessScreen(context, String strAppName) {
  Navigator.of(context)
      .pushNamed(Pages.screen_product_integration_process, arguments: {"appName": strAppName});
}

void navigateToDashboardScreen(context, selectedIndex) {
  Navigator.of(context)
      .pushNamed(Pages.screen_home);
}

void popScreen(context) {
  Navigator.of(context).pop();
}

void popScreenWithResult(context, value) {
  Navigator.of(context).pop(value);
}
