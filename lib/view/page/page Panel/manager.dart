import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sherlock/controller/play_controller.dart';
import 'package:sherlock/controller/tools_controller.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/model/code.dart';
import 'package:sherlock/model/history.dart';
import 'package:sherlock/model/stage.dart';
import 'package:sherlock/model/user_adm.dart';
import 'package:sherlock/model/user_staf.dart';
import 'package:sherlock/model/user_team.dart';
import 'package:sherlock/view/page/page%20Panel/list_users.dart';
import 'package:sherlock/view/widgets/custom_dropdown.dart';
import 'package:sherlock/view/widgets/imput_text.dart';
import 'package:sherlock/view/widgets/list_team_controller.dart';

class Manager extends StatefulWidget {
  final int pageList;
  final bool create;
  const Manager({super.key, required this.pageList, required this.create});

  @override
  State<Manager> createState() => _ManagerState();
}

class _ManagerState extends State<Manager> {
  UserController userController = UserController();
  PlayController playController = PlayController();
  bool historyVisible = false;
  ValueNotifier<bool> isHistoryVisible = ValueNotifier<bool>(true);
  Category value2 = Category.stage;
  Category value2Edit = Category.stage;
  late String selectionStaff = "Prova";
  late String selectionStaffEdit = "Prova";
  String valueDropDown = "Adicionar";
  String? codeStaff;
  bool hasLoadedMembers = false;
  int membersNumeber = 0;

