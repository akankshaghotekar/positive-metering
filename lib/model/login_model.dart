class LoginModel {
  final String userSrNo;
  final String name;
  final String email;
  final String? gender;
  final String regionSrNo;
  final String subRegionSrNo;

  LoginModel({
    required this.userSrNo,
    required this.name,
    required this.email,
    this.gender,
    required this.regionSrNo,
    required this.subRegionSrNo,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'][0];

    return LoginModel(
      userSrNo: data['usersrno'],
      name: data['name'],
      email: data['email'],
      gender: data['gender'],
      regionSrNo: data['region_srno'],
      subRegionSrNo: data['subregion_srno'],
    );
  }
}
