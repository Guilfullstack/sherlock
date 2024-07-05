import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
enum Status {
  // ignore: constant_identifier_names
  Jogando,
  // ignore: constant_identifier_names
  Conjelado,
  // ignore: constant_identifier_names
  Protegido,
}

final userTeamref = FirebaseFirestore.instance
    .collection("Teams")
    .withConverter<UserTeam>(
        fromFirestore: (snapshots, _) => UserTeam.fromJson(snapshots.data()),
        toFirestore: (userTeam, _) => userTeam.toJson());

class UserTeam {
  String? id;
  String? login;
  String? password;
  String? name;
  DateTime? date;
  Status? status;
  double? credit;

  UserTeam({
    this.id,
    this.login,
    this.password,
    this.name,
    this.date,
    this.status,
    this.credit,
  });

  factory UserTeam.fromJson(dynamic json) {
    return UserTeam(
        id: json["id"],
        login: json["login"],
        password: json["password"],
        name: json["name"],
        date:
            json["date"] != null ? (json["date"] as Timestamp).toDate() : null,
        status: json["status"],
        credit: json["credit"]);
  }

  dynamic toJson() => {
        "id": id,
        "login": id,
        "password": id,
        "name": id,
        "date": date != null ? Timestamp.fromDate(date!) : null,
        "status": status,
        "credit": credit,
      };
}
