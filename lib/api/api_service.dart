import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:positive_metering/model/common_model.dart';
import 'package:positive_metering/model/customer_model.dart';
import 'package:positive_metering/model/enquiry_detail_model.dart';
import 'package:positive_metering/model/enquiry_followup_model.dart';
import 'package:positive_metering/model/enquiry_model.dart';
import 'package:positive_metering/model/login_model.dart';
import 'package:positive_metering/model/product_model.dart';
import 'package:positive_metering/model/tour_plan_details_model.dart';
import 'package:positive_metering/model/tour_plan_model.dart';
import 'package:positive_metering/model/tour_plan_yearly_details_model.dart';
import 'package:positive_metering/model/tour_plan_yearly_model.dart';
import 'package:positive_metering/model/visit_followup_model.dart';
import 'api_config.dart';

class ApiService {
  static Future<Map<String, dynamic>> _postRequest(
    String url,
    Map<String, String> params,
  ) async {
    try {
      final response = await http.post(Uri.parse(url), body: params);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 1, 'message': 'Server error'};
      }
    } catch (e) {
      return {'status': 1, 'message': 'Network error'};
    }
  }

  /// SEND OTP
  static Future<bool> sendOtp(String email) async {
    final res = await _postRequest(ApiConfig.sendOtpUrl, {'email': email});

    return res['status'] == 0;
  }

  /// LOGIN
  static Future<LoginModel?> login({
    required String email,
    required String otp,
  }) async {
    final res = await _postRequest(ApiConfig.loginUrl, {
      'email': email,
      'otp_entered': otp,
    });

    if (res['status'] == 0) {
      return LoginModel.fromJson(res);
    }

    return null;
  }

  static Future<List<TourPlanModel>> getTourPlan({
    required String userSrNo,
    required String billDate,
    required String tourType,
  }) async {
    final res = await _postRequest(ApiConfig.getTourPlanUrl, {
      'usersrno': userSrNo,
      'bill_date': billDate,
      'tour_type': tourType,
    });

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => TourPlanModel.fromJson(e))
          .toList();
    }

    return [];
  }

  static Future<List<TourPlanYearlyModel>> getTourPlanYearly({
    required String userSrNo,
    required String tourType,
    required String fromDate,
    required String toDate,
  }) async {
    final res = await _postRequest(ApiConfig.getTourPlanYearlyUrl, {
      'usersrno': userSrNo,
      'tour_type': tourType,
      'from_date': fromDate,
      'to_date': toDate,
    });

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => TourPlanYearlyModel.fromJson(e))
          .toList();
    }

    return [];
  }

  /// CUSTOMER LIST
  static Future<List<CustomerModel>> getCustomerList({
    required String userSrNo,
    required String regionSrNo,
    required String subregionSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.getCustomerListUrl, {
      'usersrno': userSrNo,
      'region_srno': regionSrNo,
      'subregion_srno': subregionSrNo,
    });

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => CustomerModel.fromJson(e))
          .toList();
    }
    return [];
  }

  /// REGION
  static Future<List<CommonModel>> getRegion() async {
    final res = await _postRequest(ApiConfig.getRegionUrl, {});
    if (res['status'] == 0) {
      return (res['data'] as List)
          .map((e) => CommonModel.fromJson(e, "region_srno", "region_name"))
          .toList();
    }
    return [];
  }

  /// CUSTOMER TYPE
  static Future<List<CommonModel>> getCustomerType() async {
    final res = await _postRequest(ApiConfig.getCustomerTypeUrl, {});
    if (res['status'] == 0) {
      return (res['data'] as List)
          .map(
            (e) =>
                CommonModel.fromJson(e, "customer_type_srno", "customer_type"),
          )
          .toList();
    }
    return [];
  }

  /// GROUP
  static Future<List<CommonModel>> getGroup() async {
    final res = await _postRequest(ApiConfig.getGroupUrl, {});
    if (res['status'] == 0) {
      return (res['data'] as List)
          .map((e) => CommonModel.fromJson(e, "group_srno", "group_name"))
          .toList();
    }
    return [];
  }

  /// ADD TOUR PLAN
  static Future<bool> addTourPlan({
    required String userSrNo,
    required String customerSrNo,
    required String billDate,
    required String tourType,
    required String visitCall,
  }) async {
    final res = await _postRequest(ApiConfig.addTourPlanUrl, {
      'usersrno': userSrNo,
      'customer_srno': customerSrNo,
      'bill_date': billDate,
      'tour_type': tourType,
      'visit_call': visitCall,
    });

    return res['status'] == 0;
  }

  static Future<bool> addTourPlanYearly({
    required String userSrNo,
    required String customerSrNo,
    required String fromDate,
    required String toDate,
    required String tourType,
    required String visitCall,
  }) async {
    final res = await _postRequest(ApiConfig.addTourPlanYearlyUrl, {
      'usersrno': userSrNo,
      'customer_srno': customerSrNo,
      'from_date': fromDate,
      'to_date': toDate,
      'tour_type': tourType,
      'visit_call': visitCall,
    });

    return res['status'] == 0;
  }

  /// ATTENDANCE REPORT
  static Future<List<Map<String, dynamic>>> getAttendanceReport({
    required String usersrno,
    required String fromDate,
    required String toDate,
  }) async {
    final res = await _postRequest(ApiConfig.getAttendanceReportUrl, {
      'usersrno': usersrno,
      'from_date': fromDate,
      'to_date': toDate,
    });

    if (res['status'] == 0 && res['data'] != null) {
      return List<Map<String, dynamic>>.from(res['data']);
    }

    return [];
  }

  /// ADD ATTENDANCE REGULARIZE
  static Future<Map<String, dynamic>> addAttendanceRegularize({
    required String usersrno,
    required String srno,
  }) async {
    return await _postRequest(ApiConfig.addAttendanceRegularizeUrl, {
      'usersrno': usersrno,
      'srno': srno,
    });
  }

  // MARK ATTENDANCE (Punch In / Out)
  static Future<Map<String, dynamic>> markAttendance({
    required String usersrno,
    required String billDate,
    required String inOut,
    required String lat,
    required String lng,
  }) async {
    return await _postRequest(ApiConfig.markAttendanceUrl, {
      'usersrno': usersrno,
      'bill_date': billDate,
      'in_out': inOut,
      'lat': lat,
      'lng': lng,
    });
  }

  // GET ATTENDANCE STATUS

  static Future<Map<String, dynamic>> getAttendanceStatus({
    required String usersrno,
  }) async {
    return await _postRequest(ApiConfig.getAttendanceStatusUrl, {
      'usersrno': usersrno,
    });
  }

  //  SEND LIVE LOCATION
  static Future<void> sendLiveLocation({
    required String usersrno,
    required String lat,
    required String lng,
  }) async {
    await _postRequest(ApiConfig.addEmployeeLocationUrl, {
      'usersrno': usersrno,
      'lat': lat,
      'lng': lng,
    });
  }

  static Future<List<ProductModel>> getProducts() async {
    final res = await _postRequest(ApiConfig.getProductsUrl, {});

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    }

    return [];
  }

  static Future<TourPlanDetailsModel?> getTourPlanDetails({
    required String tourPlanSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.getTourPlanDetailsUrl, {
      'tour_plan_srno': tourPlanSrNo,
    });

    if (res['status'] == 0 && res['data'] != null && res['data'].isNotEmpty) {
      return TourPlanDetailsModel.fromJson(res['data'][0]);
    }

    return null;
  }

  static Future<TourPlanYearlyDetailsModel?> getTourPlanDetailsYearly({
    required String tourPlanSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.getTourPlanDetailsYearlyUrl, {
      'tour_plan_srno': tourPlanSrNo,
    });

    if (res['status'] == 0 && res['data'] != null && res['data'].isNotEmpty) {
      return TourPlanYearlyDetailsModel.fromJson(res['data'][0]);
    }

    return null;
  }

  static Future<bool> addVisit({
    required String userSrNo,
    required String tourPlanSrNo,
    required String comments,
    String? followupDate,
    required String enquiryGenerated,
    String? productSrNo,
    File? imageFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.addVisitUrl),
      );

      request.fields['usersrno'] = userSrNo;
      request.fields['tour_plan_srno'] = tourPlanSrNo;
      request.fields['comments'] = comments;
      request.fields['enquiry_generated'] = enquiryGenerated;

      if (followupDate != null) {
        request.fields['visit_followup_date'] = followupDate;
      }

      if (enquiryGenerated == "Yes" && productSrNo != null) {
        request.fields['product_srno'] = productSrNo;
      }

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('img1', imageFile.path),
        );
      }

      final response = await request.send();

      final res = await response.stream.bytesToString();
      final data = jsonDecode(res);

      return data['status'] == 0;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addEnquiry({
    required String userSrNo,
    required String customerSrNo,
    required String comments,
    required String productSrNo,
    required String billDate,
    required String followupDate,
  }) async {
    final res = await _postRequest(ApiConfig.addEnquiryUrl, {
      'usersrno': userSrNo,
      'customer_srno': customerSrNo,
      'comments': comments,
      'product_srno': productSrNo,
      'bill_date': billDate,
      'visit_followup_date': followupDate,
    });

    return res['status'] == 0;
  }

  static Future<List<EnquiryModel>> getEnquiry({
    required String usersrno,
    required String fromDate,
    required String toDate,
  }) async {
    final res = await _postRequest(
      "https://digitalspaceinc.com/positive_metering/ws/getEnquiry.php",
      {'usersrno': usersrno, 'from_date': fromDate, 'to_date': toDate},
    );

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => EnquiryModel.fromJson(e))
          .toList();
    }

    return [];
  }

  static Future<EnquiryDetailModel?> getEnquiryDetail({
    required String enquirySrNo,
  }) async {
    final res = await _postRequest(
      "https://digitalspaceinc.com/positive_metering/ws/getEnquiryDetail.php",
      {'enquirysrno': enquirySrNo},
    );

    if (res['status'] == 0 && res['data'] != null && res['data'].isNotEmpty) {
      return EnquiryDetailModel.fromJson(res['data'][0]);
    }

    return null;
  }

  static Future<List<EnquiryFollowUpModel>> getEnquiryFollowUp({
    required String usersrno,
    required String fromDate,
    required String toDate,
  }) async {
    final res = await _postRequest(
      "https://digitalspaceinc.com/positive_metering/ws/getEnquiryFollowup.php",
      {'usersrno': usersrno, 'from_date': fromDate, 'to_date': toDate},
    );

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => EnquiryFollowUpModel.fromJson(e))
          .toList();
    }
    return [];
  }

  static Future<List<VisitFollowUpModel>> getVisitFollowUp({
    required String usersrno,
    required String fromDate,
    required String toDate,
  }) async {
    final res = await _postRequest(
      "https://digitalspaceinc.com/positive_metering/ws/getVisitFollowup.php",
      {'usersrno': usersrno, 'from_date': fromDate, 'to_date': toDate},
    );

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => VisitFollowUpModel.fromJson(e))
          .toList();
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> getStatus() async {
    final response = await http.post(
      Uri.parse(
        "https://digitalspaceinc.com/positive_metering/ws/getStatus.php",
      ),
    );

    final json = jsonDecode(response.body);

    if (json['status'] == 0) {
      return List<Map<String, dynamic>>.from(json['data']);
    } else {
      return [];
    }
  }

  static Future<bool> addFollowupEnquiry({
    required String enquirySrNo,
    required String userSrNo,
    required String comments,
    required String customerSrNo,
    required String visitDate,
    required String statusSrNo,
    required String nextFollowup,
  }) async {
    final response = await http.post(
      Uri.parse(
        "https://digitalspaceinc.com/positive_metering/ws/addFollowupEnquiry.php",
      ),
      body: {
        "enquirysrno": enquirySrNo,
        "usersrno": userSrNo,
        "comments": comments,
        "customer_srno": customerSrNo,
        "visit_followup_date": visitDate,
        "status_srno": statusSrNo,
        "next_followup": nextFollowup,
      },
    );

    return jsonDecode(response.body)['status'] == 0;
  }

  static Future<bool> addFollowupVisit({
    required String tourPlanSrNo,
    required String userSrNo,
    required String comments,
    required String customerSrNo,
    required String visitDate,
    required String statusSrNo,
    required String nextFollowup,
    String? enquiryGenerated,
    String? productSrNo,
  }) async {
    final response = await http.post(
      Uri.parse(
        "https://digitalspaceinc.com/positive_metering/ws/addFollowupVisits.php",
      ),
      body: {
        "tour_plan_srno": tourPlanSrNo,
        "usersrno": userSrNo,
        "comments": comments,
        "customer_srno": customerSrNo,
        "visit_followup_date": visitDate,
        "status_srno": statusSrNo,
        "next_followup": nextFollowup,

        if (enquiryGenerated != null) "enquiry_generated": enquiryGenerated,

        if (enquiryGenerated == "Yes" && productSrNo != null)
          "product_srno": productSrNo,
      },
    );

    return jsonDecode(response.body)['status'] == 0;
  }

  static Future<List<Map<String, dynamic>>> getEnquiryFollowupDetails({
    required String enquirySrNo,
  }) async {
    final res = await http.post(
      Uri.parse(
        "https://digitalspaceinc.com/positive_metering/ws/getEnquiryFollowupDetails.php",
      ),
      body: {"enquirysrno": enquirySrNo},
    );

    final jsonData = json.decode(res.body);
    return List<Map<String, dynamic>>.from(jsonData['data'] ?? []);
  }

  static Future<List<Map<String, dynamic>>> getVisitFollowupDetails({
    required String tourPlanSrNo,
  }) async {
    final res = await http.post(
      Uri.parse(
        "https://digitalspaceinc.com/positive_metering/ws/getVisitFollowupDetails.php",
      ),
      body: {"tour_plan_srno": tourPlanSrNo},
    );

    final jsonData = json.decode(res.body);
    return List<Map<String, dynamic>>.from(jsonData['data'] ?? []);
  }
}
