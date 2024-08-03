// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sherlock/controller/play_controller.dart';
import 'package:sherlock/model/code.dart';
import 'package:sherlock/model/stage.dart';
import 'package:sherlock/model/user_adm.dart';
import 'package:sherlock/model/user_staf.dart';
import 'package:sherlock/model/user_team.dart';
import 'package:sherlock/view/page/controller_panel_page.dart';
import 'package:sherlock/view/page/home_page.dart';
import 'package:sherlock/view/page/login_page.dart';
import 'package:sherlock/view/page/staff_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
  TextEditingController passwordComfirm = TextEditingController();
  TextEditingController nameEdit = TextEditingController();
  TextEditingController loginEdit = TextEditingController();
  TextEditingController passwordEdit = TextEditingController();
  TextEditingController passwordEditComfirm = TextEditingController();
  TextEditingController addMember = TextEditingController();
  TextEditingController addMemberEdit = TextEditingController();
  final TextEditingController memberId = TextEditingController();

  late List membersTeam = [];
  late List membersTeamEdit = [];
  List<UserTeam> listTeamn = [];
  bool loading = false;
  bool update = false;
  bool history = false;

  StreamSubscription<QuerySnapshot>? listTeamSubscription;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PlayController playController = PlayController();

  Future<UserTeam> addUserTeam(UserTeam userTeam) async {
    DocumentReference<UserTeam> userTeamDoc = userTeamref.doc();
    userTeam.id = userTeamDoc.id;
    userTeam.date = DateTime.now();
    await userTeamDoc.set(userTeam);
    listTeamn.insert(0, userTeam);
    login.clear();
    password.clear();
    passwordComfirm.clear();
    notifyListeners();
    return Future<UserTeam>.value(userTeam);
  }

  Future<UserAdm> addUserAdm(UserAdm userAdm) async {
    DocumentReference<UserAdm> userAdmDoc = userAdmRef.doc();
    userAdm.id = userAdmDoc.id;
    userAdm.date = DateTime.now();
    await userAdmDoc.set(userAdm);
    login.clear();
    password.clear();
    passwordComfirm.clear();
    notifyListeners();
    return Future<UserAdm>.value(userAdm);
  }

  Future<UserStaff> addUserStaff(UserStaff userStaff) async {
    DocumentReference<UserStaff> userStaffDoc = userStaffRef.doc();
    userStaff.id = userStaffDoc.id;
    userStaff.date = DateTime.now();
    await userStaffDoc.set(userStaff);
    login.clear();
    password.clear();
    passwordComfirm.clear();
    notifyListeners();
    return Future<UserStaff>.value(userStaff);
  }

