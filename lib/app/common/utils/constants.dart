import 'package:flutter/material.dart';

class Resources {
  static const String login_banner = 'assets/images/login_banner.png';
  static const String banker_img = 'assets/images/banner.png';
  static const String user_1 = 'assets/images/user_1.png';
  static const String user_2 = 'assets/images/user_2.png';
  static const String user_3 = 'assets/images/user_3.png';

  // static const int number = 0;
  static int number = 0;
}

class Strings {
  /* TRANSLATABLE STRINGS STARTS */
  static const String app_name_lbl = 'ACS Calling Chat Demo';
}

class SharedPrefKey {
  static const String pref_key_integrated_apps = 'pref_key_integrated_apps';
  static const String prefs_acs_token = 'prefs_acs_token';
  static const String prefs_service_id = 'prefs_service_id';
  static const int page_count = 0;
}

class AppColor {
  static const Color onboarding_title_color = Color(0xFF3E4347);
  static const Color primary_color = Color(0xFFFE3E4C);
  static const Color disabled_color = Color(0x29FE3E4C);
  static const Color bg_color = Color(0xFFE5E5E5);
  static const Color blue_color = Color(0xFF002D72);
  static const Color grey_color = Color(0xFF666666);
  static const Color text_color = Color(0xFFC99700);
  static const Color container_color = Color(0x70FFE166);
  static const Color bottom_tab_color = Color(0xFF0059CA);
  static const Color tab_integrated = Color(0xFF006E0A);
  static const Color tab_in_progress = Color(0xFFFFCA00);
  static const Color txt_gray_black = Color(0xFF333333);
  static const Color green_color = Color(0xFF4CAF50);

  // Constant colors..
  static const Color black_color = Color(0xFF000000);
  static const Color black_trans = Color(0x80000000);
  static const Color white_color_70 = Color(0xB3FFFFFF);
  static const Color black_color_87 = Color(0xDD000000);
  static const Color black_color_54 = Color(0x8A000000);
  static const Color white_color = Color(0xFFFFFFFF);
  static const Color transparent_color = Color(0x00000000);
  static const Color green_color_50 = Color(0xFFE8F5E9);
  static const Color green_color_100 = Color(0xFFC8E6C9);
  static const Color teal_color = Color(0xFF009688);
  static const Color grey_color_100 = Color(0xFFF5F5F5);
  static const Color grey_color_200 = Color(0xFFEEEEEE);
  static const Color grey_color_300 = Color(0xFFE0E0E0);
  static const Color grey_color_500 = Color(0xFF9E9E9E);
  static const Color blue_color_900 = Color(0xFF0D47A1);
  static const Color blue_accent = Color(0xFF82B1FF);
  static const Color blue_0077cc = Color(0xFF0077CC);
  static const Color black_22303e = Color(0xFF22303E);
  static const Color gray_8d8d8d = Color(0xFF8D8D8D);
  static const Color gray_efeeee = Color(0xFFEFEEEE);

  static const Color bg_color_contact = Color(0xFFF6F7F7);
  static const Color brown_231d18 = Color(0xFF231d18);

  static const Color green_toast = Color(0xFF147267);
  static const Color red_toast = Color(0xFFAB1912);

}

class Constants {
  //API settings config
  static const String service_email_id = 'JohnsonFamilyBusiness1@27r4l5.onmicrosoft.com';

  //User Info data set for hardcoded, it should not break code in flutter
  //when user logged-in from iOS it'll be dynamic content
  static String userName = 'Janet Johnson';
  static String userEmail = 'janetjohnsonfamily83@gmail.com';
  static String userId = 'a2194b29-07bb-48bb-8607-6151334cf904';

  static const String loggedInUser_key = "loggedInUser";
  static const String app_serach = 'search';
  static const String app_search_hint = "Search";
  static const String integrate_now = 'Integrate now';
  static const String speak_to_banker= 'Speak to banker';
  static const String popular_camel_case = 'Popular';
  static const String popular = 'POPULAR';
  static const String addepar = 'Addepar';
  static const String overview = 'Overview';
  static const String key_features = 'Key features';
  static const String coverage = 'Coverage';
  static const String usa = 'USA';
  static const String product_details_cards_heading = 'it goes well with';
  static const String top_wealth_app = 'Top Wealth Apps';
  static const String whats_new = 'What\'s new';
  static const String welcome_to_citi_market_text = 'Welcome to ACS Calling Chat';
  static const String all_apps = 'All apps';
  static const String tax_solutions = 'Tax solutions';
  static const String grow_your_wealth = 'Grow your wealth';
  static const String accounting = 'Accounting';
  static const String apps_stats = 'Apps stats';
  static const String manage_apps = 'Manage Apps';
  static const String home = 'Home';
  static const String my_apps = 'My Apps';
  static const String browse = 'Browse';
  static const String preferences = 'Preferences';
  static const String no_appointments = "No appointments found";

  // Login screen
  static const String welecome = 'Welcome!';
  static const String user_name = 'Username';
  static const String password = 'Password';
  static const String forgot_password = 'Forgot Password?';
  static const String login = 'Login';

  //product details constants
  static const String customAlertDialogTitle = 'Information';
  static const String customAlertDialogDescription = 'Do you already have an account?';
  static const String customAlertDialogCancelButtonName = 'No';
  static const String customAlertDialogConfirmButtonName = 'Yes';

  // Search screen
  static const String search_results = 'Search results';
  static const String no_results = 'No Results';

  // Product integration
  static const String your_data_processing = 'Your data is processing';
  static const String your_data_protected = 'Your data is protect';
  static const String your_data_protected_msg = 'your can easily benefit from integrated data without losing your privacy';
  static const String stop_sync = 'Stop synchronization';
  static const String back_my_apps = 'Back to My Apps';
  static const String no_apps_subscried = 'No apps subscribed';
  static const String product_name = 'Product name';

  // Home screen
  static const String app_status_subscribe = 'Subscribe';
  static const String product_description = 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard';

  // Contact Center screen..
  static const String contactCenter = 'Contact Center';
  static const String contactCenterToolbarMsg = 'Contact your private baker or manage appointment';
  static const String contactCenterToolbarMsgPrivateBanker = 'Contact your private baker';
  static const String tabContact = 'Contact';
  static const String tabAppointment = 'Appointments';
  static const String yourPrivateBanker = 'Your private banker';
  static const String yourPrivateBankers = 'Your private bankers';
  static const String bookAnAppointment = 'Book an appointment';
  static const String sendMessage = 'Send a message';
  static const String startVideoOrAudioCall = 'Start video or audio call';
  static const String joinMeeting = 'Join Meeting';
  static const String viewDetails = 'View Details';
  static const String noAppointments = 'No Appointments found';
  static const String selectDate = 'Pick date';
  static const String pickTimeSlot = 'Pick available timeslot';
  static const String pickDate = 'Pick date';
  static const String selectTimeSlotMsg = 'Please select time slot first';

  static bool isSnackbarVisible = false;
  static bool snackbarType = false;
  static String snackbarMsg = '';
}


class UrlConstants {}

class LangConstants {
  static const List supportedLocales = [
    Locale('en', 'US'),
    Locale('es', 'US'),
  ];
}
