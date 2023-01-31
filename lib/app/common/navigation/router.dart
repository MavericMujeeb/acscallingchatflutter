import 'package:flutter/material.dart';
import 'package:acscallingchatflutter/app/common/navigation/pages.dart';
import 'package:acscallingchatflutter/app/common/pages/market_place/acs_booking/view/acs_booking_page.dart';
import 'package:acscallingchatflutter/app/common/pages/market_place/acs_chat_calling/view/acs_chat_calling_page.dart';

class GlobalRouter {
  final RouteObserver<PageRoute> routeObserver;

  GlobalRouter() : routeObserver = RouteObserver<PageRoute>();

  Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      /*case Pages.screen_product_detail:
        return _buildRoute(settings, const ProductDetailsPage());*/
      /*case Pages.screen_product_integration_process:
        return _buildRoute(settings, const ProductIntegrationPage(null));
      case Pages.screen_market_place:
        return _buildRoute(settings, DashboardPage(title: '', selectedTabIndex: 0,));*/
      case Pages.screen_contact_center:
        return _buildRoute(settings, const ACSChatCallingPage());
      case Pages.screen_booking:
        return _buildRoute(settings, const ACSBookingPage());
      default:
        return _buildRoute(settings, const ACSChatCallingPage());
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (ctx) => builder,
    );
  }
}
