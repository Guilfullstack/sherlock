import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'user_team.g.dart'; // Referência para o arquivo gerado

/*
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
      date: json["date"] != null ? (json["date"] as Timestamp).toDate() : null,
      status: json["status"],
      credit: (json["credit"] as num?)?.toDouble(),
    );
  }

  dynamic toJson() => {
        "id": id,
        "login": login,
        "password": password,
        "name": name,
        "date": date != null ? Timestamp.fromDate(date!) : null,
        "status": status,
        "credit": credit,
      };
}
*/

final userTeamref = FirebaseFirestore.instance
    .collection("Teams")
    .withConverter<UserTeam>(
        fromFirestore: (snapshots, _) => UserTeam.fromJson(snapshots.data()),
        toFirestore: (userTeam, _) => userTeam.toJson());

@HiveType(typeId: 0)
class UserTeam extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? login;

  @HiveField(2)
  String? password;

  @HiveField(3)
  String? name;

  @HiveField(4)
  DateTime? date;

  @HiveField(5)
  Status? status;

  @HiveField(6)
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
      date: json["date"] != null ? (json["date"] as Timestamp).toDate() : null,
      status: json["status"],
      credit: (json["credit"] as num?)?.toDouble(),
    );
  }

  dynamic toJson() => {
        "id": id,
        "login": login,
        "password": password,
        "name": name,
        "date": date != null ? Timestamp.fromDate(date!) : null,
        "status": status,
        "credit": credit,
      };
}

@HiveType(typeId: 1)
enum Status {
  @HiveField(0)
  Jogando,

  @HiveField(1)
  Conjelado,

  @HiveField(2)
  Protegido,
}
