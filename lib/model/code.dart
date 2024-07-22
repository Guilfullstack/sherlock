// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'code.g.dart'; // Referência para o arquivo gerado

final userCodeRef = FirebaseFirestore.instance
    .collection("Code")
    .withConverter<Code>(
        fromFirestore: (snapshots, _) => Code.fromJson(snapshots.data()!),
        toFirestore: (userCode, _) => userCode.toJson());

@HiveType(typeId: 2)
class Code extends HiveObject {
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
  double? value;

  @HiveField(6)
  DateTime? date;

  Code({
    this.id,
    this.token,
    this.category,
    this.description,
    this.puzzle,
    this.value,
    this.date,
  });

  factory Code.fromJson(Map<String, dynamic> json) {
    return Code(
      id: json["id"],
      token: json["token"],
      category: categoryFromString(json["category"]),
      description: json["description"],
      puzzle: json['puzzle'],
      value: json["value"],
      date: json["date"] != null ? (json["date"] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
        "category": category != null ? categoryToString(category!) : null,
        "description": description,
        "puzzle": puzzle,
        "value": value,
        "date": date != null ? Timestamp.fromDate(date!) : null,
      };

  static String? categoryToString(Category category) {
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
      default:
        return null;
    }
  }

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

@HiveType(typeId: 3)
enum Category {
  @HiveField(0)
  freezing,

  @HiveField(1)
  protect,

  @HiveField(2)
  pay,

  @HiveField(3)
  receive,

  @HiveField(4)
  stage,
}
