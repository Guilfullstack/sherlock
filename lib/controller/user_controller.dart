// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sherlock/model/user_adm.dart';
import 'package:sherlock/model/user_team.dart';

class AuthException implements Exception {
  String mensage;

  AuthException(
    this.mensage,
  );
}

class UserController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<UserTeam> addUserTeam(UserTeam userTeam) async {
    DocumentReference<UserTeam> userTeamDoc = userTeamref.doc();
    userTeam.id = userTeamDoc.id;
    userTeam.date = DateTime.now();
    await userTeamDoc.set(userTeam);
    return Future<UserTeam>.value(userTeam);
  }

  Future<UserAdm> addUserAdm(UserAdm userAdm) async {
    DocumentReference<UserAdm> userAdmDoc = userAdmRef.doc();
    userAdm.id = userAdmDoc.id;
    userAdm.date = DateTime.now();
    await userAdmDoc.set(userAdm);
    return Future<UserAdm>.value(userAdm);
  }

  /*
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isLoading = true;
  LoginController() {
    autcheck();
  }

  autcheck() {
    _auth.authStateChanges().listen((User? user) {
      user = (user == null ? null : user);
      notifyListeners();
    });
  }

  getUser() {
    user = _auth.currentUser;
    notifyListeners();
  }

  Future<void> registerUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = _auth.currentUser;
      await user?.sendEmailVerification();
      getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-passoword") {
        throw AuthException('A senha muito fraca');
      } else if (e.code == "email-already-in-use") {
        throw AuthException('Email já está cadastrado');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  logOut() async {
    await _auth.signOut();
    getUser();
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Login successful
      print('User logged in: ${userCredential.user?.email}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    } catch (e) {
      print(e);
    }
  }*/
}