/*
  Future<void> logout(BuildContext context) async {
    // Limpar SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (kIsWeb) {
      // Navegar para a página de login se for Web
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      // Limpar Hive e então navegar para a página de login se não for Web
      try {
        var userTeamBox = Hive.box<UserTeam>('userTeamBox');
        await userTeamBox.clear();
      } catch (e) {
        print('Error clearing Hive box: $e');
      }

      // Navegar para a página de login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }
*/
  Future<void> logout(BuildContext context) async {
    // Limpar SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (kIsWeb) {
      // Navegar para a página de login se for Web
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      // Limpar Hive e então navegar para a página de login se não for Web
      try {
        var userTeamBox = Hive.box<UserTeam>('userTeamBox');
        await userTeamBox.clear();
        print('userTeamBox limpo com sucesso.');

        var codeBox = Hive.box<Code>('codeBox');
        await codeBox.clear();
        print('codeBox limpo com sucesso.');

        var stageBox = Hive.box<Stage>('stageBox');
        await stageBox.clear();
        print('stageBox limpo com sucesso.');
      } catch (e) {
        print('Erro ao limpar a caixa do Hive: $e');
      }

      // Navegar para a página de login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Future<void> _saveLoginState(
      bool isLoggedIn, String login, String category) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.setString('login', login);
    await prefs.setString('category', category);
  }

  Future<void> saveUserHive(UserTeam user) async {
    var box = Hive.box<UserTeam>('userTeamBox');
    await box.put('currentUser', user);
  }

  Future<UserTeam?> getUserHive() async {
    var box = Hive.box<UserTeam>('userTeamBox');
    return box.get('currentUser');
  }

  Future<void> loginSystem(
      BuildContext context, String login, String password) async {
    try {
      final snapshotAdm = await userAdmRef
          .where("login", isEqualTo: login)
          .where("password", isEqualTo: password)
          .limit(1)
          .get();

      if (snapshotAdm.docs.isNotEmpty) {
        await _saveLoginState(true, login, 'Adm');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const ControllerPanelPage()));
      } else {
        final snapshotTeam = await userTeamref
            .where("login", isEqualTo: login)
            .where("password", isEqualTo: password)
            .limit(1)
            .get();

        if (snapshotTeam.docs.isNotEmpty) {
          if (kIsWeb) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Web Platform'),
                  content:
                      const Text('Equipes não tem acesso a plataforma Web'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else {
            await _saveLoginState(true, login, 'Team');
            // Armazena o usuário na caixa do Hive
            final user = UserTeam(
                id: snapshotTeam.docs.first.id,
                login: snapshotTeam.docs.first.data().login,
                password: snapshotTeam.docs.first.data().password,
                name: snapshotTeam.docs.first.data().name,
                date: snapshotTeam.docs.first.data().date,
                status: snapshotTeam.docs.first.data().status,
                credit: snapshotTeam.docs.first.data().credit,
                listTokenDesbloqued:
                    snapshotTeam.docs.first.data().listTokenDesbloqued);
            saveUserHive(user);

            List<Code> codeList = await playController.getCodeList();
            playController.saveCodeListToHive(codeList);

            List<Stage> stageList = await playController.getStageList();
            playController.saveStageListToHive(stageList);
            List<Stage> l2 = await playController.getStageListFromHive();
            for (Stage stage in l2) {
              print("${stage.description}");
            }
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          }
        } else {
          final snapshotStaff = await userStaffRef
              .where("login", isEqualTo: login)
              .where("password", isEqualTo: password)
              .limit(1)
              .get();

          if (snapshotStaff.docs.isNotEmpty) {
            await _saveLoginState(true, login, 'Staff');
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const StaffPage())); // Substitua 'StaffPage' pela página correta.
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                  'Usuário não encontrado\nVerifique suas credenciais e tente novamente.'),
            ));
          }
        }
      }
    } catch (e) {
      debugPrint('Erro: $e');
    }
  }

  Future removeUser(int category, String id) async {
    switch (category) {
      case 0:
        await userTeamref.doc(id).delete();
        break;
      case 1:
        await userAdmRef.doc(id).delete();
        break;
      case 2:
        await userStaffRef.doc(id).delete();
        break;
      default:
    }

    //listTeamn.isEmpty ? null : listTeamn.removeWhere((team) => team.id == id);
    //notifyListeners();
  }

  Future updateTeams(UserTeam newUserTeam) async {
    try {
      QuerySnapshot querySnapshot =
          await userTeamref.where('id', isEqualTo: newUserTeam.id).get();

      // Função auxiliar para construir dinamicamente o mapa de atualização
      Map<String, dynamic> buildUpdateData(UserTeam userTeam) {
        Map<String, dynamic> data = {};

        if (userTeam.name != null && nameEdit.text.isNotEmpty) {
          data['name'] = nameEdit.text;
        }
        if (userTeam.login != null && loginEdit.text.isNotEmpty) {
          data['login'] = loginEdit.text;
        }
        if (userTeam.password != null && passwordEdit.text.isNotEmpty) {
          data['password'] = passwordEdit.text;
        }
        if (userTeam.listMembers != null) {
          data['listMembers'] = userTeam.listMembers;
        }

        return data;
      }

      if (querySnapshot.docs.isNotEmpty) {
        // Se houver documentos encontrados, atualizar o primeiro documento encontrado
        DocumentSnapshot document = querySnapshot.docs.first;
        Map<String, dynamic> updateData = buildUpdateData(newUserTeam);

        if (updateData.isNotEmpty) {
          await document.reference.update(updateData);
        }
      }
    } catch (e) {
      debugPrint("Erro ao atualizar equipe: $e");
    }
  }

  Future updateAdm(UserAdm newUserAdm) async {
    try {
      QuerySnapshot querySnapshot =
          await userAdmRef.where('id', isEqualTo: newUserAdm.id).get();

      // Função auxiliar para construir dinamicamente o mapa de atualização
      Map<String, dynamic> buildUpdateData(UserAdm userAdm) {
        Map<String, dynamic> data = {};

        if (userAdm.login != null && loginEdit.text.isNotEmpty) {
          data['login'] = loginEdit.text;
        }
        if (userAdm.password != null && passwordEdit.text.isNotEmpty) {
          data['password'] = passwordEdit.text;
        }

        return data;
      }

      if (querySnapshot.docs.isNotEmpty) {
        // Se houver documentos encontrados, atualizar o primeiro documento encontrado
        DocumentSnapshot document = querySnapshot.docs.first;
        Map<String, dynamic> updateData = buildUpdateData(newUserAdm);

        if (updateData.isNotEmpty) {
          await document.reference.update(updateData);
        }
      }
    } catch (e) {
      debugPrint("Erro ao atualizar equipe: $e");
    }
  }

  Future updateStaff(UserStaff newUserStaff) async {
    try {
      QuerySnapshot querySnapshot =
          await userStaffRef.where('id', isEqualTo: newUserStaff.id).get();

      // Função auxiliar para construir dinamicamente o mapa de atualização
      Map<String, dynamic> buildUpdateData(UserStaff userStaff) {
        Map<String, dynamic> data = {};

        if (userStaff.login != null && loginEdit.text.isNotEmpty) {
          data['login'] = loginEdit.text;
        }
        if (userStaff.password != null && passwordEdit.text.isNotEmpty) {
          data['password'] = passwordEdit.text;
        }

        return data;
      }

      if (querySnapshot.docs.isNotEmpty) {
        // Se houver documentos encontrados, atualizar o primeiro documento encontrado
        DocumentSnapshot document = querySnapshot.docs.first;
        Map<String, dynamic> updateData = buildUpdateData(newUserStaff);

        if (updateData.isNotEmpty) {
          await document.reference.update(updateData);
        }
      }
    } catch (e) {
      debugPrint("Erro ao atualizar equipe: $e");
    }
  }

  Stream<List<UserTeam>> get teamStream {
    return _firestore.collection('Teams').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return UserTeam.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<UserAdm>> get admStream {
    return _firestore.collection('Adm').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return UserAdm.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<UserStaff>> get staffStream {
    return _firestore.collection('Staff').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return UserStaff.fromJson(doc.data());
      }).toList();
    });
  }

  Future<List<String>> getListMembers(String teamId) async {
    try {
      // Obtém o documento da coleção 'Teams' pelo ID
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('Teams')
          .doc(teamId)
          .get();

      // Verifica se o documento existe e contém o campo 'listMembers'
      if (docSnapshot.exists) {
        Map data = docSnapshot.data() as Map<String, dynamic>;
        List? listMembers = data['listMembers'] ?? [];

        // Converte a lista de membros para uma lista de strings
        if (listMembers != null) {
          return List<String>.from(listMembers);
        }
      }
      return [];
    } catch (e) {
      debugPrint('Erro ao obter a lista de membros: $e');
      return [];
    }
  }
}
