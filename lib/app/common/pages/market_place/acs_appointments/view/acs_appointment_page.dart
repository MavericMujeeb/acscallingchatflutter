import 'package:acscallingchatflutter/app/common/pages/market_place/acs_appointments/view/phone/acs_appointment_phone_page.dart';
import 'package:acscallingchatflutter/app/common/pages/market_place/acs_chat_calling/controller/acs_chat_calling_controller.dart';
import 'package:acscallingchatflutter/data/repositories/acs_chat_calling_repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class ACSAppointmentPage extends View {
  const ACSAppointmentPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ACSAppointmentPageState();
  }
}

class ACSAppointmentPageState
    extends ResponsiveViewState<ACSAppointmentPage, ACSChatCallingController> {
  ACSAppointmentPageState()
      : super(ACSChatCallingController(ACSChatCallingDataRepository()));

  @override
  Widget get desktopView => const ACSAppointmentPhonePage();

  @override
  Widget get mobileView => const ACSAppointmentPhonePage();

  @override
  Widget get tabletView => const ACSAppointmentPhonePage();

  @override
  Widget get watchView => const ACSAppointmentPhonePage();
}
