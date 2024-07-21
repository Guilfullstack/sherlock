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
  DateTime? date;
  Stage({
    required this.id,
    required this.token,
    required this.description,
    this.date,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      id: json["id"],
      token: json["token"],
      description: json["description"],
      date: json["date"] != null ? (json["date"] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
        "description": description,
        "date": date != null ? Timestamp.fromDate(date!) : null,
      };
}
