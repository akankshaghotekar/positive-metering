class TourPlanModel {
  final String tourPlanSrNo;
  final String companyName;
  final String regionName;
  final String? kajal;
  final String? ravi;
  final String? malhar;
  final String status;

  TourPlanModel({
    required this.tourPlanSrNo,
    required this.companyName,
    required this.regionName,
    this.kajal,
    this.ravi,
    this.malhar,
    required this.status,
  });

  factory TourPlanModel.fromJson(Map<String, dynamic> json) {
    return TourPlanModel(
      tourPlanSrNo: json['tour_plan_srno'],
      companyName: json['company_name'],
      regionName: json['region_name'],
      kajal: json['kajal'],
      ravi: json['ravi'],
      malhar: json['malhar'],
      status: json['status'],
    );
  }
}
