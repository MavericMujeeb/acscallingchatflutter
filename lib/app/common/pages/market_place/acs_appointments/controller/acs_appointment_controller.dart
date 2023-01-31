import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:acscallingchatflutter/app/common/pages/base/controller/base_controller.dart';
import 'package:acscallingchatflutter/app/common/utils/constants.dart';
import 'package:acscallingchatflutter/data/helpers/shared_preferences.dart';
import 'package:acscallingchatflutter/domain/entities/product_dao.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ACSAppointmentController extends BaseController {

  var resp;
  var respGetBanker;

  var acsToken = '';
  var serviceId = '';

  bool inProgress = false;

  ACSAppointmentController(super.repo) {
  }

  Future getToken() async {

    inProgress = true;
    serviceId = Constants.service_email_id;
    var url = Uri.parse(
        'https://login.microsoftonline.com/4c4985fe-ce8e-4c2f-97e6-b037850b777d/oauth2/v2.0/token');
    final response = await http.post(url, body: {
      'client_id': 'e6197263-b986-4f08-9a27-08a4ec1b5c8e',
      'scope': 'https://graph.microsoft.com/.default',
      'client_secret': '4k48Q~wbivlxdFIbyVcNg3ykunlNdI.vcyC2Kbi0',
      'grant_type': 'client_credentials'
    });

    var respToken = jsonDecode(response.body);

    acsToken = respToken['access_token'];

    // acsToken = AppSharedPreference().getString(key: SharedPrefKey.prefs_acs_token);
    AppSharedPreference()
        .addString(key: SharedPrefKey.prefs_acs_token, value: acsToken);

    // acsToken = await AppSharedPreference().getString(key: SharedPrefKey.prefs_acs_token);

    /*respGetBanker = await getBankersListAPI();
    print("Response on getBankersList API is : "+respGetBanker.toString());*/

    respGetBanker = await getBankersListAPI();

    print("Response on getBankersList API is : "+respGetBanker.toString());

    var removedCancelledMeetingList = await getAppointmentsAPI();

   resp = removedCancelledMeetingList['value'].where((item) => item['isCancelled'] == false ).toList();

    print("Respose on getAppointments is : "+resp.toString());

    print("Respose on getAppointments is filter : "+resp.length.toString());

    inProgress = false;

    return true;
  }

  Future getBankersListAPI() async {
    serviceId = await AppSharedPreference()
        .getString(key: SharedPrefKey.prefs_service_id);
    var url = Uri.parse(
        'https://graph.microsoft.com/v1.0/solutions/bookingBusinesses/$serviceId/staffMembers/');
    final response =
    await http.get(url, headers: {"Authorization": "Bearer " + acsToken});

    var convertDataToJson = jsonDecode(response.body);
    return convertDataToJson;
  }

  Future getAppointmentsAPI() async {
    var nowDate = DateTime.now();
    var thirtydaysDate = DateTime(nowDate.year, nowDate.month, nowDate.day + 30);
    var format = DateFormat('yyyy-MM-dd');
    var timeformat = DateFormat('HH:mm');
    String currentDate = format.format(nowDate);
    String oneMonthDate = format.format(thirtydaysDate);
    String currentTime = timeformat.format(nowDate);
    String finalstartDate = "${currentDate}T$currentTime:00-08:00";
    String finalendDate = "${oneMonthDate}T23:58:00-08:00";
    // print(currentDate);
    // print(oneMonthDate);
    // print(currentTime);
    // print(finalstartDate);
    // print(finalendDate);
    var url = Uri.parse(
        'https://graph.microsoft.com/v1.0/users/chantalkendall@27r4l5.onmicrosoft.com/calendar/calendarView?startDateTime=$finalstartDate&endDateTime=$finalendDate');
    // 'https://graph.microsoft.com/v1.0/users/GatesFamilyOffice@27r4l5.onmicrosoft.com/calendar/calendarView?startDateTime=2023-01-17T00:00:00-08:00&endDateTime=2023-01-19T19:00:00-08:00');
    // 'https://graph.microsoft.com/v1.0/users/kishan@27r4l5.onmicrosoft.com/calendar/calendarView?startDateTime=2023-01-22T13:45:00-08:00&endDateTime=2023-02-24T00:00:00-08:00');
    print("URL->"+url.toString());
    final response =
    await http.get(url, headers: {"Authorization": "Bearer " + acsToken});

    var convertDataToJson = jsonDecode(response.body);
    return convertDataToJson;
  }

}
