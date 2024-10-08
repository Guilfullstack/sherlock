// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

final historyRef = FirebaseFirestore.instance
    .collection("History")
    .withConverter<History>(
        fromFirestore: (snapshots, _) => History.fromJson(snapshots.data()!),
        toFirestore: (history, _) => history.toJson());

class History {
  String? id;
  String? idTeam;
  String? description;
  DateTime? date;

  History({
    this.id,
    this.idTeam,
    this.description,
    this.date,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json["id"],
      idTeam: json['idTeam'],
      description: json['description'],
      date: json["date"] != null ? (json["date"] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "idTeam": idTeam,
        "description": description,
        "date": date != null ? Timestamp.fromDate(date!) : null,
      };
}
