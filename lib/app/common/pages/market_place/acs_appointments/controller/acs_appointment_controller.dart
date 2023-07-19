import 'dart:convert';
import 'package:acscallingchatflutter/app/common/pages/base/controller/base_controller.dart';
import 'package:acscallingchatflutter/app/common/utils/constants.dart';
import 'package:acscallingchatflutter/data/helpers/shared_preferences.dart';
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
    var tenantId = Constants.tenant_id;
    var url = Uri.parse(
        'https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token');
    final response = await http.post(url, body: {
      'client_id': Constants.client_id,
      'scope': 'https://graph.microsoft.com/.default',
      'client_secret': Constants.client_secret,
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

    //Removing cancelled meeting from appointment list
    if (removedCancelledMeetingList['value'] != null &&
        removedCancelledMeetingList['value'].length > 0) {
      resp = removedCancelledMeetingList['value']
          .where((item) =>
              item['isCancelled'] == false &&
              DateFormat("yyyy-MM-dd'T'HH:mm:ss.0000000")
                      .parse(item['end']['dateTime'], true)
                      .toLocal()
                      .millisecondsSinceEpoch >
                  DateTime.now().millisecondsSinceEpoch)
          .toList();
    }
    //var removedCancelledMeetingList = await getAppointmentsAPI();

   // resp = removedCancelledMeetingList['value'].where((item) => item['isCancelled'] == false ).toList();

    //print("Respose on getAppointments is filter : "+removedCancelledMeetingList.toString());

    inProgress = false;

    return true;
  }

  Future getBankersListAPI() async {
    serviceId =Constants.service_email_id;
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
    String finalstartDate = "${currentDate}T00:00:00-08:00";
    String finalendDate = "${oneMonthDate}T23:58:00-08:00";
    // print(currentDate);
    // print(oneMonthDate);
    // print(currentTime);
    // print(finalstartDate);
    // print(finalendDate);
    var emailId = Constants.booking_list_user_service_email_id;
    var url = Uri.parse(
        'https://graph.microsoft.com/v1.0/users/$emailId/calendar/calendarView?\$top=100&startDateTime=$finalstartDate&endDateTime=$finalendDate');
    // 'https://graph.microsoft.com/v1.0/users/GatesFamilyOffice@27r4l5.onmicrosoft.com/calendar/calendarView?startDateTime=2023-01-17T00:00:00-08:00&endDateTime=2023-01-19T19:00:00-08:00');
    // 'https://graph.microsoft.com/v1.0/users/kishan@27r4l5.onmicrosoft.com/calendar/calendarView?startDateTime=2023-01-22T13:45:00-08:00&endDateTime=2023-02-24T00:00:00-08:00');
    print("URL->"+url.toString());
    final response =
    await http.get(url, headers: {"Authorization": "Bearer " + acsToken});

    var convertDataToJson = jsonDecode(response.body);
    return convertDataToJson;
  }

}
