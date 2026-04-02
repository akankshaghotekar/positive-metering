import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:positive_metering/model/common_model.dart';
import 'package:positive_metering/model/customer_model.dart';
import 'package:positive_metering/model/login_model.dart';
import 'package:positive_metering/model/tour_plan_model.dart';
import 'package:positive_metering/model/tour_plan_yearly_model.dart';
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
    final res = await _postRequest(
      "https://digitalspaceinc.com/positive_metering/ws/addTourPlanYearly.php",
      {
        'usersrno': userSrNo,
        'customer_srno': customerSrNo,
        'from_date': fromDate,
        'to_date': toDate,
        'tour_type': tourType,
        'visit_call': visitCall,
      },
    );

    return res['status'] == 0;
  }
}
