import 'package:flutter/material.dart';
import 'app/common/navigation/router.dart';
import 'app/common/pages/market_place/login/login_page.dart';
import 'app/theme/themes/theme_light.dart';

void main() async{
  runApp(MarketPlaceApp());
}

class MarketPlaceApp extends StatelessWidget {
  final GlobalRouter _router;

  MarketPlaceApp({Key? key})
      : _router = GlobalRouter(),
        super(key: key);

  //This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: const LoginPage(),
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _router.getRoute,
      navigatorObservers: [_router.routeObserver],
    );
  }
}
