class TourPlanYearlyModel {
  final String companyName;
  final String regionName;
  final String status;
  final String type;
  final String? kajal;
  final String? ravi;
  final String? malhar;

  TourPlanYearlyModel({
    required this.companyName,
    required this.regionName,
    required this.status,
    required this.type,
    this.kajal,
    this.ravi,
    this.malhar,
  });

  factory TourPlanYearlyModel.fromJson(Map<String, dynamic> json) {
    return TourPlanYearlyModel(
      companyName: json['company_name'],
      regionName: json['region_name'],
      status: json['status'],
      type: json['tour_type'] ?? "Tour",
      kajal: json['kajal'],
      ravi: json['ravi'],
      malhar: json['malhar'],
    );
  }
}
