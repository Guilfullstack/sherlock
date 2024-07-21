import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sherlock/model/code.dart';

class PlayController extends ChangeNotifier {
  final GlobalKey<FormState> formKeyPlay = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController id = TextEditingController();
  final TextEditingController token = TextEditingController();
  final TextEditingController category = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController value = TextEditingController();

  Future<Code> addCode(Code code) async {
    try {
      DocumentReference<Code> codeDoc = userCodeRef.doc();
      code.id = codeDoc.id;
      code.date = DateTime.now();
      await codeDoc.set(code);
      notifyListeners();
      return Future<Code>.value(code);
    } catch (e) {
      print(e);
    }
    return code;
  }

  Stream<List<Code>> get codeStream {
    return _firestore.collection('Code').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Code.fromJson(doc.data());
      }).toList();
    });
  }

  Future removePlay(int category, String id) async {
    switch (category) {
      case 0:
        await userCodeRef.doc(id).delete();
        break;
      // case 1:
      //   await userAdmRef.doc(id).delete();
      //   break;
      // case 2:
      //   await userStaffRef.doc(id).delete();
      //   break;
      default:
    }

    //listTeamn.isEmpty ? null : listTeamn.removeWhere((team) => team.id == id);
    //notifyListeners();
  }
}
