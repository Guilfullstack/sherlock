import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'user_team.g.dart'; // Referência para o arquivo gerado

final userTeamref = FirebaseFirestore.instance
    .collection("Teams")
    .withConverter<UserTeam>(
        fromFirestore: (snapshots, _) => UserTeam.fromJson(snapshots.data()!),
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

  @HiveField(7)
  List<String>? listTokenDesbloqued;

  UserTeam({
    this.id,
    this.login,
    this.password,
    this.name,
    this.date,
    this.status,
    this.credit,
    this.listTokenDesbloqued,
  });

  factory UserTeam.fromJson(dynamic json) {
    return UserTeam(
      id: json["id"],
      login: json["login"],
      password: json["password"],
      name: json["name"],
      date: json["date"] != null ? (json["date"] as Timestamp).toDate() : null,
      status: json["status"] != null ? Status.values[json["status"]] : null,
      credit: (json["credit"] as num?)?.toDouble(),
      listTokenDesbloqued: List<String>.from(json["listTokenDesbloqued"] ?? []),
    );
  }

  dynamic toJson() => {
        "id": id,
        "login": login,
        "password": password,
        "name": name,
        "date": date != null ? Timestamp.fromDate(date!) : null,
        "status": status?.index,
        "credit": credit,
        "listTokenDesbloqued": listTokenDesbloqued,
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
