import 'dart:async';
import 'dart:convert';

import 'package:acscallingchatflutter/app/common/navigation/pages.dart';
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

class ACSAppointmentPhonePageState
    // extends ViewState<ACSAppointmentPhonePage, ACSAppointmentController> {
    extends State<ACSAppointmentPhonePage> {
  // ACSAppointmentPhonePageState(): super(ACSAppointmentController(ACSChatCallingDataRepository()));

  ACSAppointmentController? acsAppointmentController =
      ACSAppointmentController(ACSChatCallingDataRepository());

  static const Channel = MethodChannel('com.citi.marketplace.host');

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

  // var resp;
  //
  // var acsToken = '';
  // var serviceId = '';

  Future<void> joinCallClick(meetingLink, username) async {
    final bool status = await Channel.invokeMethod('joinCallClick',
        <String, String>{'meeting_id': meetingLink, 'user_name': username});
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

    getAppointmentList();
  }

  void getAppointmentList() async {
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
                                      getAppointmentList(),
                                      setState(() {}),
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
                        child: acsAppointmentController!.inProgress
                            ? Container(
                                height: double.infinity,
                                width: double.infinity,
                                // color: Colors.black12,
                                // color: AppColor.black_trans,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : acsAppointmentController!.resp != null &&
                                    acsAppointmentController!.resp['value'] !=
                                        null &&
                                    acsAppointmentController!
                                            .resp['value'].length >
                                        0
                                // ? listAppointments
                                ? listAppointments
                                : Center(
                                    child: CustomText(
                                        textName: Constants.noAppointments,
                                        textAlign: TextAlign.center,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                  ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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

  Widget get listAppointments => ListView.builder(
      itemCount: acsAppointmentController!.resp['value'].length,
      itemBuilder: (BuildContext context, int index) {
        return appointmentCellItem(index);
      });

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
                    textName: 'Hello Janet Johnson!',
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
                          acsAppointmentController!.resp['value'][index]
                              ['onlineMeeting']['joinUrl'],
                          acsAppointmentController!
                                      .resp['value'][index]['attendees']
                                      .length >
                                  0
                              ? acsAppointmentController!.resp['value'][index]
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
        acsAppointmentController!.resp['value'][index]['start']['dateTime']
            .toString(),
        true);
    var strDate = formatter_display_date.format(tempDateTime);
    var strTime = formatter_display_time.format(tempDateTime.toLocal());
    var strTimeZone = acsAppointmentController!.resp['value'][index]['start']
            ['timeZone']
        .toString();
    var strBankerName =
        acsAppointmentController!.resp['value'][index]['attendees'].length > 0
            ? acsAppointmentController!.resp['value'][index]['attendees'][0]
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
