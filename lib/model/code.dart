// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

enum Category {
  freezing, //congelar
  protect, //proteger
  pay, //pagar
  receive, //receber
  stage, //prova
}

final userCodeRef = FirebaseFirestore.instance
    .collection("Code")
    .withConverter<Code>(
        fromFirestore: (snapshots, _) => Code.fromJson(snapshots.data()!),
        toFirestore: (userCode, _) => userCode.toJson());

class Code {
  String? id;
  String? token;
  Category? category;
  String? description;
  double? value;
  DateTime? date;
  Code({
    this.id,
    this.token,
    this.category,
    this.description,
    this.value,
    this.date,
  });

  factory Code.fromJson(Map<String, dynamic> json) {
    return Code(
      id: json["id"],
      token: json["token"],
      category: _categoryFromString(json["category"]),
      description: json["description"],
      value: json["value"],
      date: json["date"] != null ? (json["date"] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
        "category": category != null ? _categoryToString(category!) : null,
        "description": description,
        "value": value,
        "date": date != null ? Timestamp.fromDate(date!) : null,
      };

  static String? _categoryToString(Category category) {
    switch (category) {
      case Category.freezing:
        return 'freezing';
      case Category.protect:
        return 'protect';
      case Category.pay:
        return 'pay';
      case Category.receive:
        return 'receive';
      case Category.stage:
        return 'stage';
      default:
        return null;
    }
  }

  static Category? _categoryFromString(String? category) {
    switch (category) {
      case 'freezing':
        return Category.freezing;
      case 'protect':
        return Category.protect;
      case 'pay':
        return Category.pay;
      case 'receive':
        return Category.receive;
      case 'stage':
        return Category.stage;
      default:
        return null;
    }
  }
}
