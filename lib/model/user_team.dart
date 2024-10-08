import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import 'package:sherlock/controller/play_controller.dart';

part 'user_team.g.dart'; // Referência para o arquivo gerado

PlayController playController = PlayController();

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

  @HiveField(8)
  List? listMembers;

  @HiveField(9)
  bool? useCardFrezee;

  @HiveField(10)
  bool? useCardProtect;

  @HiveField(11)
  bool? isLoged;
  @HiveField(12)
  bool? isPrisionBreak;
  @HiveField(13)
  bool? isPayCardFrezee;
  @HiveField(14)
  bool? isPayCardProtected;

  @HiveField(15)
  bool? useCardLaCasaDePapel;
  @HiveField(16)
  bool? isPayCardLaCasaDePapel;

  UserTeam(
      {this.id,
      this.login,
      this.password,
      this.name,
      this.date,
      this.status,
      this.credit,
      this.listTokenDesbloqued,
      this.listMembers,
      this.useCardFrezee,
      this.useCardProtect,
      this.useCardLaCasaDePapel,
      this.isLoged,
      this.isPrisionBreak,
      this.isPayCardFrezee,
      this.isPayCardProtected,
      this.isPayCardLaCasaDePapel});

  factory UserTeam.fromJson(dynamic json) {
    return UserTeam(
        id: json["id"],
        login: json["login"],
        password: json["password"],
        name: json["name"],
        date:
            json["date"] != null ? (json["date"] as Timestamp).toDate() : null,
        status: playController.statusFromString(json["status"] as String?),
        credit: (json["credit"] as num?)?.toDouble(),
        listTokenDesbloqued:
            List<String>.from(json["listTokenDesbloqued"] ?? []),
        listMembers: List.from(json["listMembers"] ?? []),
        useCardFrezee: json["useCardFrezee"],
        useCardProtect: json["useCardProtect"],
        useCardLaCasaDePapel: json['useCardLaCasaDePapel'],
        isLoged: json["isLoged"],
        isPrisionBreak: json["isPrisionBreak"],
        isPayCardFrezee: json["isPayCardFrezee"],
        isPayCardProtected: json["isPayCardProtected"],
        isPayCardLaCasaDePapel: json['isPayCardLaCasaDePapel']);
  }

  dynamic toJson() => {
        "id": id,
        "login": login,
        "password": password,
        "name": name,
        "date": date != null ? Timestamp.fromDate(date!) : null,
        "status":
            status != null ? playController.statusToString(status!) : null,
        "credit": credit,
        "listTokenDesbloqued": listTokenDesbloqued,
        "listMembers": listMembers,
        "useCardFrezee": useCardFrezee,
        "useCardProtect": useCardProtect,
        "useCardLaCasaDePapel": useCardLaCasaDePapel,
        "isLoged": isLoged,
        "isPrisionBreak": isPrisionBreak,
        "isPayCardFrezee": isPayCardFrezee,
        "isPayCardProtected": isPayCardProtected,
        "isPayCardLaCasaDePapel": isPayCardLaCasaDePapel,
      };
}

@HiveType(typeId: 1)
enum Status {
  @HiveField(0)
  // ignore: constant_identifier_names
  Jogando,

  @HiveField(1)
  // ignore: constant_identifier_names
  Congelado,

  @HiveField(2)
  // ignore: constant_identifier_names
  Protegido,
}
