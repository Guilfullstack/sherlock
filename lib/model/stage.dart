// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:sherlock/model/code.dart';
part 'stage.g.dart'; // Arquivo gerado automaticamente pelo build_runner

final userStageRef = FirebaseFirestore.instance
    .collection("Stage")
    .withConverter<Stage>(
        fromFirestore: (snapshots, _) => Stage.fromJson(snapshots.data()!),
        toFirestore: (userCode, _) => userCode.toJson());

@HiveType(typeId: 5)
class Stage extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? token;

  @HiveField(2)
  Category? category;

  @HiveField(3)
  String? description;

  @HiveField(4)
  String? puzzle;

  @HiveField(5)
  DateTime? date;

  Stage({
    this.id,
    this.token,
    this.category,
    this.description,
    this.puzzle,
    this.date,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      id: json["id"],
      token: json["token"],
      category: categoryFromString(json["category"]),
      description: json["description"],
      puzzle: json['puzzle'],
      date: json["date"] != null ? (json["date"] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
        "category": category != null ? categoryToString(category!) : null,
        "description": description,
        "puzzle": puzzle,
        "date": date != null ? Timestamp.fromDate(date!) : null,
      };

  // Converte Category para String
  static String? categoryToString(Category? category) {
    if (category == null) return null;
    switch (category) {
      case Category.freezing:
        return 'Congelar';
      case Category.protect:
        return 'Escudo';
      case Category.pay:
        return 'Subtrair';
      case Category.receive:
        return 'Adicionar';
      case Category.stage:
        return 'Prova';
    }
  }

  // Converte String para Category
  static Category? categoryFromString(String? category) {
    switch (category) {
      case 'Congelar':
        return Category.freezing;
      case 'Escudo':
        return Category.protect;
      case 'Subtrair':
        return Category.pay;
      case 'Adicionar':
        return Category.receive;
      case 'Prova':
        return Category.stage;
      default:
        return null;
    }
  }
}
