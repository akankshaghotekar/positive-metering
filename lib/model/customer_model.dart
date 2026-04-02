class CustomerModel {
  final String customerSrNo;
  final String regionSrNo;
  final String subregionSrNo;
  final String customerTypeSrNo;
  final String groupSrNo;
  final String companyName;
  final String customerName;
  final String mobileNo;

  CustomerModel({
    required this.customerSrNo,
    required this.regionSrNo,
    required this.subregionSrNo,
    required this.customerTypeSrNo,
    required this.groupSrNo,
    required this.companyName,
    required this.customerName,
    required this.mobileNo,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerSrNo: json['customer_srno'],
      regionSrNo: json['region_srno'],
      subregionSrNo: json['subregion_srno'],
      customerTypeSrNo: json['customer_type_srno'],
      groupSrNo: json['group_srno'],
      companyName: json['company_name'],
      customerName: json['customer_name'],
      mobileNo: json['mobile_no'],
    );
  }
}
