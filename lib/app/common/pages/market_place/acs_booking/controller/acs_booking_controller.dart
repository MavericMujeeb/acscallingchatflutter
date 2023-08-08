import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:acscallingchatflutter/app/common/pages/base/controller/base_controller.dart';
import 'package:acscallingchatflutter/app/common/utils/constants.dart';
import 'package:acscallingchatflutter/data/helpers/shared_preferences.dart';
import 'package:acscallingchatflutter/domain/entities/product_dao.dart';

import 'package:http/http.dart' as http;

class ACSBookingController extends BaseController {
  List<ProductDao> similarApps = [];
  List<String> keyPoints = [];

  var resp;
  var respGetBanker;
  var respDelegateToken;
  var respBooking;
  var acsToken;
  var acsDelegateToken;
  var serviceId = '';

  int selectedDayIndex = 0;
  var selectedBankerEmailId = '';
  var selectedBankerName = '';
  var selectedBankerId = '';

  bool inProgress = false;
  bool inProgressFullScreen = false;

  var pickedStartTime = '';
  var pickedEndTime = '';

  var defaultDate = '';
  var strCode = '';

  ACSBookingController(super.repo) {}

  Future getBankersList() async {
    inProgress = true;

    acsToken = Constants.ACS_TOKEN;

    respGetBanker = await getBankersListAPI();
    // var responseGetBanker = await getBankersListAPI();
    // if (responseGetBanker['value'] != null &&
    //     responseGetBanker['value'].length > 0) {
    //   respGetBanker = responseGetBanker['value']
    //       .where((item) =>
    //   item['displayName'] == Constants.bankerUserName || item['displayName'] == 'Stella Silva')
    //       .toList();
    // } else {
    //   respGetBanker = responseGetBanker;
    // }
    inProgress = false;

    // DateTime today = new DateTime.now();
    // String formattedDate = DateFormat('yyyy-MM-dd').format(today);
    // getAwailableSlots(today.weekday - 1, formattedDate);

    return true;
  }

  Future getAwailableSlots(int dayOfWeek, String date) async {
    inProgress = true;

    acsToken = await AppSharedPreference()
        .getString(key: SharedPrefKey.prefs_acs_token);
    serviceId = Constants.service_email_id;

    resp = await getAwailableSlotsAPI(date);

    inProgress = false;
    // refreshUI();

    return resp;
  }

  Future getBankersListAPI() async {
    serviceId = Constants.service_email_id;
    var url = Uri.parse(
        'https://graph.microsoft.com/v1.0/solutions/bookingBusinesses/$serviceId/staffMembers/');
    final response =
        await http.get(url, headers: {"Authorization": "Bearer " + acsToken});

    var convertDataToJson = jsonDecode(response.body);
    return convertDataToJson;
  }

