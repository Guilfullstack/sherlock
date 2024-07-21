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
  String id;
  String token;
  Category category;
  String description;
  int value;
  DateTime? date;
  Code({
    required this.id,
    required this.token,
    required this.category,
    required this.description,
    required this.value,
    this.date,
  });

  factory Code.fromJson(Map<String, dynamic> json) {
    return Code(
      id: json["id"],
      token: json["token"],
      category: json["category"],
      description: json["description"],
      value: json["value"],
      date: json["date"] != null ? (json["date"] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
        "category": category,
        "description": description,
        "value": value,
        "date": date != null ? Timestamp.fromDate(date!) : null,
      };
}
