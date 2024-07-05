// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

final userAdmRef = FirebaseFirestore.instance
    .collection("Adm")
    .withConverter<UserAdm>(
        fromFirestore: (snapshots, _) => UserAdm.fromJson(snapshots.data()!),
        toFirestore: (userAdm, _) => userAdm.toJson());

class UserAdm {
  String? id;
  String? login;
  String? password;
  String? name;
  DateTime? date;

  UserAdm({
    this.id,
    this.login,
    this.password,
    this.date,
  });

  factory UserAdm.fromJson(Map<String, dynamic> json) {
    return UserAdm(
      id: json["id"],
      login: json["login"],
      password: json["password"],
      date: json["date"] != null ? (json["date"] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "login": login,
        "password": password,
        "date": date?.toIso8601String(),
      };
}
