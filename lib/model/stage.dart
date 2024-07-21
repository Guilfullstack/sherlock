// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
final userStageRef = FirebaseFirestore.instance
    .collection("Stage")
    .withConverter<Stage>(
        fromFirestore: (snapshots, _) => Stage.fromJson(snapshots.data()!),
        toFirestore: (userStage, _) => userStage.toJson());
class Stage {
  String id;
  String token;
  String description;
  bool isUnlocked;
  DateTime? date;
  Stage({
    required this.id,
    required this.token,
    required this.description,
    required this.isUnlocked,
    this.date,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      id: json["id"],
      token: json["token"],
      description: json["description"],
      isUnlocked: json['isUnlocked'],
      date: json["date"] != null ? (json["date"] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
        "description": description,
        'isUnlocked':isUnlocked,
        "date": date != null ? Timestamp.fromDate(date!) : null,
      };
}
