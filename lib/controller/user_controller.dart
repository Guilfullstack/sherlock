// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sherlock/model/user_adm.dart';
import 'package:sherlock/model/user_team.dart';
import 'package:sherlock/view/page/home_page.dart';

class AuthException implements Exception {
  String mensage;

  AuthException(
    this.mensage,
  );
}

class UserController {
  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();
  UserAdm? userAdm;
  UserTeam? userTeam;

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

  Future<void> loginSystem(
      BuildContext context, String login, String password) async {
    try {
      final snaphotAdm = await userAdmRef
          .where("login", isEqualTo: login)
          .where("password", isEqualTo: password)
          .limit(1)
          .get();
      if (snaphotAdm.docs.isNotEmpty) {
        debugPrint("Vai para página ControlPanel");
      } else {
        final snaphotTeam = await userTeamref
            .where("login", isEqualTo: login)
            .where("password", isEqualTo: password)
            .limit(1)
            .get();
        if (snaphotTeam.docs.isNotEmpty) {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
                'Usuário não encontrado\nVerifique suas credenciais e tente novamente.'),
          ));
          /*
          showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Usuário não encontrado'),
                content:
                    const Text('Verifique suas credenciais e tente novamente.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Fecha o AlertDialog
                    },
                  ),
                ],
              );
            },
          );*/
        }
      }
    } catch (e) {
      debugPrint('Erro: $e.toString()');
    }
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
