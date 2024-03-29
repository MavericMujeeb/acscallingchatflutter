import 'dart:async';
import 'dart:convert';

import 'package:acscallingchatflutter/app/common/navigation/pages.dart';
import 'package:acscallingchatflutter/app/common/utils/custom_snackbar.dart';
import 'package:acscallingchatflutter/domain/entities/user_info_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:acscallingchatflutter/app/common/navigation/navigation.dart';
import 'package:acscallingchatflutter/app/widgets/custom_text.dart';
import 'package:acscallingchatflutter/data/helpers/shared_preferences.dart';
import 'package:acscallingchatflutter/data/repositories/acs_chat_calling_repositories.dart';

import '../../../../../utils/constants.dart';
import '../../controller/acs_appointment_controller.dart';

import 'package:http/http.dart' as http;

class ACSAppointmentPhonePage extends View {
  const ACSAppointmentPhonePage({Key? key}) : super(key: key);

  @override
  ACSAppointmentPhonePageState createState() => ACSAppointmentPhonePageState();
}

class ACSAppointmentPhonePageState // extends ViewState<ACSAppointmentPhonePage, ACSAppointmentController> {
    extends State<ACSAppointmentPhonePage> {
  // ACSAppointmentPhonePageState(): super(ACSAppointmentController(ACSChatCallingDataRepository()));

  ACSAppointmentController? acsAppointmentController =
      ACSAppointmentController(ACSChatCallingDataRepository());

  static const Channel = MethodChannel(Constants.Method_Channel_Name);

  int selectedTabIndex = 0;

  static const MARGIN_TOP = 10.0;
  static const MARGIN_BOTTOM = 10.0;
  static const MARGIN_LEFT = 20.0;
  static const MARGIN_RIGHT = 20.0;
  static const FONT_SIZE = 24.0;
  static const BUTTON_BORDER_RADIUS = 16.0;
  static const spacing_4 = 4.0;
  static const spacing_6 = 6.0;
  static const spacing_8 = 8.0;
  static const spacing_10 = 10.0;
  static const spacing_12 = 12.0;
  static const spacing_14 = 14.0;
  static const spacing_16 = 16.0;
  static const spacing_18 = 18.0;
  static const spacing_20 = 20.0;
  static const spacing_22 = 22.0;
  static const spacing_24 = 24.0;
  static const spacing_26 = 26.0;
  static const spacing_28 = 28.0;

  static const bankerIconSize = 25.0;

  // var resp;
  //
  // var acsToken = '';
  // var serviceId = '';

  Future<void> joinCallClick(meetingLink, username) async {
    final bool status = await Channel.invokeMethod('joinCallClick',
        <String, String>{'meeting_id': meetingLink, 'user_name': username});
  }

  Future<void> chatWithBanker(username) async {
    print(username);
    await Channel.invokeMethod(
        'startChat', <String, String>{'user_name': username});
  }

  Future<void> audioCallWithBanker(username) async {
    print(username);
    await Channel.invokeMethod(
        'startAudioCall', <String, String>{'user_name': username});
  }

  Future<void> videoCallWithBanker(username) async {
    print(username);
    await Channel.invokeMethod(
        'startVideoCall', <String, String>{'user_name': username});
  }

  Future incomingMethodHandler() async {
    Channel.setMethodCallHandler(methodHandler);
  }

  Future<void> methodHandler(MethodCall call) async {
    String callArguments = call.arguments;
    Map<String, dynamic> userMap = json.decode(callArguments);
    switch (call.method) {
      case "loginUserDetails":
        var userInfoData = UserInfoData.fromJson(userMap);
        Constants.userName = userInfoData.userName;
        Constants.userEmail = userInfoData.userEmail;
        Constants.userId = userInfoData.userId;
        break;
    }
  }

  /*Future<void> startCallClick() async {
    final int batteryLevel =
        await Channel.invokeMethod('startCallClick', <String, String>{
      'message':
          'This is a Toast from From Flutter to Android Native Code Yes, It is working'
    });
    print(batteryLevel);
  }

  Future<void> joinCallClick() async {
    final int batteryLevel =
        await Channel.invokeMethod('joinCallClick', <String, String>{
      'message':
          'This is a Toast from From Flutter to Android Native Code Yes, It is working'
    });
    print(batteryLevel);
  }

  Future<void> chatClick() async {
    final int batteryLevel =
        await Channel.invokeMethod('chatClick', <String, String>{
      'message':
          'This is a Toast from From Flutter to Android Native Code Yes, It is working'
    });
    print(batteryLevel);
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    incomingMethodHandler();
    getAppointmentList();
  }

  void checkForSnackbar() {
    if (Constants.isSnackbarVisible) {
      CustomSnackBar()
          .showToast(context, Constants.snackbarMsg, Constants.snackbarType);

      Constants.isSnackbarVisible = false;
      Constants.snackbarMsg = "";
      Constants.snackbarType = false;
      setState(() {});
      acsAppointmentController!.resp = "";
      acsAppointmentController!.inProgress = true;
      setState(() {});
      Future.delayed(Duration(seconds: 2), () {
        getAppointmentList();
        setState(() {});
      });
      setState(() {});
    }
  }

  /*void delay10Sec() async {
    Future.delayed(
        Duration(
            seconds: 10), () {
      print("delay10Sec is called");
      // getAppointmentList();
    });
  }*/

  void getAppointmentList() async {
    print("Get getAppointmentList is called");
    await acsAppointmentController!.getToken();
    setState(() {});
  }

  @override
  Widget get view => Scaffold(
        backgroundColor: AppColor.bg_color_contact,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: AppColor.transparent_color,
        ),
        // key: globalKey,
        body: SafeArea(
          child: viewContent,
        ),
      );

  Widget get viewContent => Column(
        children: [
          horizontalDivider,
          Expanded(
            child: Container(
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        left: 14.0,
                        right: 14.0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            if (acsAppointmentController!.inProgress) {
                              // Do nothing..
                            } else {
                              Future.delayed(const Duration(microseconds: 500),
                                  () {
                                /*navigateToBookingScreen(context);*/
                                // acsAppointmentController!.resp['value'] = "";
                                Navigator.of(context)
                                    .pushNamed(Pages.screen_booking)
                                    .then((value) => {
                                          checkForSnackbar(),
                                        });
                              });
                            }
                          },
                          child: customButton(
                              48,
                              Constants.bookAnAppointment,
                              AppColor.brown_231d18,
                              AppColor.brown_231d18,
                              Colors.white),
                        ),
                      ),
                      Positioned(
                          top: 14,
                          left: 14,
                          right: 14,
                          bottom: 80,
                          child: SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: acsAppointmentController!.inProgress
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : listColumnStaffAppointment,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  Widget get listColumnStaffAppointment => RefreshIndicator(
        strokeWidth: 3,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: () async {
          acsAppointmentController!.resp = "";
          acsAppointmentController!.inProgress = true;
          setState(() {});
          Future.delayed(Duration(seconds: 1), () {
            getAppointmentList();
            setState(() {});
          });
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vSpacer(6),
              CustomText(
                  textName: Constants.yourPrivateBankers,
                  textAlign: TextAlign.left,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              vSpacer(12),
              SizedBox(
                height: 200,
                child: acsAppointmentController!.respGetBanker != null &&
                        acsAppointmentController!
                                .respGetBanker['value'].length >
                            0
                    ? listBankers
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              vSpacer(18),
              acsAppointmentController!.resp != null &&
                      acsAppointmentController!.resp.length > 0
                  ? listAppointments
                  : Center(
                      child: CustomText(
                          textName: Constants.noAppointments,
                          textAlign: TextAlign.center,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ),
              vSpacer(200),
            ],
          ),
        ),
      );

  Widget get appointmentContent => Expanded(
        child: Stack(
          children: [
            Positioned(
                top: 14,
                left: 14,
                right: 14,
                bottom: 80,
                child: listAppointments),
          ],
        ),
      );

  Widget get horizontalDivider => Container(
        height: 0.5,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: spacing_18),
        color: AppColor.black_color_54,
      );

  Widget get listBankers => ListView.builder(
      // physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      // shrinkWrap: true,
      // itemCount: 10,
      itemCount: acsAppointmentController!.respGetBanker['value'].length,
      itemBuilder: (BuildContext context, int index) {
        return bankerListCell(index);
      });

  Widget get listAppointments => ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      // itemCount: acsAppointmentController!.resp.length,
      itemCount: acsAppointmentController!.resp.length,
      itemBuilder: (BuildContext context, int index) {
        return appointmentCellItem(index);
      });

  Widget bankerListCell(int index) => SizedBox(
        width: MediaQuery.of(context).size.width / 2.15,
        child: Card(
          color: Colors.white,
          elevation: 2.0,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(spacing_14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                  child: Image.asset(
                    acsAppointmentController!.respGetBanker['value']
                    [index]['displayName'] == "Chantal Kendall" ? Resources.available : Resources.busy,
                    height: 10.0,
                    width: 10.0,
                    fit: BoxFit.fill,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: Image.asset(
                    acsAppointmentController!.respGetBanker['value']
                    [index]['displayName'] == "Chantal Kendall"
                        ? Resources.user_3
                        : index == 1
                            ? Resources.user_1
                            : Resources.user_2,
                    height: 50.0,
                    width: 50.0,
                    fit: BoxFit.fill,
                  ),
                ),
                vSpacer(spacing_8),
                CustomText(
                    textName: acsAppointmentController!.respGetBanker['value']
                            [index]['displayName']
                        .toString(),
                    textAlign: TextAlign.start,
                    fontSize: 15,
                    fontWeight: FontWeight.w300),
                vSpacer(spacing_4),
                CustomText(
                    textName: 'Private Banker',
                    textAlign: TextAlign.start,
                    fontSize: 10,
                    fontWeight: FontWeight.w200),
                vSpacer(spacing_16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => {
                        acsAppointmentController!.respGetBanker['value']
                        [index]['displayName'] == "Chantal Kendall"
                            ? audioCallWithBanker(acsAppointmentController!
                            .respGetBanker['value'][index]['emailAddress'])
                            : null
                      },
                      child: Image.asset(
                        Resources.phone,
                        height: bankerIconSize,
                        width: bankerIconSize,
                        fit: BoxFit.fill,
                      ),
                    ),
                    hSpacer(spacing_26),
                    GestureDetector(
                      onTap: () => {
                        acsAppointmentController!.respGetBanker['value']
                        [index]['displayName'] == "Chantal Kendall"
                            ? videoCallWithBanker(acsAppointmentController!
                            .respGetBanker['value'][index]['emailAddress'])
                            : null
                      },
                      child: Image.asset(
                        Resources.videocall,
                        height: bankerIconSize,
                        width: bankerIconSize,
                        fit: BoxFit.fill,
                      ),
                    ),
                    hSpacer(spacing_26),
                    GestureDetector(
                      onTap: () => {
                        chatWithBanker(acsAppointmentController!
                            .respGetBanker['value'][index]['emailAddress'])
                      },
                      child: Image.asset(
                        Resources.message,
                        height: bankerIconSize,
                        width: bankerIconSize,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget appointmentCellItem(int index) => Container(
        // height: 174,
        width: double.infinity,
        child: Card(
          color: Colors.white,
          // elevation: 2.0,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: spacing_14, vertical: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vSpacer(spacing_12),
                CustomText(
                    textName: 'Hello ${Constants.userName}!',
                    textAlign: TextAlign.start,
                    fontSize: 17,
                    fontWeight: FontWeight.w400),
                vSpacer(10.0),
                CustomText(
                    textName: 'You have appointment scheduled on ' +
                        getFormattedMessage(index),
                    textAlign: TextAlign.start,
                    fontSize: 15,
                    fontWeight: FontWeight.w300),
                vSpacer(15.0),
                GestureDetector(
                    onTap: () {
                      joinCallClick(
                          acsAppointmentController!.resp[index]['onlineMeeting']
                              ['joinUrl'],
                          acsAppointmentController!
                                      .resp[index]['attendees'].length >
                                  0
                              ? acsAppointmentController!.resp[index]
                                      ['attendees'][0]['emailAddress']['name']
                                  .toString()
                              : "No Name");
                    },
                    child: customButton(40, Constants.joinMeeting, Colors.white,
                        AppColor.brown_231d18, AppColor.brown_231d18)),
              ],
            ),
          ),
        ),
      );

  Widget vSpacer(double height) => SizedBox(
        height: height,
      );

  Widget hSpacer(double width) => SizedBox(
        width: width,
      );

  String getFormattedMessage(int index) {
    DateFormat formatter_display_date = DateFormat('MM-dd-yyyy');
    DateFormat formatter_display_time = DateFormat('hh:mm a');

    DateTime tempDateTime = new DateFormat("yyyy-MM-dd'T'hh:mm:ss.sssZ").parse(
        acsAppointmentController!.resp[index]['start']['dateTime'].toString(),
        true);
    var strDate = formatter_display_date.format(tempDateTime);
    var strTime = formatter_display_time.format(tempDateTime.toLocal());
    var strTimeZone =
        acsAppointmentController!.resp[index]['start']['timeZone'].toString();
    var strBankerName =
        acsAppointmentController!.resp[index]['attendees'].length > 0
            ? acsAppointmentController!.resp[index]['attendees'][0]
                    ['emailAddress']['name']
                .toString()
            : "No Name";

    var strResponse = strDate +
        ' at ' +
        strTime +
        /*" " +
        strTimeZone +*/
        ' with ' +
        strBankerName;

    return strResponse.toString();
  }

  Widget customButton(double heightButton, String strLabel, Color bgColorButton,
          Color borderColorButton, Color iconTextColor) =>
      Container(
        height: heightButton,
        margin: const EdgeInsets.only(bottom: spacing_14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: borderColorButton, width: 1),
          color: bgColorButton,
        ),
        padding: const EdgeInsets.symmetric(horizontal: spacing_18),
        child: Center(
          child: CustomText(
              textName: strLabel,
              textAlign: TextAlign.center,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textColor: iconTextColor),
        ),
      );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return view;
  }
}

class CustomButtonNew extends StatelessWidget {
  CustomButtonNew({
    // required this.onPress,
    required this.heightButton,
    required this.strLabel,
    required this.bgColorButton,
    required this.borderColorButton,
    required this.iconTextColor,
  });

  // final Function onPress;
  final double heightButton;
  final String strLabel;
  final Color bgColorButton;
  final Color borderColorButton;
  final Color iconTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColor.brown_231d18, width: 1),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Center(
        child: CustomText(
            textName: Constants.joinMeeting,
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textColor: AppColor.brown_231d18),
      ),
    );
  }
}
