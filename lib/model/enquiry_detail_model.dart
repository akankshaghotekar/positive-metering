class EnquiryDetailModel {
  final String enquirySrNo;
  final String billDate;
  final String customerSrNo;
  final String productSrNo;
  final String? followupDate;

  EnquiryDetailModel({
    required this.enquirySrNo,
    required this.billDate,
    required this.customerSrNo,
    required this.productSrNo,
    this.followupDate,
  });

  factory EnquiryDetailModel.fromJson(Map<String, dynamic> json) {
    return EnquiryDetailModel(
      enquirySrNo: json['enquirysrno'],
      billDate: json['bill_date'],
      customerSrNo: json['customer_srno'],
      productSrNo: json['product_srno'],
      followupDate: json['followup_date'],
    );
  }
}
