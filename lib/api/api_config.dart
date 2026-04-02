class ApiConfig {
  static const String baseUrl =
      "https://digitalspaceinc.com/positive_metering/ws/";

  static String get sendOtpUrl => "${baseUrl}sendotp.php";
  static String get loginUrl => "${baseUrl}login.php";
  static String get getTourPlanUrl => "${baseUrl}getTourPlan.php";
  static String get getTourPlanYearlyUrl => "${baseUrl}getTourPlanYearly.php";
  static String get getCustomerListUrl => "${baseUrl}getCustomerList.php";
  static String get getRegionUrl => "${baseUrl}getRegion.php";
  static String get getCustomerTypeUrl => "${baseUrl}getCustomer_type.php";
  static String get getGroupUrl => "${baseUrl}getGroup.php";
  static String get addTourPlanUrl => "${baseUrl}addTourPlan.php";
}
