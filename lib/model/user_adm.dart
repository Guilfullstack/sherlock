// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

final userAdmref = FirebaseFirestore.instance
    .collection("Adm")
    .withConverter<UserAdm>(
        fromFirestore: (snapshots, _) => UserAdm.fromJson(snapshots.data()),
        toFirestore: (useradm, _) => useradm.toJson());

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

  factory UserAdm.fromJson(dynamic json) {
    return UserAdm(
      id: json["id"],
      login: json["login"],
      password: json["password"],
      date: json["date"],
    );
  }

  dynamic toJson() => {"id": id, "login": id, "password": id, "date": date};
}
