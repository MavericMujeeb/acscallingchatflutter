import 'package:acscallingchatflutter/app/common/navigation/navigation.dart';
import 'package:acscallingchatflutter/app/common/utils/custom_snackbar.dart';
import 'package:acscallingchatflutter/app/widgets/custom_text.dart';
import 'package:acscallingchatflutter/data/repositories/acs_chat_calling_repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/constants.dart';
import '../../../../../utils/utility.dart';
import '../../controller/acs_booking_controller.dart';

class ACSBookingPhonePage extends View {
  const ACSBookingPhonePage({Key? key}) : super(key: key);

  @override
  ACSBookingPhonePageState createState() => ACSBookingPhonePageState();
}

class ACSBookingPhonePageState // extends ViewState<ACSBookingPhonePage, ACSBookingController> {
    extends State<ACSBookingPhonePage> {
  // ACSBookingPhonePageState(): super(ACSBookingController(ACSChatCallingDataRepository()));
  // ACSBookingPhonePageState();

  ACSBookingController? acsBookingController =
      ACSBookingController(ACSChatCallingDataRepository());

  static const Channel = MethodChannel(Constants.Method_Channel_Name);

  DateTime setDate = DateTime.now();

  int selectedTabIndex = 0;

  static const spacing_4 = 4.0;
  static const spacing_6 = 6.0;
  static const spacing_8 = 8.0;
  static const spacing_10 = 10.0;
  static const spacing_12 = 12.0;
  static const spacing_14 = 14.0;
  static const spacing_16 = 16.0;
  static const spacing_18 = 18.0;

  final List<bool> _selected = List.generate(100, (i) => false);

  // late final List<bool> _selected;
  late final List<bool> _selectedBanker;

  // var resp;
  // var respBooking;
  var getScheduleResponse;
  var availableTimeSlots;
  var ascToken = '';
  var serviceId = '';
  DateTime today = new DateTime.now();

  int selectedDayIndex = 0;

  List<String> timeslots = [];
  var splitTime;
  var strCodeResaponseURL = '';
  var strGetCodeUrl =
      'https://login.microsoftonline.com/${Constants.tenant_id}/oauth2/v2.0/authorize?response_type=code&client_id=${Constants.client_id}&scope=https://graph.microsoft.com/.default&redirect_uri=https://oauth.pstmn.io/v1/browser-callback&state=12345';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBankersList();
  }

  void getBankersList() async {
    await acsBookingController?.getBankersList();
    _selectedBanker = List.generate(
        acsBookingController!.respGetBanker['value'].length, (i) => false);
    _selectedBanker[0] = true;
    acsBookingController!.selectedBankerEmailId = acsBookingController!
        .respGetBanker['value'][0]['emailAddress']
        .toString();
    acsBookingController!.selectedBankerId =
        acsBookingController!.respGetBanker['value'][0]['id'].toString();
    acsBookingController!.selectedBankerName = acsBookingController!
        .respGetBanker['value'][0]['displayName']
        .toString();

    String formattedDate = DateFormat('yyyy-MM-dd').format(today);
    acsBookingController!.defaultDate = formattedDate;
    getAppoinments(today.weekday - 1, formattedDate);

    setState(() {});
  }

  getAppoinments(int weekday, String date) async {
    getScheduleResponse =
        await acsBookingController?.getAwailableSlots(weekday, date);
    // _selected = List.generate(timeslots.length, (i) => false);
    //_selected[0] = true;
    availableTimeSlots = getScheduleResponse != null &&
            getScheduleResponse['value'] != null &&
            getScheduleResponse['value'].length > 0 &&
            getScheduleResponse['value'][0]['availabilityView'] != null
        ? getScheduleResponse['value'][0]['availabilityView'].split('')
        : "000000000000000000".split('');
    var startWorkingHr = acsBookingController!.respGetBanker != null &&
            acsBookingController!.respGetBanker['value'] != null &&
            acsBookingController!.respGetBanker['value'].length > 0 &&
            acsBookingController!.respGetBanker['value'][0]['workingHours'] !=
                null &&
            acsBookingController!
                    .respGetBanker['value'][0]['workingHours'].length >
                0 &&
            acsBookingController!.respGetBanker['value'][0]['workingHours'][0]
                    ['timeSlots'] !=
                null &&
            acsBookingController!
                    .respGetBanker['value'][0]['workingHours'][0]['timeSlots']
                    .length >
                0 &&
            acsBookingController!.respGetBanker['value'][0]['workingHours'][0]
                    ['timeSlots'][0]['startTime'] !=
                null
        ? acsBookingController!.respGetBanker['value'][0]['workingHours'][0]
            ['timeSlots'][0]['startTime']
        : "14:00:00.0000000";
    var endWorkingHr = acsBookingController!.respGetBanker != null &&
            acsBookingController!.respGetBanker['value'] != null &&
            acsBookingController!.respGetBanker['value'].length > 0 &&
            acsBookingController!.respGetBanker['value'][0]['workingHours'] !=
                null &&
            acsBookingController!
                    .respGetBanker['value'][0]['workingHours'].length >
                0 &&
            acsBookingController!.respGetBanker['value'][0]['workingHours'][0]
                    ['timeSlots'] !=
                null &&
            acsBookingController!
                    .respGetBanker['value'][0]['workingHours'][0]['timeSlots']
                    .length >
                0 &&
            acsBookingController!.respGetBanker['value'][0]['workingHours'][0]
                    ['timeSlots'][0]['endTime'] !=
                null
        ? acsBookingController!.respGetBanker['value'][0]['workingHours'][0]
            ['timeSlots'][0]['endTime']
        : "23:00:00.0000000";

    var startTimeFormat = DateFormat("HH:mm:ss").parse(startWorkingHr, true);
    var endTimeFormat = DateFormat("HH:mm:ss").parse(endWorkingHr, true);

    timeslots = acsBookingController!.getTimeSlotsToDisplay(
        DateFormat.Hm().format(startTimeFormat.toLocal()),
        DateFormat.Hm().format(endTimeFormat.toLocal()));

    // var parts = timeslots[0].split('-');
    // acsBookingController!.pickedStartTime = parts[0].trim();
    // acsBookingController!.pickedEndTime = parts[1].trim();
    refreshTimeSlotsUI(-1);
    setState(() {});
  }

  bookAnAppointment() async {
    // await acsBookingController!.actionBookAppointment(
    //     "eyJ0eXAiOiJKV1QiLCJub25jZSI6IlpvTm9GRnpyS3Y0b0VqZzRHbnFkQ1ZCU2ZvLVhubWpfa2ZTa240Y0hiX28iLCJhbGciOiJSUzI1NiIsIng1dCI6Ii1LSTNROW5OUjdiUm9meG1lWm9YcWJIWkdldyIsImtpZCI6Ii1LSTNROW5OUjdiUm9meG1lWm9YcWJIWkdldyJ9.eyJhdWQiOiJodHRwczovL2dyYXBoLm1pY3Jvc29mdC5jb20iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC80YzQ5ODVmZS1jZThlLTRjMmYtOTdlNi1iMDM3ODUwYjc3N2QvIiwiaWF0IjoxNjc1MTM2MzU1LCJuYmYiOjE2NzUxMzYzNTUsImV4cCI6MTY3NTE0MTMzMywiYWNjdCI6MCwiYWNyIjoiMSIsImFpbyI6IkFWUUFxLzhUQUFBQXJNVlRIL2NMM1o2OGtwcCtLQURCME5vZmR6TkZvRkpuR1JvcVRzZlZBZXRtM2wrVmxQNDVCTVExSGZscmpFNG5KNmN1WkZXUWtNUm9hN0JiNGtiK0pRT3Z4d05RV05MOXJYL011MysvSXFNPSIsImFtciI6WyJwd2QiLCJtZmEiXSwiYXBwX2Rpc3BsYXluYW1lIjoiUG9zdG1hbiBNUyBHcmFwaCIsImFwcGlkIjoiZTYxOTcyNjMtYjk4Ni00ZjA4LTlhMjctMDhhNGVjMWI1YzhlIiwiYXBwaWRhY3IiOiIxIiwiZmFtaWx5X25hbWUiOiJQYW5keWEiLCJnaXZlbl9uYW1lIjoiTmFuZGFuIiwiaWR0eXAiOiJ1c2VyIiwiaXBhZGRyIjoiNzUuNDguMzguMjI3IiwibmFtZSI6Ik5hbmRhbiBQYW5keWEiLCJvaWQiOiJmYTU4ODdlYi03YTY2LTQ4MWQtYjYxZS03MTcxZWVhZWY0OTEiLCJwbGF0ZiI6IjMiLCJwdWlkIjoiMTAwMzIwMDI2ODU5OTg4RCIsInJoIjoiMC5BWHdBX29WSlRJN09MMHlYNXJBM2hRdDNmUU1BQUFBQUFBQUF3QUFBQUFBQUFBQzdBREEuIiwic2NwIjoiQm9va2luZ3MuTWFuYWdlLkFsbCBCb29raW5ncy5SZWFkLkFsbCBCb29raW5ncy5SZWFkV3JpdGUuQWxsIEJvb2tpbmdzQXBwb2ludG1lbnQuUmVhZFdyaXRlLkFsbCBDYWxlbmRhcnMuUmVhZC5TaGFyZWQgQ2FsZW5kYXJzLlJlYWRXcml0ZSBDYWxlbmRhcnMuUmVhZFdyaXRlLlNoYXJlZCBDcm9zc1RlbmFudEluZm9ybWF0aW9uLlJlYWRCYXNpYy5BbGwgQ3Jvc3NUZW5hbnRVc2VyUHJvZmlsZVNoYXJpbmcuUmVhZFdyaXRlIERlbGVnYXRlZEFkbWluUmVsYXRpb25zaGlwLlJlYWRXcml0ZS5BbGwgR3JvdXBNZW1iZXIuUmVhZFdyaXRlLkFsbCBNYWlsLlJlYWRXcml0ZSBNYWlsLlJlYWRXcml0ZS5TaGFyZWQgTWFpbC5TZW5kIE1haWwuU2VuZC5TaGFyZWQgT25saW5lTWVldGluZ3MuUmVhZFdyaXRlIFNjaGVkdWxlLlJlYWRXcml0ZS5BbGwgVGFza3MuUmVhZFdyaXRlIFRlYW0uQ3JlYXRlIFRlYW0uUmVhZEJhc2ljLkFsbCBVc2VyLlJlYWQgVXNlci5SZWFkV3JpdGUgVXNlci5SZWFkV3JpdGUuQWxsIHByb2ZpbGUgb3BlbmlkIGVtYWlsIiwic2lnbmluX3N0YXRlIjpbImttc2kiXSwic3ViIjoibjBhN2NNRFZhSUowNzB5OXF2czQ5V1RiX3pxUUZLVXVxNXE1MTVNMjQ0ZyIsInRlbmFudF9yZWdpb25fc2NvcGUiOiJOQSIsInRpZCI6IjRjNDk4NWZlLWNlOGUtNGMyZi05N2U2LWIwMzc4NTBiNzc3ZCIsInVuaXF1ZV9uYW1lIjoiTmFuZGExQDI3cjRsNS5vbm1pY3Jvc29mdC5jb20iLCJ1cG4iOiJOYW5kYTFAMjdyNGw1Lm9ubWljcm9zb2Z0LmNvbSIsInV0aSI6ImpjWUxqS3pkVEVLUUdsYkZTTXNMQUEiLCJ2ZXIiOiIxLjAiLCJ3aWRzIjpbImYwMjNmZDgxLWE2MzctNGI1Ni05NWZkLTc5MWFjMDIyNjAzMyIsIjY5MDkxMjQ2LTIwZTgtNGE1Ni1hYTRkLTA2NjA3NWIyYTdhOCIsImZlOTMwYmU3LTVlNjItNDdkYi05MWFmLTk4YzNhNDlhMzhiMSIsImYyZWY5OTJjLTNhZmItNDZiOS1iN2NmLWExMjZlZTc0YzQ1MSIsImYyOGExZjUwLWY2ZTctNDU3MS04MThiLTZhMTJmMmFmNmI2YyIsIjcyOTgyN2UzLTljMTQtNDlmNy1iYjFiLTk2MDhmMTU2YmJiOCIsIjI5MjMyY2RmLTkzMjMtNDJmZC1hZGUyLTFkMDk3YWYzZTRkZSIsIjYyZTkwMzk0LTY5ZjUtNDIzNy05MTkwLTAxMjE3NzE0NWUxMCIsImI3OWZiZjRkLTNlZjktNDY4OS04MTQzLTc2YjE5NGU4NTUwOSJdLCJ4bXNfc3QiOnsic3ViIjoibDEtY1NMbU9SbHhRQnl1VHY2ZG1hX3F1RllFdUxZdEp6NnN6TXNickNNRSJ9LCJ4bXNfdGNkdCI6MTY3MTEwNTY5NX0.f74N5pPCwNc0SOng1j5YLqbrQZ_yZPGpmo72XOMSsFRYK_cir-sOifn4dVMbd7VfO0NTy8Ie02vgzpboy3ZciBHxNIWoswkd4O6hdLMeCA6oaBV4oU_AHYO32qCKX0tFbaW5lw3u6NZNd6z5mB_9cLDX57ddtHnw_rqUcr5Q9Oo4iOqqtnQ2C4ur8gsYMsrckxk-9pGZzoV3vzESW4WjAKmW9O7ujaArN2Xte6priTp4hSIZDXPDL_hMz4yBMwUfgSw7FLHnyAFJmZUwoVYwP-jLBAvXwvqQ-GhQdmeo4HYJTU9pXWjJUL99ubg8p53kE_wMcT1lZiPxWHyli2ZJXg");
    await acsBookingController!.getBookingDelegateToken();

    if (acsBookingController!.respBooking.toString().contains("Error")) {
      // showToast("Something went wrong, please try again");
      CustomSnackBar().showToast(
          context, acsBookingController!.respBooking.toString(), false);
    } else {
      // Navigate to previous screen..
      Constants.isSnackbarVisible = true;
      Constants.snackbarMsg = "Booking is completed on " +
          acsBookingController!.defaultDate +
          " at " +
          acsBookingController!.pickedStartTime +
          " with " +
          acsBookingController!.selectedBankerName;
      Constants.snackbarType = true;
      setState(() {});
      /*CustomSnackBar().showToast(context, "Booking is completed on " +
          acsBookingController!.defaultDate +
          " at\n " +
          acsBookingController!.pickedStartTime +
          " with " +
          acsBookingController!.selectedBankerName, true);*/
      // If in success we want to go back to previous screen use below code.
      popScreen(context);
    }

    setState(() {});
  }

  Widget get loadWebView => Container(
        height: double.infinity,
        width: double.infinity,
        child: const SizedBox(),
      );

  @override
  Widget get view => Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 70,
          leading: IconButton(
              onPressed: () => popScreen(context),
              icon: const Icon(Icons.chevron_left)),
          title: appBarTitle,
        ),
        // key: globalKey,
        body: SafeArea(
          child: bookingContent,
          /*child: ControlledWidgetBuilder<ACSBookingController>(
            builder: (context, controller) {
              // acsBookingController = controller;
              print("Check for controller in view : "+acsBookingController.toString());
              return bookingContent;
            },
          ),*/
        ),
      );

  Widget get bookingContent => Stack(
        children: [
          Positioned(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(spacing_12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    containerBankerList(),
                    vSpacer(spacing_12),
                    containerPickDate(),
                    vSpacer(spacing_10),
                    containerPickTimeSlot(),
                    vSpacer(spacing_12),
                    bottomBookingButton(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            child: Visibility(
              visible:
                  acsBookingController!.inProgressFullScreen ? true : false,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black12,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      );

  Widget bottomBookingButton() => GestureDetector(
        onTap: () {
          if (acsBookingController!.pickedStartTime == "" ||
              acsBookingController!.pickedEndTime == "") {
            // showToast(Constants.selectTimeSlotMsg);
            CustomSnackBar()
                .showToast(context, Constants.selectTimeSlotMsg, false);
          } else {
            bookAnAppointment();
            setState(() {});
          }
        },
        child: customButton(
            const Icon(null, size: 0),
            Constants.bookAnAppointment,
            AppColor.brown_231d18,
            AppColor.brown_231d18,
            Colors.white),
      );

  Widget containerPickDate() => Card(
        color: Colors.white,
        elevation: 3,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              contentTitle(Constants.pickDate),
              vSpacer(10),
              CalendarDatePicker(
                  initialDate: setDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 100000)),
                  onDateChanged: (DateTime value) {
                    selectedDayIndex = value.weekday - 1;

                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(value);

                    // _selected.clear();
                    // _selected = List.generate(acsBookingController!.resp['value'][0]['availabilityView'].length, (i) => false);

                    acsBookingController!.pickedStartTime = "";
                    acsBookingController!.pickedEndTime = "";

                    acsBookingController!.defaultDate = formattedDate;

                    getAppoinments(selectedDayIndex, formattedDate);
                    setState(() {});
                  }),
            ],
          ),
        ),
      );

  Widget containerBankerList() => acsBookingController!.respGetBanker != null &&
          acsBookingController!.respGetBanker['value'] != null &&
          acsBookingController!.respGetBanker['value'].length > 0
      ? listBankers()
      : SizedBox(
          height: 100,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );

  Widget listBankers() => ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      // itemCount: 10,
      itemCount: acsBookingController!.respGetBanker['value'].length,
      itemBuilder: (BuildContext context, int index) {
        return bankerListCell(index);
      });

  Widget bankerListCell(int index) => GestureDetector(
        onTap: () {
          for (int i = 0; i < _selectedBanker.length; i++) {
            _selectedBanker[i] = false;
          }
          _selectedBanker[index] = true;
          acsBookingController!.selectedBankerEmailId = acsBookingController!
              .respGetBanker['value'][index]['emailAddress']
              .toString();
          acsBookingController!.selectedBankerId = acsBookingController!
              .respGetBanker['value'][index]['id']
              .toString();
          acsBookingController!.selectedBankerName = acsBookingController!
              .respGetBanker['value'][index]['displayName']
              .toString();

          acsBookingController!.pickedStartTime = "";
          acsBookingController!.pickedEndTime = "";

          getAppoinments(today.weekday - 1, acsBookingController!.defaultDate);
          setState(() {});
        },
        child: Card(
          color: Colors.white,
          elevation: 2.0,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(spacing_14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: Image.asset(
                        Utility.getUserProfileImage(
                            acsBookingController!.respGetBanker['value'][index]
                                ['displayName'],
                            index),
                        height: 40.0,
                        width: 40.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                    hSpacer(spacing_12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                            textName: acsBookingController!
                                .respGetBanker['value'][index]['displayName']
                                .toString(),
                            textAlign: TextAlign.start,
                            fontSize: 15,
                            fontWeight: FontWeight.w300),
                        vSpacer(spacing_4),
                        CustomText(
                            textName: 'Private Banker',
                            textAlign: TextAlign.start,
                            fontSize: 11,
                            fontWeight: FontWeight.w200),
                      ],
                    ),
                  ],
                ),
                Icon(
                  _selectedBanker[index]
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: _selectedBanker[index] ? Colors.green : Colors.black,
                ),
              ],
            ),
          ),
        ),
      );

  Widget containerPickTimeSlot() => Card(
        color: Colors.white,
        elevation: 3,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              contentTitle(Constants.pickTimeSlot),
              vSpacer(10),
              acsBookingController!.inProgress
                  ? const SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : acsBookingController!.resp != null &&
                          acsBookingController!.resp['value'] != null &&
                          acsBookingController!.resp['value'].length > 0 &&
                          acsBookingController!.resp['value'][0]
                                  ['availabilityView'] !=
                              null &&
                          acsBookingController!
                                  .resp['value'][0]['availabilityView'].length >
                              0
                      ? listSlots()
                      : SizedBox(
                          height: 100,
                          child: Center(
                            child: CustomText(
                                textName: Constants.noAvailableTimeSlots,
                                textAlign: TextAlign.center,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
              // listSlots(),
            ],
          ),
        ),
      );

  Widget contentTitle(String strLabel) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: CustomText(
          textName: strLabel,
          textAlign: TextAlign.start,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      );

  Widget listSlots() => ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      // itemCount: 10,
      // itemCount: acsBookingController!.resp['value'][0]['availabilityView'].toString().length,
      itemCount: timeslots.length,
      itemBuilder: (BuildContext context, int index) {
        return slotCellItem(index);
      });

  Widget slotCellItem(int index) => GestureDetector(
        onTap: () => {
          if (int.parse(availableTimeSlots[index]) != 0)
            {
              //Handle event for time slots not available
            }
          else
            {
              //Handle event for time slots available
              refreshTimeSlotsUI(index),
              splitTime = timeslots[index].split('-'),
              acsBookingController!.pickedStartTime = splitTime[0].trim(),
              acsBookingController!.pickedEndTime = splitTime[1].trim(),
            }
        },
        child: Card(
          color: availableTimeSlots != null &&
                  availableTimeSlots.length > 0 &&
                  int.parse(availableTimeSlots[index]) != 0
              ? AppColor.grey_color_300
              : _selected[index]
                  ? AppColor.brown_231d18
                  : Colors.white,
          elevation: 2.0,
          margin: EdgeInsets.only(top: spacing_10),
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: spacing_6, vertical: spacing_6),
            child: CustomText(
              // textName: timeslots[index],
              textName: displayTimeSlotNew(timeslots[index].toString()),
              textAlign: TextAlign.center,
              fontSize: 14,
              fontWeight: FontWeight.w300,
              textColor: availableTimeSlots != null &&
                      availableTimeSlots.length > 0 &&
                      int.parse(availableTimeSlots[index]) != 0
                  ? Colors.black
                  : _selected[index]
                      ? Colors.white
                      : Colors.black,
            ),
          ),
        ),
      );

  Widget get appBarTitle => Column(
        children: [
          CustomText(
            textName: Constants.bookAnAppointment,
            textAlign: TextAlign.center,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            textColor: Colors.black,
          ),
          vSpacer(10),
          CustomText(
            textName: Constants.contactCenterToolbarMsgPrivateBanker,
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

  Widget customButton(Icon icon, String strLabel, Color bgColorButton,
          Color borderColorButton, Color iconTextColor) =>
      Container(
        height: 48,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: spacing_14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: borderColorButton, width: 1),
          color: bgColorButton,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: spacing_10),
              child: Center(
                child: icon,
              ),
            ),
            CustomText(
                textName: strLabel,
                textAlign: TextAlign.center,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textColor: iconTextColor),
          ],
        ),
      );

  displayTimeSlotNew(String time) {
    var strInputTime = time.split('-');
    var strStartTime = strInputTime[0].trim();
    var strEndTime = strInputTime[1].trim();

    DateFormat formatter_display_time = DateFormat('hh:mm a');

    DateTime tempStartTime = DateFormat("HH:mm").parse(strStartTime, true);
    DateTime tempEndTime = DateFormat("HH:mm").parse(strEndTime, true);

    var strConvertedStartTime = formatter_display_time.format(tempStartTime);
    var strConvertedEndTime = formatter_display_time.format(tempEndTime);

    return "$strConvertedStartTime - $strConvertedEndTime";
  }

  void refreshTimeSlotsUI(int index) {
    for (int i = 0; i < 50; i++) {
      setState(() => _selected[i] = false);
    }
    if (index >= 0) {
      setState(() => _selected[index] = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return view;
  }
}
