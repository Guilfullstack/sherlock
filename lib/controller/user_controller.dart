// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sherlock/controller/play_controller.dart';
import 'package:sherlock/controller/tools_controller.dart';
import 'package:sherlock/model/history.dart';
import 'package:sherlock/model/stage.dart';
import 'package:sherlock/model/user_adm.dart';
import 'package:sherlock/model/user_staf.dart';
import 'package:sherlock/model/user_team.dart';
import 'package:sherlock/view/page/dashboard_panel.dart';
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
  PlayController play = PlayController();
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
  TextEditingController addValueStatus = TextEditingController();
  TextEditingController addValueHistoty = TextEditingController();
  Status statusTeams = Status.Jogando;
  final TextEditingController memberId = TextEditingController();
  final FocusNode addMemberFocusNode = FocusNode();
  late String? selectionStaff;
  String selectionStaffEdit = 'Prova';
  late String? teamIdHistory;
  String teamDropDownHistory = 'Todos';
  Future<void>? protectTimer;

  late List membersTeam = [];
  late List membersTeamEdit = [];
  List<UserTeam> listTeamn = [];
  bool loading = false;
  bool update = false;
  bool history = false;
  // lista provas
  List<String> selectedStage = [];
  List<String> selectedStageEdit = [];
  String? selectedTeam;
  String? selectedTeamId;
  Status? selectedTeamStatus;
  String? selectedTeamName;
  UserTeam? selectedUserTeam;

  StreamSubscription<QuerySnapshot>? listTeamSubscription;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PlayController playController = PlayController();

  final ValueNotifier<bool> _statusUpdateNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _protectUpdateNotifier = ValueNotifier<bool>(false);

  ValueNotifier<bool> get statusUpdateNotifier => _statusUpdateNotifier;
  ValueNotifier<bool> get protectUpdateNotifier => _protectUpdateNotifier;

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
    selectedStage.clear();
    notifyListeners();
    return Future<UserStaff>.value(userStaff);
  }

  Future<History> addHistory(History history) async {
    DocumentReference<History> hystoryDoc = historyRef.doc();
    history.id = hystoryDoc.id;
    history.date = DateTime.now();
    await hystoryDoc.set(history);
    notifyListeners();
    return Future<History>.value(history);
  }

  Future<void> logout(BuildContext context) async {
    // Limpar SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (kIsWeb) {
      // Navegar para a página de login se for Web
      if (context.mounted) {
        ToolsController.navigate(context, LoginPage());
      }
    } else {
      // Limpar Hive e então navegar para a página de login se não for Web
      UserTeam? user = await getUserHive();
      user!.isLoged = false;
      await updateTeams(user);
      addHistory(History(
          idTeam: user.id,
          description: "Equipe \"${user.name}\" saiu do jogo"));
      try {
        var userTeamBox = Hive.box<UserTeam>('userTeamBox');
        await userTeamBox.clear();
        var stageBox = Hive.box<Stage>('stageBox');
        await stageBox.clear();
      } catch (e) {
        debugPrint('Erro ao limpar a caixa do Hive: $e');
      }
      if (context.mounted) {
        ToolsController.navigate(context, LoginPage());
      }
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
        if (context.mounted) {
          ToolsController.navigate(context, const DashboardPanel());
        }
      } else {
        final snapshotTeam = await userTeamref
            .where("login", isEqualTo: login)
            .where("password", isEqualTo: password)
            .limit(1)
            .get();

        if (snapshotTeam.docs.isNotEmpty) {
          if (kIsWeb) {
            if (context.mounted) {
              ToolsController.dialogMensage(context, "Web Platform",
                  "Equipes não tem acesso a plataforma Web");
            }
          } else {
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
                    snapshotTeam.docs.first.data().listTokenDesbloqued,
                useCardFrezee: snapshotTeam.docs.first.data().useCardFrezee,
                useCardProtect: snapshotTeam.docs.first.data().useCardProtect,
                isLoged: snapshotTeam.docs.first.data().isLoged);
            if (user.isLoged == true) {
              if (context.mounted) {
                ToolsController.dialogMensage(
                    context, "Erro", "Usuário já está logado");
              }
            } else {
              user.isLoged = true;
              await updateTeams(user);
              addHistory(History(
                  idTeam: user.id,
                  description: "Equipe \"${user.name}\" entrou no jogo"));
              saveUserHive(user);
              await _saveLoginState(true, login, 'Team');

              List<Stage> stageList = await playController.getStageList();
              await playController.saveStageListToHive(stageList);

              if (context.mounted) {
                ToolsController.navigate(context, const HomePage());
              }
            }
          }
        } else {
          final snapshotStaff = await userStaffRef
              .where("login", isEqualTo: login)
              .where("password", isEqualTo: password)
              .limit(1)
              .get();

          if (snapshotStaff.docs.isNotEmpty) {
            await _saveLoginState(true, login, 'Staff');
            if (context.mounted) {
              ToolsController.navigate(context, const StaffPage());
            }
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text(
                    'Usuário não encontrado\nVerifique suas credenciais e tente novamente.'),
              ));
            }
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
      case 3:
        await historyRef.doc(id).delete();
      default:
    }
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
        if (userTeam.credit != null && addValueStatus.text.isNotEmpty) {
          data['credit'] = double.parse(addValueStatus.text);
        }
        if (userTeam.password != null && passwordEdit.text.isNotEmpty) {
          data['password'] = passwordEdit.text;
        }
        if (userTeam.listMembers != null) {
          data['listMembers'] = userTeam.listMembers;
        }
        if (userTeam.status != null) {
          data['status'] = play.statusToString(statusTeams);
        }
        if (userTeam.listTokenDesbloqued != null) {
          data['listTokenDesbloqued'] = newUserTeam.listTokenDesbloqued;
        }
        if (userTeam.useCardFrezee != null) {
          data['useCardFrezee'] = newUserTeam.useCardFrezee;
        }
        if (userTeam.useCardProtect != null) {
          data['useCardProtect'] = newUserTeam.useCardProtect;
        }
        if (userTeam.isLoged != null) {
          data['isLoged'] = newUserTeam.isLoged;
        }
        return data;
      }

      if (querySnapshot.docs.isNotEmpty) {
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

  Future updateHystory(History newHystory) async {
    try {
      QuerySnapshot querySnapshot =
          await historyRef.where('id', isEqualTo: newHystory.id).get();

      Map<String, dynamic> buildUpdateData(History history) {
        Map<String, dynamic> data = {};

        if (history.description != null && loginEdit.text.isNotEmpty) {
          data['description'] = loginEdit.text;
        }

        return data;
      }

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot document = querySnapshot.docs.first;
        Map<String, dynamic> updateData = buildUpdateData(newHystory);

        if (updateData.isNotEmpty) {
          await document.reference.update(updateData);
        }
      }
    } catch (e) {
      debugPrint("Erro ao atualizar historico: $e");
    }
  }

  Future updateStaff(UserStaff newUserStaff) async {
    try {
      QuerySnapshot querySnapshot =
          await userStaffRef.where('id', isEqualTo: newUserStaff.id).get();

      Map<String, dynamic> buildUpdateData(UserStaff userStaff) {
        Map<String, dynamic> data = {};

        if (userStaff.login != null && loginEdit.text.isNotEmpty) {
          data['login'] = loginEdit.text;
        }
        if (userStaff.password != null && passwordEdit.text.isNotEmpty) {
          data['password'] = passwordEdit.text;
        }
        if (userStaff.office != null && selectionStaffEdit.isNotEmpty) {
          data['office'] = selectionStaffEdit;
        }
        if (userStaff.listCode != null) {
          data['listCode'] = selectedStageEdit;
        }

        return data;
      }

      if (querySnapshot.docs.isNotEmpty) {
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

  Stream<List<History>> get historyStream {
    if (teamDropDownHistory == 'Todos' || teamIdHistory == null) {
      return _firestore
          .collection('History')
          .orderBy('date', descending: true)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return History.fromJson(doc.data());
        }).toList();
      });
    } else {
      debugPrint('Filtrando pelo ID da equipe: $teamIdHistory');
      return _firestore
          .collection('History')
          .where('idTeam', isEqualTo: teamIdHistory)
          .orderBy('date', descending: true)
          .snapshots()
          .map((querySnapshot) {
        debugPrint('Documentos retornados: ${querySnapshot.docs.length}');
        return querySnapshot.docs.map((doc) {
          return History.fromJson(doc.data());
        }).toList();
      });
    }
  }

  void updateTeamIdHistory(String? newTeamId) {
    teamIdHistory = newTeamId;
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM').add_Hms().format(date);
  }

  Future<List<String>> getListMembers(String teamId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('Teams')
          .doc(teamId)
          .get();

      if (docSnapshot.exists) {
        Map data = docSnapshot.data() as Map<String, dynamic>;
        List? listMembers = data['listMembers'] ?? [];

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

  void startStatusUpdateTimer(UserTeam team, BuildContext context) {
    _statusUpdateNotifier.value = true;

    if (selectedUserTeam!.useCardFrezee == false) {
      statusTeams = selectedTeamStatus == Status.Protegido
          ? Status.Jogando
          : Status.Congelado;
      final userTeam = UserTeam(
        id: team.id,
        status: statusTeams,
      );
      final history = History(
          idTeam: selectedTeamId,
          description: selectedTeamStatus == Status.Protegido
              ? "Equipe \"${team.name}\" está com proteção e não pode ser congelado pela Equipe \"$selectedTeam\""
              : "Equipe\" $selectedTeam\" congelou \"${team.name}\"");
      addHistory(history);
      updateTeams(UserTeam(id: selectedTeamId, useCardFrezee: true));
      updateTeams(userTeam);
      if (selectedTeamStatus == Status.Jogando) {
        Future.delayed(const Duration(seconds: 10), () async {
          if (_statusUpdateNotifier.value) {
            await updateTeamStatus(team);
            _statusUpdateNotifier.value = false;
          }
        });
      } else if (selectedTeamStatus == Status.Protegido) {
        Status status = Status.Jogando;
        updateTeams(UserTeam(id: team.id, status: status));
      }
    } else {
      ToolsController.scafoldMensage(
          context, Colors.redAccent, "A equipe já usou cartão de congelament");
    }
  }

  void startProtectUpdateTimer(UserTeam team, BuildContext context) {
    _protectUpdateNotifier.value =
        true; // Notifica que o status precisa ser atualizado
    statusTeams = Status.Protegido;
    if (team.useCardProtect == false) {
      final userTeam =
          UserTeam(id: team.id, status: statusTeams, useCardProtect: true);
      final history = History(
          idTeam: team.id, description: "Equipe \"${team.name}\" usa proteção");
      addHistory(history);
      updateTeams(userTeam);
      if (team.status == Status.Jogando) {
        protectTimer = null;
        _protectUpdateNotifier.value =
            false; // Notifica que o status não precisa ser mais atualizado
      }

      protectTimer = Future.delayed(
        const Duration(seconds: 10),
        () async {
          if (_protectUpdateNotifier.value) {
            await updateTeamStatus(team);
            _protectUpdateNotifier.value = false;
          }
        },
      );
    } else {
      ToolsController.scafoldMensage(
          context, Colors.redAccent, "A equipe já usou cartão de proteção");
    }
  }

  Future<void> updateTeamStatus(UserTeam team) async {
    // Atualiza o status da equipe para 'Jogando' e adiciona o histórico
    try {
      statusTeams = Status.Jogando;
      final updatedTeam = UserTeam(id: team.id, status: statusTeams);
      final history = History(
        idTeam: selectedTeamId,
        description: "Equipe \"${team.name}\" Não está mais congelado",
      );
      await updateTeams(updatedTeam);
      await addHistory(history);
    } catch (e) {
      debugPrint("Erro ao atualizar status da equipe: $e");
    }
  }

  Future<void> updateTeamStatusProtect(UserTeam team) async {
    try {
      statusTeams = Status.Jogando;
      final updatedTeam = UserTeam(id: team.id, status: statusTeams);
      final history = History(
        idTeam: team.id,
        description: "Equipe \"${team.name}\" perdeu a proteção.",
      );
      await updateTeams(updatedTeam);
      await addHistory(history);
    } catch (e) {
      debugPrint("Erro ao atualizar status da equipe: $e");
    }
  }
}