  @override
  void dispose() {
    // Cancelar assinatura
    if (mounted) {
      // Verifique se o widget ainda está "montado"
      playController.dispose();
      userController.dispose();
      userController.addMemberFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.create == true
        ? pageCreate(widget.pageList)
        : changeList(widget.pageList);
  }

  Widget changeList(int page) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    switch (page) {
      case 1:
        return Column(
          children: [
            titleList("Equipes"),
            Expanded(
              child: Card.filled(
                color: const Color.fromARGB(0, 0, 0, 0),
                child: ListUsers<UserTeam>(
                  aspectRatio: w < 800 ? 0.7 : 1.2,
                  size: 350,
                  stream: userController.teamStream,
                  emptyMessage: 'Não há equipes',
                  errorMessage: 'Erro ao carregar equipes',
                  itemBuilder: (context, team, index) {
                    return ListTeamController(
                      addValue: true,
                      configEnabled: true,
                      listPrision: false,
                      equipe: team.name,
                      credit: team.credit,
                      usedCardFreeze: team.useCardFrezee,
                      usedCardProtect: team.useCardProtect,
                      usedCardLaCasaDePapel: team.useCardLaCasaDePapel,
                      isPayCardFreeze: team.isPayCardFrezee,
                      isPayCardProtect: team.isPayCardProtected,
                      isPayCardLaCasaDePapel: team.isPayCardLaCasaDePapel,
                      prisionBreak: team.isPrisionBreak,
                      isLoged: team.isLoged,
                      status: playController.statusToString(team.status!),
                      onTapRemove: () {
                        userController.removeUser(
                            context, 0, team.id.toString());
                      },
                      onTapEdit: () {
                        showDialog(
                            context: context,
                            builder: (build) {
                              userController.memberId.text = team.id ?? "";
                              userController.id.text = team.id ?? "";
                              userController.nameEdit.text = team.name ?? "";
                              userController.loginEdit.text = team.login ?? "";
                              userController.passwordEdit.text =
                                  team.password ?? "";
                              return AlertDialog(
                                backgroundColor: Colors.black,
                                content: Form(
                                  key: userController.formKeyEditTeam,
                                  child: SizedBox(
                                    width: 300,
                                    height: 450,
                                    child: addTeams(context, false, true, false,
                                        userController),
                                  ),
                                ),
                              );
                            });
                      },
                      onTapAddValue: () {
                        userController.addValueStatus.clear();
                        addValue(teamsDropDown, context, userController, team,
                            valueDropDown, true);
                      },
                      config: () {
                        userController.addValueStatus.clear();
                        addValue(teamsDropDown, context, userController, team,
                            valueDropDown, false);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            titleList("Administrador"),
            Expanded(
              child: Card.filled(
                color: const Color.fromARGB(0, 0, 0, 0),
                child: ListUsers<UserAdm>(
                  columGrid: 1,
                  size: 150,
                  aspectRatio: w < 800 ? 4 : 9.0,
                  stream: userController.admStream,
                  emptyMessage: 'Não há nenhum colaborador',
                  errorMessage: 'Erro ao carregar colaboradores',
                  itemBuilder: (context, team, index) {
                    return ListTeamController(
                      user: true,
                      equipe: team.login,
                      onTapRemove: () {
                        userController.removeUser(
                            context, 1, team.id.toString());
                      },
                      onTapEdit: () {
                        showDialog(
                            context: context,
                            builder: (build) {
                              userController.id.text = team.id ?? "";
                              userController.nameEdit.text = team.name ?? "";
                              userController.loginEdit.text = team.login ?? "";
                              userController.passwordEdit.text =
                                  team.password ?? "";
                              return AlertDialog(
                                backgroundColor: Colors.black,
                                content: Form(
                                  key: userController.formKeyEditTeam,
                                  child: SizedBox(
                                    width: 300,
                                    height: 450,
                                    child: addTeams(context, true, true, false,
                                        userController),
                                  ),
                                ),
                              );
                            });
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      case 3:
        return Column(
          children: [
            titleList("Staff"),
            Expanded(
              child: Card.filled(
                color: const Color.fromARGB(0, 0, 0, 0),
                child: ListUsers<UserStaff>(
                  columGrid: 1,
                  size: 150,
                  aspectRatio: w < 800 ? 4 : 9.0,
                  stream: userController.staffStream,
                  emptyMessage: 'Não há nenhum colaborador',
                  errorMessage: 'Erro ao carregar colaboradores',
                  itemBuilder: (context, team, index) {
                    return ListTeamController(
                      user: true,
                      equipe: team.login,
                      onTapRemove: () {
                        userController.removeUser(
                            context, 2, team.id.toString());
                      },
                      onTapEdit: () {
                        showDialog(
                          context: context,
                          builder: (build) {
                            userController.id.text = team.id ?? "";
                            userController.loginEdit.text = team.login ?? "";
                            userController.passwordEdit.text =
                                team.password ?? "";
                            selectionStaffEdit = team.office ?? "";
                            userController.selectedStageEdit =
                                team.listCode ?? [];
                            return AlertDialog(
                              backgroundColor: Colors.black,
                              content: Form(
                                key: userController.formKeyEditTeam,
                                child: SizedBox(
                                  width: 300,
                                  height: 450,
                                  child: addTeams(context, false, true, true,
                                      userController),
                                ),
                              ),
                            );
                          },
                        ).then((_) {
                          // setState(() {});
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      case 4:
        return Wrap(
          children: [
            SizedBox(
              height: w < 800 ? (h / 2) - 100 : h,
              child: Form(
                key: playController.formKeyPlay,
                child: _addTolkien(context, playController, false, false),
              ),
            ),
            SizedBox(
              height: w < 800 ? (h / 2) : h,
              width: w > 800 ? (w / 2) - 100 : w,
              child: Card.filled(
                color: const Color.fromARGB(0, 0, 0, 0),
                child: ListUsers<Stage>(
                  columGrid: 1,
                  size: 150,
                  aspectRatio: w < 800 ? 3.8 : 7.0,
                  stream: playController.codeStreamFilter,
                  emptyMessage: 'Não há nenhum colaborador',
                  errorMessage: 'Erro ao carregar colaboradores',
                  itemBuilder: (context, team, index) {
                    return ListTeamController(
                      user: true,
                      code: true,
                      stage: true,
                      equipe: team.description,
                      status: team.token,
                      credit: 0,
                      onTapRemove: () {
                        playController.removePlay(
                            context, 1, team.id.toString());
                      },
                      onTapEdit: () {
                        showDialog(
                            context: context,
                            builder: (builder) {
                              playController.id.text = team.id ?? "";
                              playController.tokenEdit.text = team.token ?? "";
                              playController.descriptionEdit.text =
                                  team.description ?? "";
                              playController.puzzleEdit.text =
                                  team.puzzle ?? "";
                              playController.valueEdit.text = "0";
                              value2Edit = Category.stage;
                              return Form(
                                key: playController.formKeyPlayEdit,
                                child: AlertDialog(
                                  backgroundColor: Colors.black,
                                  content: SizedBox(
                                    height: 500,
                                    width: 450,
                                    child: StatefulBuilder(builder:
                                        (BuildContext context, setState) {
                                      return _addTolkien(
                                          context, playController, true, true);
                                    }),
                                  ),
                                ),
                              );
                            });
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      case 5:
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Card.filled(
                  color: Colors.black, child: teamsDropDown(setState)),
            ),
            Expanded(
              child: Card.filled(
                color: const Color.fromARGB(0, 0, 0, 0),
                child: ListUsers<History>(
                    aspectRatio: w < 800 ? 2 : 6,
                    size: 400,
                    stream: userController.historyStream,
                    emptyMessage: 'Não há nenhum historico',
                    errorMessage: 'Erro ao carregar historico',
                    itemBuilder: (context, team, index) {
                      if (userController.teamDropDownHistory == 'Todos' ||
                          team.idTeam == userController.teamIdHistory) {
                        return ListTeamController(
                          dateHistory: team.date,
                          user: true,
                          history: false,
                          equipe: team.description,
                          onTapRemove: () {
                            userController.removeUser(
                                context, 3, team.id.toString());
                          },
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
              ),
            ),
          ],
        );
      case 6:
        return Column(
          children: [
            titleList("Itens de compra"),
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 5,
              runSpacing: 5,
              children: [
                for (int i = 0; i < userController.buyItem.length; i++)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: w < 800 ? w - 120 : w / 3,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(10), // Bordas arredondadas
                          border: Border.all(color: Colors.blue),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.2), // Cor da sombra
                              spreadRadius: 2, // Espalhamento da sombra
                              blurRadius: 5, // Desfoque da sombra
                              offset: const Offset(
                                  0, 3), // Posição da sombra (x, y)
                            ),
                          ],
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          title: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                    userController.buyItem[i]["imagem"]),
                                radius: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "${userController.buyItem[i]["nome"]}"
                                  "\nValor: ${userController.buyItem[i]["valor"]}",
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        );
      default:
    }
    return const Text("Nada encontrado");
  }

  Text titleList(String name) {
    return Text(
      name,
      style: const TextStyle(
        fontSize: 25,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget pageCreate(int page) {
    switch (page) {
      // equipes
      case 1:
        return Form(
          key: userController.formKey,
          child: addTeams(context, false, false, false, userController),
        );
      //adm
      case 2:
        return Form(
          key: userController.formKey,
          child: addTeams(context, true, false, false, userController),
        );
      //staff
      case 3:
        return Form(
          key: userController.formKey,
          child: addTeams(context, true, false, true, userController),
        );
      //proga
      case 4:
        return Form(
            key: playController.formKeyPlay,
            child: _addTolkien(context, playController, false, false));
      default:
        return const Text("Algo deu errado ao tentear criar");
    }
  }

  Container addTeams(BuildContext context, bool addAdm, bool update, bool staff,
      UserController userController) {
    bool obscureVisible = true, obsucreVisibleComfirm = true;
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      //width: 500,
      child: FocusTraversalGroup(
        // policy: OrderedTraversalPolicy(),
        child: ListView(
          children: [
            Center(
              child: Text(
                staff == false
                    ? update == false
                        ? addAdm == true
                            ? "Adicionar Administrador"
                            : 'Adicionar Equipe'
                        : 'Atualizar'
                    : update == true
                        ? 'Atualizar Staff'
                        : 'Adicionar Staff',
                style: const TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Visibility(
                visible:
                    (addAdm == false && update == true && staff == false) ||
                            update == false && staff == false && addAdm == false
                        ? true
                        : false,
                child: ImputTextFormField(
                  title: 'Nome da Equipe',
                  controller: update == false
                      ? userController.name
                      : userController.nameEdit,
                ),
              ),
            ),
            ImputTextFormField(
              title: 'Login',
              controller: update == false //|| staff == false
                  ? userController.login
                  : userController.loginEdit,
            ),
            StatefulBuilder(builder: (BuildContext context, setState) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: ImputTextFormField(
                      obscure: obscureVisible,
                      icon: IconButton(
                        focusNode: FocusNode(skipTraversal: true),
                        onPressed: () {
                          setState(() {
                            obscureVisible = !obscureVisible;
                          });
                        },
                        icon: Icon(
                          obscureVisible == false
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.blue,
                        ),
                      ),
                      title: 'Senha',
                      controller: update == false
                          ? userController.password
                          : userController.passwordEdit,
                      validator: (value) => value.length < 5
                          ? 'Precisa  ter no minimo 6 caracteres'
                          : null,
                    ),
                  ),
                  ImputTextFormField(
                    obscure: obsucreVisibleComfirm,
                    icon: IconButton(
                      focusNode: FocusNode(skipTraversal: true),
                      onPressed: () {
                        setState(() {
                          obsucreVisibleComfirm = !obsucreVisibleComfirm;
                        });
                      },
                      icon: Icon(
                        obsucreVisibleComfirm == false
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.blue,
                      ),
                    ),
                    title: 'Confirmar Senha',
                    controller: update == false
                        ? userController.passwordComfirm
                        : userController.passwordEditComfirm,
                    validator: (value) {
                      if (value != userController.password.text &&
                          value != userController.passwordEdit.text) {
                        return "Senhas diferentes";
                      }
                      if (value!.length < 6) {
                        return "Sua senha deve ter mínimo 6 caracteres";
                      }
                      if (value.isEmpty) {
                        return "Confirme sua senha";
                      }
                      return null;
                    },
                  ),
                  Visibility(
                    visible: (staff == true && update == false) ||
                            (staff == true && update == true)
                        ? true
                        : false,
                    child: Column(
                      children: [
                        selectStaff(
                          'Prova',
                          update == true ? selectionStaffEdit : selectionStaff,
                          'Prova',
                          (value) {
                            setState(() {
                              update == true
                                  ? selectionStaffEdit = 'Prova'
                                  : selectionStaff = 'Prova';
                              if (update == true) {
                                userController.selectionStaffEdit = 'Prova';
                              }
                            });
                          },
                        ),
                        selectStaff(
                          'Policia',
                          update == true ? selectionStaffEdit : selectionStaff,
                          'Policia',
                          (value) {
                            setState(() {
                              update == true
                                  ? selectionStaffEdit = 'Policia'
                                  : selectionStaff = 'Policia';
                              if (update == true) {
                                userController.selectionStaffEdit = 'Policia';
                              }
                            });
                          },
                        ),
                        selectStaff(
                          'Todos',
                          update == true ? selectionStaffEdit : selectionStaff,
                          'Todos',
                          (value) {
                            setState(() {
                              update == true
                                  ? selectionStaffEdit = 'Todos'
                                  : selectionStaff = 'Todos';
                              if (update == true) {
                                userController.selectionStaffEdit = 'Todos';
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                    child: ListView.builder(
                        itemCount: userController.membersTeam.length,
                        itemBuilder: (builder, index) {
                          return Text(userController.membersTeam[index]);
                        }),
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: userController.loading == false
                            ? ElevatedButton(
                                onPressed: () async {
                                  if (update == true) {
                                    if (userController
                                        .formKeyEditTeam.currentState!
                                        .validate()) {
                                      if (staff == false &&
                                          addAdm == true &&
                                          update == true) {
                                        //atualizar adm
                                        final newUserAdmEdit = UserAdm(
                                          id: userController.id.text,
                                          login: userController.loginEdit.text,
                                          password:
                                              userController.passwordEdit.text,
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await userController
                                            .updateAdm(newUserAdmEdit);
                                        setState(() {
                                          userController.loading = false;
                                        });
                                        //exitWindows();
                                      }
                                      if (staff == true && update == true) {
                                        //atualizar staff
                                        final newUserStaffEdit = UserStaff(
                                          id: userController.id.text,
                                          login: userController.loginEdit.text,
                                          password:
                                              userController.passwordEdit.text,
                                          office: selectionStaffEdit,
                                          listCode:
                                              userController.selectedStage,
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await userController
                                            .updateStaff(newUserStaffEdit);
                                        setState(() {
                                          userController.loading = false;
                                        });
                                      }
                                      if (staff == true && update == false) {
                                        //add Staff
                                        final newUserStaff = UserStaff(
                                          login: userController.login.text,
                                          password:
                                              userController.password.text,
                                          office: selectionStaff,
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await userController
                                            .addUserStaff(newUserStaff);

                                        userController.loading = false;
                                      } else {
                                        if (update == false) {
                                          //addAdm
                                          if (addAdm == true) {
                                            setState(() {
                                              userController.loading = true;
                                            });
                                            final newUserAdm = UserAdm(
                                              login: userController.login.text,
                                              password:
                                                  userController.password.text,
                                            );
                                            await userController
                                                .addUserAdm(newUserAdm);
                                            setState(() {
                                              userController.loading = false;
                                            });
                                            //add Equipe
                                          } else if (addAdm == false) {
                                            final newUserTeams = UserTeam(
                                              name: userController.name.text,
                                              login: userController.login.text,
                                              password:
                                                  userController.password.text,
                                              credit: 0,
                                            );
                                            setState(() {
                                              userController.loading = true;
                                            });

                                            await userController
                                                .addUserTeam(newUserTeams);
                                            setState(() {
                                              userController.loading = false;
                                            });
                                          }
                                          //Atualizar Equipe
                                        } else if (update == true) {
                                          // atualizar equipe
                                          final newUserTeamsEdit = UserTeam(
                                            id: userController.id.text,
                                            name: userController.nameEdit.text,
                                            login:
                                                userController.loginEdit.text,
                                            password: userController
                                                .passwordEdit.text,
                                          );
                                          setState(() {
                                            userController.loading = true;
                                          });
                                          await userController
                                              .updateTeams(newUserTeamsEdit);
                                          setState(() {
                                            userController.loading = false;
                                          });
                                          exitWindows();
                                        }
                                      }
                                    }
                                  } else {
                                    if (userController.formKey.currentState!
                                        .validate()) {
                                      if (staff == false &&
                                          addAdm == true &&
                                          update == true) {
                                        //atualizar adm
                                        final newUserAdmEdit = UserAdm(
                                          id: userController.id.text,
                                          login: userController.loginEdit.text,
                                          password:
                                              userController.passwordEdit.text,
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await userController
                                            .updateAdm(newUserAdmEdit);
                                        setState(() {
                                          userController.loading = false;
                                        });
                                        exitWindows();
                                      }
                                      if (staff == true && update == true) {
                                        //atualizar staff
                                        final newUserStaffEdit = UserStaff(
                                          id: userController.id.text,
                                          login: userController.loginEdit.text,
                                          password:
                                              userController.passwordEdit.text,
                                          office: selectionStaffEdit,
                                          listCode:
                                              userController.selectedStageEdit,
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await userController
                                            .updateStaff(newUserStaffEdit);
                                        setState(() {
                                          userController.loading = false;
                                        });
                                        exitWindows();
                                      }
                                      if (staff == true && update == false) {
                                        //add Staff
                                        final newUserStaff = UserStaff(
                                          login: userController.login.text,
                                          password:
                                              userController.password.text,
                                          office: selectionStaff,
                                          listCode:
                                              userController.selectedStage,
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await userController
                                            .addUserStaff(newUserStaff);
                                        setState(() {
                                          userController.loading = false;
                                        });
                                      } else {
                                        if (update == false) {
                                          //addAdm
                                          if (addAdm == true) {
                                            setState(() {
                                              userController.loading = true;
                                            });
                                            final newUserAdm = UserAdm(
                                              login: userController.login.text,
                                              password:
                                                  userController.password.text,
                                            );
                                            await userController
                                                .addUserAdm(newUserAdm);
                                            setState(() {
                                              userController.loading = false;
                                            });
                                            //exitWindows;
                                            //add Equipe
                                          } else if (addAdm == false) {
                                            //add team
                                            final newUserTeams = UserTeam(
                                              name: userController.name.text,
                                              login: userController.login.text,
                                              password:
                                                  userController.password.text,
                                              credit: 0,
                                              listMembers: userController
                                                  .membersTeam
                                                  .toList(),
                                              useCardFrezee: false,
                                              useCardProtect: false,
                                            );
                                            setState(() {
                                              userController.loading = true;
                                            });

                                            await userController
                                                .addUserTeam(newUserTeams);
                                            setState(() {
                                              userController.membersTeam
                                                  .clear();
                                              userController.loading = false;
                                            });
                                          }
                                          //Atualizar Equipe
                                        } else if (update == true) {
                                          // atualizar equipe
                                          final newUserTeamsEdit = UserTeam(
                                            id: userController.id.text,
                                            name: userController.nameEdit.text,
                                            login:
                                                userController.loginEdit.text,
                                            password: userController
                                                .passwordEdit.text,
                                          );
                                          setState(() {
                                            userController.loading = true;
                                          });
                                          await userController
                                              .updateTeams(newUserTeamsEdit);
                                          setState(() {
                                            userController.loading = false;
                                          });
                                          exitWindows();
                                        }
                                      }
                                    }
                                  }
                                },
                                child: Text(update == false
                                    ? "Adicionar"
                                    : "Atualizar"))
                            : const Center(child: CircularProgressIndicator()),
                      ),

                      Visibility(
                        visible: (addAdm == false &&
                                    update == true &&
                                    staff == false) ||
                                update == false &&
                                    staff == false &&
                                    addAdm == false
                            ? true
                            : false,
                        child: userController.loading == false
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: addMembers(
                                    false,
                                    userController.memberId.text,
                                    userController.membersTeam,
                                    update == true ? true : false),
                              )
                            : const SizedBox.shrink(),
                      ),
                      Visibility(
                        visible: staff == true
                            // selectionStaff == 'Prova' ||
                            //         (selectionStaffEdit == 'Prova' &&
                            //             selectionStaff == 'Prova') ||
                            //         (selectionStaffEdit == 'Prova' &&
                            //             staff == true) ||
                            //         (selectionStaff == 'Prova' && staff == true)
                            ? true
                            : false,
                        child: userController.loading == false
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      addCodeStaff(
                                          setState,
                                          userController.selectedStage,
                                          userController.selectedStageEdit,
                                          update,
                                          staff);
                                    },
                                    child: staff == true && update == false
                                        ? Text(
                                            'Adiconar Visualização ${userController.selectedStage.length}')
                                        : Text(
                                            ' Visualizar provas ${userController.selectedStageEdit.length}')),
                              )
                            : const SizedBox.shrink(),
                      ),
                      // Botão adicionar equipes
                      // Botão remover equipes
                      // Dropdown para acessar o histórico das equipes
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Padding selectStaff(String titulo, String valor, String groupValue,
      Function(String?)? onChanged) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
      ),
      child: RadioListTile<String>(
        tileColor: Colors.black87,
        activeColor: Colors.blue,
        title: Text(
          titulo,
          style: const TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
            // fontSize: 24,
          ),
        ),
        value: valor,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
    );
  }

  addCodeStaff(StateSetter setState, List<String> selectedList,
      List<String> selectedListEdit, bool update, bool staff) {
    return showDialog(
        context: context,
        builder: (build) {
          return AlertDialog(
            backgroundColor: Colors.black,
            content: SizedBox(
              width: 300,
              height: 450,
              child: StreamBuilder<List<Stage>>(
                stream: playController.codeStreamFilter,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    debugPrint("${snapshot.error}");
                    return const Center(
                        child: Text('Erro ao carregar Códigos'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Não há nenhum Código'));
                  }

                  final listCode = snapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        StatefulBuilder(
                            builder: (BuildContext context, setState) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Card(
                              color: Colors.black,
                              child: ListView.builder(
                                itemCount: listCode.length,
                                itemBuilder: (context, index) {
                                  final code = listCode[index];

                                  bool valueCheck =
                                      selectedList.contains(code.id);
                                  bool valueCheckEdit =
                                      selectedListEdit.contains(code.id);
                                  return ListTeamController(
                                    check: true,
                                    remove: false,
                                    addValue: false,
                                    user: true,
                                    equipe: code.description,
                                    status: code.token,
                                    credit: 0,
                                    category: playController.categoryToString(
                                        code.category as Category),
                                    onTapRemove: () {
                                      playController.removePlay(
                                          context, 1, code.id.toString());
                                    },
                                    onTapEdit: () {
                                      showDialog(
                                          context: context,
                                          builder: (builder) {
                                            playController.id.text =
                                                code.id ?? "";
                                            playController.tokenEdit.text =
                                                code.token ?? "";
                                            playController.descriptionEdit
                                                .text = code.description ?? "";
                                            playController.puzzleEdit.text =
                                                code.puzzle ?? "";
                                            playController.valueEdit.text = "0";
                                            value2Edit = Category.stage;
                                            return Form(
                                              key: playController
                                                  .formKeyPlayEdit,
                                              child: AlertDialog(
                                                backgroundColor: Colors.black,
                                                content: SizedBox(
                                                  height: 500,
                                                  width: 450,
                                                  child: StatefulBuilder(
                                                      builder:
                                                          (BuildContext context,
                                                              setState) {
                                                    return _addTolkien(
                                                        context,
                                                        playController,
                                                        true,
                                                        true);
                                                  }),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    valueChack: staff == true && update == false
                                        ? valueCheck
                                        : valueCheckEdit,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          if (staff == true &&
                                              update == false) {
                                            selectedList.add(code.id!);
                                          } else {
                                            selectedListEdit.add(code.id!);
                                          }
                                        } else if (value == false) {
                                          if (staff == true &&
                                              update == false) {
                                            selectedList.remove(code.id!);
                                          } else {
                                            selectedListEdit.remove(code.id!);
                                          }
                                        }
                                      });
                                    },
                                    //
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                        Visibility(
                          child: ElevatedButton(
                              onPressed: () {
                                exitWindows();
                              },
                              child: const Text('Adicionar')),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }).then((_) {
      setState(() {
        // if (staff == true && update == true) {
        //   selectedListEdit = selectedList;
        // } else {}
        //hasLoadedMembers = false;
        //selectedList.clear();
      });
    });
  }

  Container _addTolkien(BuildContext context, PlayController playController,
      bool update, bool editStage) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      //width: 500,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: ListView(
          children: [
            Center(
              child: Text(
                update == true ? 'Atualizar Código' : 'Adicionar Codigo',
                style: const TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ImputTextFormField(
                title: 'Descrição',
                controller: update == true
                    ? playController.descriptionEdit
                    : playController.description,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ImputTextFormField(
                icon: IconButton(
                  focusNode: FocusNode(skipTraversal: true),
                  onPressed: () {
                    update == true
                        ? playController.tokenEdit.text = generateRandomCode(6)
                        : playController.token.text = generateRandomCode(6);
                  },
                  icon: const Icon(Icons.generating_tokens),
                  color: Colors.blue,
                ),
                title: 'Codigo',
                controller: update == true
                    ? playController.tokenEdit
                    : playController.token,
              ),
            ),

            //categoria
            StatefulBuilder(builder: (BuildContext context, setState) {
              return Column(
                children: [
                  Visibility(
                    visible: false,

                    // editStage == true && update == true || update == false
                    //     ? true
                    //     : false,
                    child: categorySelected(
                      'Prova',
                      update == true ? value2Edit : value2,
                      Category.stage,
                      (value) {
                        setState(() {
                          update == true
                              ? value2Edit = Category.stage
                              : value2 = Category.stage;
                          update == true
                              ? playController.valueEdit.text = "0"
                              : playController.value.text = "0";
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: value2 == Category.stage ||
                            (value2Edit == Category.stage &&
                                value2 == Category.stage) ||
                            (value2Edit == Category.stage && update == true) ||
                            (value2 == Category.stage && update == true)
                        ? true
                        : false,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: ImputTextFormField(
                        maxLines: 4,
                        title: 'Enigma',
                        controller: update == true
                            ? playController.puzzleEdit
                            : playController.puzzle,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: userController.loading == false
                            ? ElevatedButton(
                                onPressed: () async {
                                  if (update == true) {
                                    //update code
                                    if (playController
                                        .formKeyPlayEdit.currentState!
                                        .validate()) {
                                      if (value2Edit == Category.stage) {
                                        playController.categoryEdit.text =
                                            playController.categoryToString(
                                                    value2Edit) ??
                                                "";
                                        final updateCode = Stage(
                                          id: playController.id.text,
                                          token: playController.tokenEdit.text,
                                          description: playController
                                              .descriptionEdit.text,
                                          puzzle:
                                              playController.puzzleEdit.text,
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await playController
                                            .updateCodeStage(updateCode);
                                        setState(() {
                                          userController.loading = false;
                                        });
                                        exitWindows();
                                      } else if (value2Edit != Category.stage) {
                                        playController.categoryEdit.text =
                                            playController.categoryToString(
                                                    value2Edit) ??
                                                "";
                                        final updateCode = Code(
                                          id: playController.id.text,
                                          token: playController.tokenEdit.text,
                                          description: playController
                                              .descriptionEdit.text,
                                          category: value2Edit,
                                          value: playController
                                                  .valueEdit.text.isEmpty
                                              ? 0
                                              : double.parse(playController
                                                  .valueEdit.text),
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await playController
                                            .updateCode(updateCode);
                                        setState(() {
                                          userController.loading = false;
                                        });
                                        exitWindows();
                                      }
                                    }
                                  } else if (update == false) {
                                    if (playController.formKeyPlay.currentState!
                                        .validate()) {
                                      //add stage
                                      if (value2 == Category.stage) {
                                        final newCode = Stage(
                                          token: playController.token.text,
                                          description:
                                              playController.description.text,
                                          puzzle: playController.puzzle.text,
                                          category: value2,
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await playController
                                            .addCodeStage(newCode);
                                        setState(() {
                                          userController.loading = false;
                                        });
                                        playController.token.clear();
                                      } else if (value2 != Category.stage) {
                                        //add code
                                        final newCode = Code(
                                          token: playController.token.text,
                                          description:
                                              playController.description.text,
                                          category: value2,
                                          value: playController
                                                  .value.text.isEmpty
                                              ? 0
                                              : double.parse(
                                                  playController.value.text),
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await playController.addCode(newCode);
                                        setState(() {
                                          userController.loading = false;
                                        });
                                        playController.token.clear();
                                      }
                                    }
                                  }
                                },
                                child: Text(
                                    update == true ? "Atualizar" : "Adicionar"))
                            : const Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  String generateRandomCode(int length) {
    final random = Random();
    const availableChars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final randomString = List.generate(length,
            (index) => availableChars[random.nextInt(availableChars.length)])
        .join();
    return randomString;
  }

  Padding categorySelected(String titulo, Category valor, Category groupValue,
      Function(Category?)? onChanged) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
      ),
      child: RadioListTile<Category>(
        tileColor: Colors.black87,
        activeColor: Colors.blue,
        title: Text(
          titulo,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        value: valor,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
    );
  }

  Padding listCodeStage(
    BuildContext context,
    PlayController playController,
    double width,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: SizedBox(
        width: width,
        height: MediaQuery.of(context).size.width > 830
            ? MediaQuery.of(context).size.height - 140
            : MediaQuery.of(context).size.height / 2 - 100,
        child: Card(
          color: Colors.black,
          child: StreamBuilder<List<Stage>>(
            stream: playController.codeStreamFilter,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                debugPrint("${snapshot.error}");
                return const Center(child: Text('Erro ao carregar Códigos'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Não há nenhum Código'));
              }

              final listCode = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        'Lista de Provas',
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: listCode.length,
                        itemBuilder: (context, index) {
                          final code = listCode[index];
                          return ListTeamController(
                            user: true,
                            code: true,
                            stage: true,
                            equipe: code.description,
                            status: code.token,
                            credit: 0,
                            onTapRemove: () {
                              playController.removePlay(
                                  context, 1, code.id.toString());
                            },
                            onTapEdit: () {
                              showDialog(
                                  context: context,
                                  builder: (builder) {
                                    playController.id.text = code.id ?? "";
                                    playController.tokenEdit.text =
                                        code.token ?? "";
                                    playController.descriptionEdit.text =
                                        code.description ?? "";
                                    playController.puzzleEdit.text =
                                        code.puzzle ?? "";
                                    playController.valueEdit.text = "0";
                                    value2Edit = Category.stage;
                                    return Form(
                                      key: playController.formKeyPlayEdit,
                                      child: AlertDialog(
                                        backgroundColor: Colors.black,
                                        content: SizedBox(
                                          height: 500,
                                          width: 450,
                                          child: StatefulBuilder(builder:
                                              (BuildContext context, setState) {
                                            return _addTolkien(context,
                                                playController, true, true);
                                          }),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            //
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  StatefulBuilder addMembers(
      bool hasLoadedMembers, String idTeams, List member, bool update) {
    return StatefulBuilder(builder: (BuildContext context, setState) {
      if (update == true && hasLoadedMembers == false) {
        // Carrega os membros apenas uma vez
        try {
          userController.getListMembers(idTeams).then((userTeams) {
            if (mounted) {
              setState(() {
                member = userTeams;
                membersNumeber = member.length;
                hasLoadedMembers = true; // Marca como carregado
              });
            }
          }).catchError((error) {
            // Tratar o erro se necessário
            debugPrint('Erro ao carregar membros: $error');
          });
        } catch (e) {
          debugPrint("$e");
        }
      }
      return ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (builder) {
              return AlertDialog(
                backgroundColor: Colors.black,
                content: SizedBox(
                  width: 400,
                  height: 408,
                  child: StatefulBuilder(
                      builder: (BuildContext context, setStateDialog) {
                    return ListView(
                      children: [
                        ImputTextFormField(
                          title: "Nome do Membro",
                          controller: userController.addMember,
                          focusNode: userController.addMemberFocusNode,
                          onFieldSubmitted: (value) {
                            setStateDialog(() {
                              member.add(value);
                              userController.addMember.clear();
                              FocusScope.of(context).requestFocus(
                                  userController.addMemberFocusNode);
                            });
                          },
                          icon: IconButton(
                            onPressed: () {
                              setStateDialog(() {
                                member.add(userController.addMember.text);
                                userController.addMember.clear();
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Card.filled(
                            color: Colors.black,
                            child: SizedBox(
                              height: 300,
                              width: 400,
                              child: ListView.builder(
                                itemCount: member.length,
                                itemBuilder: (context, index) {
                                  final listMember = member[index];
                                  return ListTeamController(
                                    user: true,
                                    equipe: listMember,
                                    onTapRemove: () {
                                      setStateDialog(() {
                                        member.remove(listMember);
                                      });
                                    },
                                    onTapEdit: () {
                                      bool updateLocal = true;
                                      userController.addMemberEdit.text =
                                          listMember;

                                      showDialog(
                                        context: context,
                                        builder: (builder) {
                                          return AlertDialog(
                                            backgroundColor: Colors.black87,
                                            content: ImputTextFormField(
                                              title: updateLocal == true
                                                  ? "Atualizar membro"
                                                  : "Nome do Membro",
                                              controller: updateLocal == true
                                                  ? userController.addMemberEdit
                                                  : userController.addMember,
                                              onFieldSubmitted: (value) {
                                                setStateDialog(() {
                                                  member[index] = value;
                                                  updateLocal == true
                                                      ? userController
                                                          .addMemberEdit
                                                          .clear()
                                                      : userController.addMember
                                                          .clear();
                                                  exitWindows();
                                                });
                                              },
                                              icon: IconButton(
                                                onPressed: () {
                                                  setStateDialog(() {
                                                    member[index] =
                                                        userController
                                                            .addMemberEdit.text;
                                                    exitWindows();
                                                  });
                                                },
                                                icon: Icon(updateLocal == true
                                                    ? Icons.update
                                                    : Icons.add),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (update == true) {
                              final newMembers = UserTeam(
                                id: idTeams,
                                listMembers: member,
                              );
                              await userController.updateTeams(newMembers);
                              setStateDialog(() {
                                hasLoadedMembers = false;
                              });
                              exitWindows(); // Fechar o diálogo
                            } else {
                              exitWindows(); // Fechar o diálogo
                            }
                          },
                          child: Text(update == true ? "Atualizar" : "Salvar"),
                        )
                      ],
                    );
                  }),
                ),
              );
            },
          ).then((_) {
            if (mounted) {
              setState(() {
                hasLoadedMembers = false;
              });
            }
          });
        },
        child: Text("Membros ${member.length}"),
      );
    });
  }

  exitWindows() {
    Navigator.pop(context);
  }

  addValue(
    Padding Function(StateSetter setState) teamsDropDown,
    BuildContext context,
    UserController user,
    UserTeam teams,
    String dropDonw,
    bool config,
  ) {
    bool isSwitch1On = teams.useCardFrezee == true ? true : false;
    bool isSwitch2On = teams.useCardProtect == true ? true : false;
    bool isUseCardLaCasaDePapel =
        teams.useCardLaCasaDePapel == true ? true : false;
    bool isPrision = teams.isPrisionBreak == true ? true : false;
    bool isLogado = teams.isLoged == true ? true : false;
    bool isPayFreeze = teams.isPayCardFrezee == true ? true : false;
    bool isPayProtect = teams.isPayCardProtected == true ? true : false;
    bool isPayLaCasaDePapel =
        teams.isPayCardLaCasaDePapel == true ? true : false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        exit() {
          Navigator.of(context).pop();
        }

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              child: AlertDialog(
                backgroundColor: Colors.black,
                title: Text(
                  teams.name ?? "",
                  style: const TextStyle(color: Colors.white),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: config == true ? false : true,
                      child: Column(
                        children: [
                          //siwtch
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Usou carta  de Congelar",
                                style: TextStyle(color: Colors.white),
                              ),
                              Switch(
                                activeColor: Colors.blue,
                                value: isSwitch1On,
                                onChanged: (value) async {
                                  await user.updateTeams(UserTeam(
                                      id: teams.id, useCardFrezee: value));
                                  setState(() {
                                    isSwitch1On = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          // Segundo Switch
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Usou carta de Proteção",
                                style: TextStyle(color: Colors.white),
                              ),
                              Switch(
                                activeColor: Colors.blue,
                                value: isSwitch2On,
                                onChanged: (value) async {
                                  await user.updateTeams(UserTeam(
                                      id: teams.id, useCardProtect: value));
                                  setState(() {
                                    isSwitch2On = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          // carta La Casa De Papel
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Usou carta LCP",
                                style: TextStyle(color: Colors.white),
                              ),
                              Switch(
                                activeColor: Colors.blue,
                                value: isUseCardLaCasaDePapel,
                                onChanged: (value) async {
                                  await user.updateTeams(UserTeam(
                                      id: teams.id,
                                      useCardLaCasaDePapel: value));
                                  setState(() {
                                    isUseCardLaCasaDePapel = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          //comprou carta congelar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Comprou carta congelar",
                                style: TextStyle(color: Colors.white),
                              ),
                              Switch(
                                activeColor: Colors.blue,
                                value: isPayFreeze,
                                onChanged: (value) async {
                                  await user.updateTeams(UserTeam(
                                      id: teams.id, isPayCardFrezee: value));
                                  setState(() {
                                    isPayFreeze = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          //comprou carta proteção
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Comprou carta proteção",
                                style: TextStyle(color: Colors.white),
                              ),
                              Switch(
                                activeColor: Colors.blue,
                                value: isPayProtect,
                                onChanged: (value) async {
                                  await user.updateTeams(UserTeam(
                                      id: teams.id, isPayCardProtected: value));
                                  setState(() {
                                    isPayProtect = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          //comprou carta La Casa De Papael
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Comprou carta LCP",
                                style: TextStyle(color: Colors.white),
                              ),
                              Switch(
                                activeColor: Colors.blue,
                                value: isPayLaCasaDePapel,
                                onChanged: (value) async {
                                  await user.updateTeams(UserTeam(
                                      id: teams.id,
                                      isPayCardLaCasaDePapel: value));
                                  setState(() {
                                    isPayLaCasaDePapel = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          //prisão
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Prisão",
                                style: TextStyle(color: Colors.white),
                              ),
                              Switch(
                                activeColor: Colors.blue,
                                value: isPrision,
                                onChanged: (value) async {
                                  await user.updateTeams(UserTeam(
                                      id: teams.id, isPrisionBreak: value));
                                  setState(() {
                                    isPrision = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          // logado
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Logado",
                                style: TextStyle(color: Colors.white),
                              ),
                              Switch(
                                activeColor: Colors.blue,
                                value: isLogado,
                                onChanged: (value) async {
                                  await user.updateTeams(
                                      UserTeam(id: teams.id, isLoged: value));
                                  setState(() {
                                    isLogado = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: config == true ? true : false,
                      child: Column(
                        children: [
                          CustomDropdown(
                            items: const [
                              "Adicionar",
                              "Subtrair",
                              "Congelar",
                              "La Casa de Papel",
                              "Proteção",
                              "Comp. carta congelar",
                              "Comp. carta proteção",
                              "Comp. carta LCP",
                              "Pagar Fiança",
                              "Jogando"
                            ],
                            title: "Selecione",
                            value: dropDonw,
                            onChanged: (value) {
                              setState(() {
                                dropDonw = value!;
                              });
                            },
                          ),
                          if (dropDonw == "Adicionar" || dropDonw == "Subtrair")
                            ImputTextFormField(
                              title: "Valor",
                              controller: user.addValueHistoty,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*')),
                              ],
                            ),
                          if (dropDonw == "Congelar" ||
                              dropDonw == "La Casa de Papel")
                            StreamBuilder<List<UserTeam>>(
                              stream: user.teamStream, // Sua stream de equipes
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text(
                                      'Erro ao carregar equipes: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return const Text(
                                      'Nenhuma equipe disponível');
                                } else {
                                  List<UserTeam> availableTeams =
                                      snapshot.data!;

                                  Map<String, UserTeam> teamDetailsMap = {
                                    for (var team in availableTeams)
                                      (team.name ?? "Sem nome"): UserTeam(
                                        id: team.id ?? "",
                                        name: team.name ?? "Sem nome",
                                        status: team.status ?? Status.Jogando,
                                        useCardFrezee: team.useCardFrezee,
                                        useCardProtect: team.useCardProtect,
                                        useCardLaCasaDePapel:
                                            team.useCardLaCasaDePapel,
                                        isPayCardFrezee: team.isPayCardFrezee,
                                        isPayCardLaCasaDePapel:
                                            team.isPayCardLaCasaDePapel,
                                      ),
                                  };

                                  Map<String, String> teamIdMap = {
                                    for (var team in availableTeams)
                                      (team.name ?? "Sem nome"): team.id ?? ""
                                  };
                                  Map<Status, Status> teamStatusMap = {
                                    for (var team in availableTeams)
                                      (team.status ?? Status.Jogando):
                                          team.status ?? Status.Jogando
                                  };

                                  Map<String, String> teamNameMap = {
                                    for (var team in availableTeams)
                                      (team.name ?? ""): team.name ?? ""
                                  };

                                  List<String> teamNames = availableTeams
                                      .map((team) => team.name ?? "Sem nome")
                                      .toList();

                                  // Ajusta a lista de equipes conforme a ação selecionada
                                  if (dropDonw == "Congelar" ||
                                      dropDonw == "La Casa de Papel") {
                                    // Remove a equipe atual da lista para congelar
                                    teamNames.remove(teams.name);
                                  } else if (dropDonw == "Proteção") {
                                    // Adiciona a equipe selecionada na lista e usa como valor
                                    teamNames = [teams.name ?? "Sem nome"];
                                  }

                                  // Garantir que o valor inicial do dropdown seja um dos itens da lista
                                  user.selectedTeam = user.teamDropDownHistory;
                                  if (dropDonw == "Proteção" &&
                                      teamNames.isNotEmpty) {
                                    user.selectedTeam = teamNames.first;
                                  } else if (!teamNames
                                      .contains(user.selectedTeam)) {
                                    user.selectedTeam = teamNames.isNotEmpty
                                        ? teamNames.first
                                        : null;
                                  }
                                  user.selectedUserTeam =
                                      teamDetailsMap[user.selectedTeam];
                                  user.selectedTeamId =
                                      teamIdMap[user.selectedTeam];
                                  user.selectedTeamStatus =
                                      teamStatusMap[teams.status];
                                  user.selectedTeamName = user.selectedTeam;

                                  return Column(
                                    children: [
                                      Text(
                                        dropDonw != "Congelar"
                                            ? "Qual Equipe vai vau usar carta LCP\nna equipe ${teams.name}"
                                            : "Qual Equipe vai congelar\n(${teams.name})",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      CustomDropdown(
                                        value: user
                                            .selectedTeam, // Certifique-se de que value não é nulo
                                        title: "Selecione a equipe",
                                        items: teamNames,
                                        onChanged: (newValue) {
                                          setState(() {
                                            user.teamDropDownHistory =
                                                newValue!;
                                            user.selectedTeam = newValue;
                                            user.selectedTeamId =
                                                teamIdMap[newValue];
                                            user.selectedTeamStatus =
                                                // ignore: collection_methods_unrelated_type
                                                teamStatusMap[newValue];
                                            user.selectedTeamName =
                                                teamNameMap[newValue];
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  Visibility(
                    visible: config == true ? true : false,
                    child: Wrap(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            switch (dropDonw) {
                              case "Adicionar":
                                if (teams.status == Status.Congelado) {
                                  ToolsController.scafoldMensage(
                                      context,
                                      Colors.red,
                                      "Não pode adicionar uma equipe que está congelada");
                                } else {
                                  user.addValueStatus.text =
                                      user.addValueHistoty.text;
                                  final credit =
                                      double.parse(user.addValueStatus.text) +
                                          teams.credit!;
                                  user.addValueStatus.text = credit.toString();
                                  final userTeam = UserTeam(
                                    id: teams.id,
                                    credit:
                                        double.parse(user.addValueStatus.text),
                                  );

                                  final history = History(
                                      idTeam: teams.id,
                                      description:
                                          "Adicionado \"${user.addValueHistoty.text}\" a Equipe \"${teams.name}\"");
                                  await user.addHistory(history);
                                  await user.updateTeams(userTeam);
                                  if (context.mounted) {
                                    ToolsController.scafoldMensage(
                                        context,
                                        Colors.green,
                                        "Foi adiconado com sucesso");
                                  }

                                  user.addValueStatus.clear();
                                  user.addValueHistoty.clear();
                                }

                                break;

                              case "Subtrair":
                                if (teams.status == Status.Congelado) {
                                  ToolsController.scafoldMensage(
                                      context,
                                      Colors.red,
                                      "Não pode subtrair enquanto estiver congelado");
                                } else {
                                  final double enteredValue =
                                      double.parse(user.addValueHistoty.text);
                                  final double currentCredit = teams.credit!;

                                  // Verifica se o valor a ser subtraído é maior do que o crédito atual
                                  if (enteredValue > currentCredit) {
                                    // Exibe o diálogo se o valor for maior que o crédito atual
                                    ToolsController.scafoldMensage(
                                        context,
                                        Colors.green,
                                        "Não pode tirar mais do que a equipe possui");
                                  } else {
                                    // Calcula o novo valor do crédito após a subtração
                                    final double newCredit =
                                        currentCredit - enteredValue;
                                    user.addValueStatus.text =
                                        newCredit.toString();

                                    final userTeam = UserTeam(
                                      id: teams.id,
                                      credit: newCredit,
                                    );

                                    final history = History(
                                      idTeam: teams.id,
                                      description:
                                          "Subtraído \"${user.addValueHistoty.text}\" da equipe \"${teams.name}\"",
                                    );

                                    // Atualiza o histórico e o crédito da equipe
                                    await user.addHistory(history);
                                    await user.updateTeams(userTeam);

                                    if (context.mounted) {
                                      ToolsController.scafoldMensage(
                                          context,
                                          Colors.green,
                                          "Foi retirado com sucesso");
                                    }
                                    // Limpa os campos de entrada
                                    user.addValueStatus.clear();
                                    user.addValueHistoty.clear();
                                  }
                                }
                                break;

                              case "Congelar":
                                user.startStatusUpdateTimer(teams, context);
                                break;
                              case "La Casa de Papel":
                                user.userCardLaCasaDePapel(teams, context);
                                break;
                              case "Pagar Fiança":
                                // Verifica se a equipe está presa
                                if (teams.isPrisionBreak == true) {
                                  // Verifica se a equipe tem crédito suficiente para pagar a fiança
                                  if (teams.credit! >= 200) {
                                    final double currentCredit = teams.credit!;
                                    final double newCredit =
                                        currentCredit - 200;
                                    user.addValueStatus.text =
                                        newCredit.toString();
                                    // Atualiza a equipe com o novo valor de crédito e marca como "não presa"
                                    await userController.updateTeams(
                                      UserTeam(
                                        id: teams.id,
                                        isPrisionBreak: false,
                                        credit: newCredit,
                                      ),
                                    );

                                    // Adiciona uma entrada no histórico informando que a fiança foi paga
                                    userController.addHistory(
                                      History(
                                        idTeam: teams.id,
                                        description:
                                            "Equipe \"${teams.name}\" pagou a fiança",
                                      ),
                                    );

                                    // Exibe uma mensagem de sucesso
                                    if (context.mounted) {
                                      ToolsController.scafoldMensage(
                                          context,
                                          Colors.green,
                                          "Fiança paga com sucesso! Crédito restante: $newCredit");
                                    }
                                  } else {
                                    // Caso a equipe não tenha crédito suficiente
                                    ToolsController.scafoldMensage(
                                        context,
                                        Colors.red,
                                        "Crédito insuficiente para pagar a fiança");
                                  }
                                } else {
                                  // Caso a equipe não esteja presa
                                  ToolsController.scafoldMensage(context,
                                      Colors.red, "A equipe não está presa");
                                }
                                break;

                              case "Comp. carta congelar":
                                if (teams.isPayCardFrezee == false) {
                                  // Verifica se a equipe tem crédito suficiente
                                  if (teams.credit! >= 120) {
                                    final double currentCredit = teams.credit!;
                                    final double newCredit =
                                        currentCredit - 120;
                                    user.addValueStatus.text =
                                        newCredit.toString();
                                    // Atualiza a equipe com o novo valor de crédito
                                    await userController.updateTeams(
                                      UserTeam(
                                        id: teams.id,
                                        isPayCardFrezee: true,
                                        credit: newCredit,
                                      ),
                                    );

                                    // Adiciona uma entrada no histórico informando que a fiança foi paga
                                    userController.addHistory(
                                      History(
                                        idTeam: teams.id,
                                        description:
                                            "Equipe \"${teams.name}\" comprou carta de CONGELAR",
                                      ),
                                    );

                                    // Exibe uma mensagem de sucesso
                                    if (context.mounted) {
                                      ToolsController.scafoldMensage(
                                          context,
                                          Colors.green,
                                          "Carta comprada com sucesso");
                                    }
                                  } else {
                                    // Caso a equipe não tenha crédito suficiente
                                    ToolsController.scafoldMensage(
                                        context,
                                        Colors.red,
                                        "A equipe não tem credito suficiente");
                                  }
                                } else {
                                  // Caso a equipe não esteja presa
                                  ToolsController.scafoldMensage(
                                      context,
                                      Colors.red,
                                      "A equipe já comprou essa carta");
                                }
                                break;

                              case "Comp. carta proteção":
                                if (teams.isPayCardProtected == false) {
                                  // Verifica se a equipe tem crédito suficiente
                                  if (teams.credit! >= 120) {
                                    final double currentCredit = teams.credit!;
                                    final double newCredit =
                                        currentCredit - 120;
                                    user.addValueStatus.text =
                                        newCredit.toString();
                                    // Atualiza a equipe com o novo valor de crédito
                                    await userController.updateTeams(
                                      UserTeam(
                                        id: teams.id,
                                        isPayCardProtected: true,
                                        credit: newCredit,
                                      ),
                                    );

                                    // Adiciona uma entrada no histórico informando que a fiança foi paga
                                    userController.addHistory(
                                      History(
                                        idTeam: teams.id,
                                        description:
                                            "Equipe \"${teams.name}\" comprou carta de PROTEÇÂO",
                                      ),
                                    );

                                    // Exibe uma mensagem de sucesso
                                    if (context.mounted) {
                                      ToolsController.scafoldMensage(
                                          context,
                                          Colors.green,
                                          "Carta comprada com sucesso");
                                    }
                                  } else {
                                    // Caso a equipe não tenha crédito suficiente
                                    ToolsController.scafoldMensage(
                                        context,
                                        Colors.red,
                                        "A equipe não tem credito suficiente");
                                  }
                                } else {
                                  // Caso a equipe não esteja presa
                                  ToolsController.scafoldMensage(
                                      context,
                                      Colors.red,
                                      "A equipe já comprou essa carta");
                                }
                                break;

                              case "Comp. carta LCP":
                                if (teams.isPayCardLaCasaDePapel == false) {
                                  // Verifica se a equipe tem crédito suficiente
                                  if (teams.credit! >= 150) {
                                    final double currentCredit = teams.credit!;
                                    final double newCredit =
                                        currentCredit - 150;
                                    user.addValueStatus.text =
                                        newCredit.toString();
                                    // Atualiza a equipe com o novo valor de crédito
                                    await userController.updateTeams(
                                      UserTeam(
                                        id: teams.id,
                                        isPayCardLaCasaDePapel: true,
                                        credit: newCredit,
                                      ),
                                    );

                                    // Adiciona uma entrada no histórico informando que a fiança foi paga
                                    await userController.addHistory(
                                      History(
                                        idTeam: teams.id,
                                        description:
                                            "Equipe \"${teams.name}\" comprou carta LA CASA DE PAPEL",
                                      ),
                                    );

                                    // Exibe uma mensagem de sucesso
                                    if (context.mounted) {
                                      ToolsController.scafoldMensage(
                                          context,
                                          Colors.green,
                                          "Carta comprada com sucesso");
                                    }
                                  } else {
                                    // Caso a equipe não tenha crédito suficiente
                                    ToolsController.scafoldMensage(
                                        context,
                                        Colors.red,
                                        "A equipe não tem credito suficiente");
                                  }
                                } else {
                                  // Caso a equipe não esteja presa
                                  ToolsController.scafoldMensage(
                                      context,
                                      Colors.red,
                                      "A equipe já comprou essa carta");
                                }
                                break;

                              case "Proteção":
                                user.startProtectUpdateTimer(teams, context);
                                break;

                              case "Jogando":
                                user.statusTeams = Status.Jogando;
                                final userTeam = UserTeam(
                                  id: teams.id,
                                  status: user.statusTeams,
                                );
                                await user.updateTeams(userTeam);
                              default:
                            }
                            exit();
                          },
                          child: const Text("Aplicar"),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancelar"))
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Padding teamsDropDown(StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<UserTeam>>(
        stream: userController.teamStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('Nenhuma equipe encontrada.');
          } else {
            List<UserTeam> teams = snapshot.data!;
            List<String> teamNames = ['Todos'];
            Map<String, String> teamIdMap = {};

            for (var team in teams) {
              String name = team.name ?? 'Não há equipes';
              String id = team.id!;
              teamNames.add(name);
              teamIdMap[name] = id;
            }

            return CustomDropdown(
              value: userController.teamDropDownHistory,
              title: "Histórico",
              items: teamNames,
              onChanged: (newValue) {
                setState(() {
                  userController.teamDropDownHistory = newValue!;
                  userController.updateTeamIdHistory(teamIdMap[newValue]);
                });
              },
            );
          }
        },
      ),
    );
  }
}