  Future getAwailableSlotsAPI(String date) async {
    acsToken = await AppSharedPreference()
        .getString(key: SharedPrefKey.prefs_acs_token);

    var startScheduleTimeFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date + "T08:00:00", true);
    var endScheduleTimeFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date + "T17:00:00", true);
    var utcStartTime = DateTime(startScheduleTimeFormat.year, startScheduleTimeFormat.month, startScheduleTimeFormat.day, startScheduleTimeFormat.hour, startScheduleTimeFormat.minute, startScheduleTimeFormat.second);
    var utcEndTime = DateTime(endScheduleTimeFormat.year, endScheduleTimeFormat.month, endScheduleTimeFormat.day, endScheduleTimeFormat.hour, endScheduleTimeFormat.minute, endScheduleTimeFormat.second);

    // print("startScheduleTime-> "+startScheduleTimeFormat.toUtc().toString());
    // print("startScheduleTime-> "+endScheduleTimeFormat.toUtc().toString());
    // print("startScheduleTime-> "+utcStartTime.toUtc().toString().replaceAll(' ', "T").replaceAll('.000Z', ""));
    // print("startScheduleTime-> "+utcEndTime.toUtc().toString().replaceAll(' ', "T").replaceAll('.000Z', ""));
    // print("startScheduleTime-> "+utcStartTime.timeZoneName);
    final body = {
      "schedules": ["$selectedBankerEmailId"],
      "startTime": {
        "dateTime": utcStartTime.toUtc().toString().replaceAll(' ', "T").replaceAll('.000Z', ""),
        "timeZone": "UTC"
      },
      "endTime": {
        "dateTime": utcEndTime.toUtc().toString().replaceAll(' ', "T").replaceAll('.000Z', ""),
        "timeZone": "UTC"
      },
      "availabilityViewInterval": 30
    };

    final requestString = json.encode(body);

    var emailId = Constants.get_schedule_user_service_email_id;
    var url = Uri.parse(
        'https://graph.microsoft.com/v1.0/users/$emailId/calendar/getSchedule');
    final response = await http.post(url,
        headers: {
          "Authorization": "Bearer " + acsToken,
          "Content-Type": "application/json"
        },
        body: requestString);

    var convertDataToJson = jsonDecode(response.body);
    return convertDataToJson;
  }

  List<String> getTimeSlotsToDisplay(String startTime, String endTime) {
    List<String> startWorkinghoursSplitList = startTime.split(":");
    List<String> endWorkinghoursSplitList = endTime.split(":");
    var startTimeFromList = startWorkinghoursSplitList.isNotEmpty
        ? startWorkinghoursSplitList.elementAt(0)
        : "8";
    var endTimeFromList = endWorkinghoursSplitList.isNotEmpty
        ? endWorkinghoursSplitList.elementAt(0)
        : "17";
    List<String> availableTimeSlotsList = [];
    for (var i = int.parse(startTimeFromList);
        i < int.parse(endTimeFromList);
        i++) {
      availableTimeSlotsList.add("$i:00 - $i:30");
      availableTimeSlotsList.add("$i:30 - ${i + 1}:00");
    }
    return availableTimeSlotsList;
  }

  Future getBookingDelegateToken() async {
    inProgressFullScreen = true;

    respDelegateToken = await getBookingDelegateTokenAPI();

    acsDelegateToken = respDelegateToken['access_token'];

    // inProgressFullScreen = false;

    // actionBookAppointment(acsDelegateToken);
    respBooking = await bookAppointAPI(acsDelegateToken);

    inProgressFullScreen = false;

    return true;
  }

  Future getBookingDelegateTokenAPI() async {
    var tenantId = Constants.tenant_id;
    var url = Uri.parse(
        'https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token');

    final response = await http.post(
      url,
      body: {
        'client_id': Constants.client_id,
        'scope': 'https://graph.microsoft.com/.default',
        'client_secret':Constants.client_secret,
        'grant_type':'client_credentials'
      },
    );

    var convertDataToJson = jsonDecode(response.body);
    return convertDataToJson;
  }

  Future actionBookAppointment(String acsTokenNew) async{
    inProgressFullScreen = true;

    respBooking = await bookAppointAPI(acsTokenNew);

    inProgressFullScreen = false;

    /*if(respBooking == "Error there : 403") {
      return false;
      inProgressFullScreen = false;
    } else {
      return true;
    }*/

    return true;
  }

  Future bookAppointAPI(String acsTokenNew) async {

    var startTimeFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(defaultDate+"T"+pickedStartTime+":00", true);
    var endTimeFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(defaultDate+"T"+pickedEndTime+":00", true);
    var utcStartTime = DateTime(startTimeFormat.year, startTimeFormat.month, startTimeFormat.day, startTimeFormat.hour, startTimeFormat.minute, startTimeFormat.second);
    var utcEndTime = DateTime(endTimeFormat.year, endTimeFormat.month, endTimeFormat.day, endTimeFormat.hour, endTimeFormat.minute, endTimeFormat.second);

    final body = {
      "@odata.type": "#microsoft.graph.bookingAppointment",
      "customerTimeZone": "America/Chicago",
      "smsNotificationsEnabled": false,
      "startDateTime": {
        "@odata.type": "#microsoft.graph.dateTimeTimeZone",
        "dateTime": utcStartTime.toUtc().toString().replaceAll(' ', "T").replaceAll('.000Z', "")+".0000000+00:00",
        "timeZone": "UTC"
      },
      "endDateTime": {
        "@odata.type": "#microsoft.graph.dateTimeTimeZone",
        "dateTime": utcEndTime.toUtc().toString().replaceAll(' ', "T").replaceAll('.000Z', "")+".0000000+00:00",
        "timeZone": "UTC"
      },
      "isLocationOnline": true,
      "optOutOfCustomerEmail": false,
      "anonymousJoinWebUrl": null,
      "staffMemberIds":["$selectedBankerId"],
      "postBuffer": "PT0S",
      "preBuffer": "PT0S",
      "price": 0,
      "priceType@odata.type": "#microsoft.graph.bookingPriceType",
      "priceType": "undefined",
      "reminders@odata.type": "#Collection(microsoft.graph.bookingReminder)",
      "reminders": [
        {
          "@odata.type": "#microsoft.graph.bookingReminder",
          "message": "This service is Today",
          "offset": "P1D",
          "recipients@odata.type": "#microsoft.graph.bookingReminderRecipients",
          "recipients": "allAttendees"
        },
        {
          "@odata.type": "#microsoft.graph.bookingReminder",
          "message": "Please be available to enjoy your lunch service.",
          "offset": "PT1H",
          "recipients@odata.type": "#microsoft.graph.bookingReminderRecipients",
          "recipients": "customer"
        },
        {
          "@odata.type": "#microsoft.graph.bookingReminder",
          "message": "Please check traffic for next cater.",
          "offset": "PT2H",
          "recipients@odata.type": "#microsoft.graph.bookingReminderRecipients",
          "recipients": "staff"
        }
      ],
      "serviceId": Constants.booking_service_id,
      "serviceLocation": {
        "@odata.type": "#microsoft.graph.location",
        "address": {
          "@odata.type": "#microsoft.graph.physicalAddress",
          "city": "",
          "countryOrRegion": "",
          "postalCode": "",
          "postOfficeBox": null,
          "state": "",
          "street": "",
          "type@odata.type": "#microsoft.graph.physicalAddressType",
          "type": null
        },
        "coordinates": null,
        "displayName": "",
        "locationEmailAddress": null,
        "locationType@odata.type": "#microsoft.graph.locationType",
        "locationType": null,
        "locationUri": null,
        "uniqueId": null,
        "uniqueIdType@odata.type": "#microsoft.graph.locationUniqueIdType",
        "uniqueIdType": null
      },
      "serviceName": Constants.booking_service_name,
      "serviceNotes": "Customer requires punctual service.",
      "maximumAttendeesCount": 1,
      "filledAttendeesCount": 1,
      "customers@odata.type": "#Collection(microsoft.graph.bookingCustomerInformation)",
      "customers": [
        {
          "@odata.type": "#microsoft.graph.bookingCustomerInformation",
          "customerId": Constants.userId,
          "name": Constants.userName,
          "emailAddress": Constants.userEmail,
          "phone": "469-524-9869",
          "notes": null,
          "location": {
            "@odata.type": "#microsoft.graph.location",
            "displayName": "Customer",
            "locationEmailAddress": null,
            "locationUri": "",
            "locationType": null,
            "uniqueId": null,
            "uniqueIdType": null,
            "address": {
              "@odata.type": "#microsoft.graph.physicalAddress",
              "street": "",
              "city": "",
              "state": "",
              "countryOrRegion": "",
              "postalCode": ""
            },
            "coordinates": {
              "altitude": null,
              "latitude": null,
              "longitude": null,
              "accuracy": null,
              "altitudeAccuracy": null
            }
          },
          "timeZone":"America/Chicago",
          "customQuestionAnswers": [
            {
              "questionId": "3bc6fde0-4ad3-445d-ab17-0fc15dba0774",
              "question": "API create appointment?",
              "answerInputType": "text",
              "answerOptions": [],
              "isRequired": true,
              "answer": "25",
              "selectedOptions": []
            }
          ]
        }
      ]
    };

    final requestString = json.encode(body);

    var serviceID = await AppSharedPreference().getString(key: SharedPrefKey.prefs_service_id);

    // var url = Uri.parse('https://graph.microsoft.com/v1.0/solutions/bookingBusinesses/$serviceId/staffMembers/');
    var url = Uri.parse('https://graph.microsoft.com/v1.0/solutions/bookingBusinesses/$serviceID/appointments');

    final response =
    await http.post(url, headers: {"Authorization": "Bearer " + acsTokenNew, "Content-Type": "application/json"}, body: requestString);

    if(response.statusCode.toString() == "201") {
      var convertDataToJson = jsonDecode(response.body);
      return convertDataToJson;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      var convertErrorMessageData = jsonDecode(convertDataToJson['error']['message']);
      // return "Error there : "+response.statusCode.toString();
      return "Error: "+convertErrorMessageData['error']['message'];
      //return "${"Error "+convertDataToJson['error']['code']}, "+convertErrorMessageData['error']['message'];
    }

    // var convertDataToJson = jsonDecode(response.body);
    // return convertDataToJson;
  }
}
