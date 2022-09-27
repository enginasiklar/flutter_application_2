import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  UserModel({
    required this.date,
    required this.close,
  });

  String date;
  Double close;
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        date: json["date"],
        close: json["close"],
      );

  Map<String, dynamic> toJson() => {
        "name": date,
        "value": close,
      };
}
