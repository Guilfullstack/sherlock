// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sherlock/model/user_adm.dart';
import 'package:sherlock/model/user_team.dart';

class AuthException implements Exception {
  String mensage;

  AuthException(
    this.mensage,
  );
}

class UserController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyEditTeam = GlobalKey<FormState>();
  TextEditingController id = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nameEdit = TextEditingController();
  TextEditingController loginEdit = TextEditingController();
  TextEditingController passwordEdit = TextEditingController();
  UserAdm? userAdm;
  UserTeam? userTeam;

  List<UserTeam> listTeamn = [];
  bool loading = false;
  bool update = false;
  bool history = false;

  StreamSubscription<QuerySnapshot>? listTeamSubscription;

  Future<UserTeam> addUserTeam(UserTeam userTeam) async {
    DocumentReference<UserTeam> userTeamDoc = userTeamref.doc();
    userTeam.id = userTeamDoc.id;
    userTeam.date = DateTime.now();
    await userTeamDoc.set(userTeam);
    listTeamn.insert(0, userTeam);
    login.clear();
    password.clear();
    notifyListeners();
    return Future<UserTeam>.value(userTeam);
  }

  Future<UserAdm> addUserAdm(UserAdm userAdm) async {
    DocumentReference<UserAdm> userAdmDoc = userAdmRef.doc();
    userAdm.id = userAdmDoc.id;
    userAdm.date = DateTime.now();
    await userAdmDoc.set(userAdm);
    notifyListeners();
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
        await _saveLoginState(true, login);
        Navigator.pushReplacementNamed(context, '/controll');
      } else {
        final snaphotTeam = await userTeamref
            .where("login", isEqualTo: login)
            .where("password", isEqualTo: password)
            .limit(1)
            .get();
        if (snaphotTeam.docs.isNotEmpty) {
          await _saveLoginState(true, login);
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
                'Usuário não encontrado\nVerifique suas credenciais e tente novamente.'),
          ));
        }
      }
    } catch (e) {
      debugPrint('Erro: $e.toString()');
    }
  }

  Future<void> _saveLoginState(bool isLoggedIn, String login) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.setString('login', login);
  }

/*
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
        /*
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const ControllerPanelPage()),
        );*/
        Navigator.pushReplacementNamed(context, '/controll');
      } else {
        final snaphotTeam = await userTeamref
            .where("login", isEqualTo: login)
            .where("password", isEqualTo: password)
            .limit(1)
            .get();
        if (snaphotTeam.docs.isNotEmpty) {
          /*
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );*/
          Navigator.pushReplacementNamed(context, '/home');
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
  }*/

  Future loadTeams() async {
    final snapshot = await userTeamref.get();
    listTeamn.clear();
    for (var doc in snapshot.docs) {
      listTeamn.add(UserTeam.fromJson(doc));
    }
    notifyListeners();
  }

  Future removeTeams(String id) async {
    await userTeamref.doc(id).delete();
    //listTeamn.isEmpty ? null : listTeamn.removeWhere((team) => team.id == id);
    //notifyListeners();
  }

  Future updateTeams(UserTeam newUserTeam) async {
    try {
      // Encontrar a equipe existente
      int index = listTeamn.indexWhere((team) => team.id == newUserTeam.id);
      if (index != -1) {
        UserTeam oldUserTeam = listTeamn[index];

        // Criar um mapa para os campos que foram alterados
        Map<String, dynamic> updatedFields = {};

        if (oldUserTeam.name != newUserTeam.name) {
          updatedFields['name'] = newUserTeam.name;
        }
        if (oldUserTeam.login != newUserTeam.login) {
          updatedFields['login'] = newUserTeam.login;
        }
        if (oldUserTeam.password != newUserTeam.password) {
          updatedFields['password'] = newUserTeam.password;
        }

        // Se houver campos atualizados, atualize o documento no Firestore
        if (updatedFields.isNotEmpty) {
          await userTeamref.doc(newUserTeam.id).update(updatedFields);
          listTeamn[index] = newUserTeam;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint("Erro ao atualizar equipe: $e");
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<UserTeam>> get teamStream {
    return _firestore.collection('Teams').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return UserTeam.fromJson(doc.data());
      }).toList();
    });
  }

  // subscribeToTeams() {
  //   try {
  //     listTeamSubscription = userAdmRef.snapshots().listen(
  //       (querySnapshot) {
  //         List<UserTeam> trufasAtualizados = querySnapshot.docs
  //             .map((doc) => UserTeam.fromJson(doc.data()))
  //             .toList();

  //         listTeamn = List.from(trufasAtualizados);

  //         listTeamn.clear();
  //         notifyListeners();
  //         print("equipes ${listTeamn.length}");
  //         for (var user in trufasAtualizados) {
  //           listTeamn.add(user);
  //         }
  //       },
  //     );
  //   } catch (e) {
  //     print("Erro ao assinar a coleção: $e");
  //   }
  // }

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
