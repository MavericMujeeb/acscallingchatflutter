import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'package:acscallingchatflutter/app/common/pages/market_place/acs_appointments/view/acs_appointment_page.dart';
import 'package:acscallingchatflutter/app/common/pages/market_place/acs_contact/view/acs_contact_page.dart';
import 'package:acscallingchatflutter/app/widgets/custom_text.dart';
import 'package:acscallingchatflutter/data/helpers/shared_preferences.dart';
import 'package:acscallingchatflutter/data/repositories/acs_chat_calling_repositories.dart';

import '../../../../../utils/constants.dart';
import '../../controller/acs_chat_calling_controller.dart';

import 'package:http/http.dart' as http;

class ACSChatCallingPhonePage extends View {
  const ACSChatCallingPhonePage({Key? key}) : super(key: key);

  @override
  ACSChatCallingPhonePageState createState() => ACSChatCallingPhonePageState();
}

class ACSChatCallingPhonePageState
    extends ViewState<ACSChatCallingPhonePage, ACSChatCallingController> with SingleTickerProviderStateMixin{
  ACSChatCallingPhonePageState()
      : super(ACSChatCallingController(ACSChatCallingDataRepository()));

  ACSChatCallingController? productDetailsController;

  int selectedTabIndex = 0;

  // static const Color bg_color = Color(0xFFF6F7F7);
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    setServiceId();
    getToken();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget get view => Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 70,
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //     onPressed: () => popScreen(context),
          //     icon: const Icon(Icons.chevron_left)),
          title: appBarTitle,
        ),
        key: globalKey,
        body: SafeArea(
          child: ControlledWidgetBuilder<ACSChatCallingController>(
            builder: (context, controller) {
              productDetailsController = controller;
              return const ACSAppointmentPage();
              return DefaultTabController(
                initialIndex: 1,
                length: 2,
                child: FutureBuilder(
                  future: loadTabs(),
                  builder: (buildContext, snapShot) {
                    return snapShot.hasData
                        ? Scaffold(
                      appBar: AppBar(
                        elevation: 0,
                        toolbarHeight: 0,
                        backgroundColor: AppColor.bg_color_contact,
                        bottom: TabBar(
                          onTap: (index) {
                                    selectedTabIndex = index;
                                  },
                          controller: _tabController,
                          // onTap: (int index) => onTap(index),
                          labelColor: AppColor.black_color,
                          isScrollable: false,
                          unselectedLabelColor:
                          AppColor.black_color_54,
                          indicatorColor: AppColor.black_color,
                          indicatorPadding:
                          const EdgeInsets.symmetric(
                              horizontal: 18),
                          tabs: [
                            Tab(
                              child: CustomText(
                                textName: Constants.tabContact,
                                textAlign: TextAlign.center,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Tab(
                              child: CustomText(
                                textName: Constants.tabAppointment,
                                textAlign: TextAlign.center,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      body: TabBarView(
                        // controller: tabController,
                        controller: _tabController,
                        children: [
                          ACSContactPage(),
                          ACSAppointmentPage(),
                        ],
                      ),
                    )
                        : const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              );
            },
          ),
        ),
      );

  Widget get appBarTitle => Column(
    children: [
      CustomText(
        textName: Constants.contactCenter,
        textAlign: TextAlign.center,
        fontSize: 15,
        fontWeight: FontWeight.bold,
        textColor: Colors.black,
      ),
      vSpacer(10),
      CustomText(
        textName: Constants.contactCenterToolbarMsg,
        textAlign: TextAlign.center,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        textColor: AppColor.black_color_54,
      ),
    ],
  );

  Widget vSpacer(double height) => SizedBox(
        height: height,
      );

  Widget hSpacer(double width) => SizedBox(
        width: width,
      );

  loadTabs() async {
    return Future.delayed(const Duration(milliseconds: 100), () {
      return true;
    });
  }

  Future getTokenAPI() async{
    var tenantId = Constants.tenant_id;
    var url = Uri.parse('https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token');
    final response = await http.post(
      url, body: {'client_id': Constants.client_id, 'scope': 'https://graph.microsoft.com/.default', 'client_secret':Constants.client_secret, 'grant_type':'client_credentials'}
    );

    var convertDataToJson = jsonDecode(response.body);
    return convertDataToJson;
  }

  void getToken() async{
    var resp = await getTokenAPI();
    AppSharedPreference().addString(key:SharedPrefKey.prefs_acs_token, value: resp['access_token']);
  }

  void setServiceId() async{
    AppSharedPreference().addString(key:SharedPrefKey.prefs_service_id, value: Constants.service_email_id);
  }

  void onTap(int index) {
    setState(() {
      _tabController.index = index == 0 ? _tabController.previousIndex : index;
    });
  }
}
