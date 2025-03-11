import 'dart:convert';

List<UserData> userDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => UserData.fromJson(item)).toList();
}

String userDataToJson(UserData? data) => json.encode(data!.toJson());

class UserData {
  const UserData({
    this.user_id,
    this.mobile,
  });

  final int? user_id;
  final String? mobile;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        user_id: int.tryParse(json['user_id'].toString()) ?? 0,
        mobile: json['mobile'] as String?,
      );

  Map<String, dynamic> toJson() => {
        "user_id": user_id,
        "mobile": mobile,
      };
}
