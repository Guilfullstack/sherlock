// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

final userStaffRef = FirebaseFirestore.instance
    .collection("Staff")
    .withConverter<UserStaff>(
        fromFirestore: (snapshots, _) => UserStaff.fromJson(snapshots.data()!),
        toFirestore: (userStaff, _) => userStaff.toJson());

class UserStaff {
  String? id;
  String? login;
  String? password;
  String? office;
  List<String>? listCode;
  DateTime? date;

  UserStaff({
    this.id,
    this.login,
    this.password,
    this.office,
    this.listCode,
    this.date,
  });

  factory UserStaff.fromJson(Map<String, dynamic> json) {
    return UserStaff(
      id: json["id"],
      login: json["login"],
      password: json["password"],
      office: json['office'],
      listCode: List<String>.from(json["listCode"] ?? []),
      date: json["date"] != null ? (json["date"] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "login": login,
        "password": password,
        "office": office,
        "listCode": listCode,
        "date": date != null ? Timestamp.fromDate(date!) : null,
      };
}
