// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthException implements Exception {
  String mensage;

  AuthException(
    this.mensage,
  );
}

class LoginController extends ChangeNotifier {
  TextEditingController? email;
  TextEditingController? password;

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
  }
}
