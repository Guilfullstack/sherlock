import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/model/code.dart';
import 'package:sherlock/model/stage.dart';

class PlayController extends ChangeNotifier {
  final GlobalKey<FormState> formKeyPlay = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyPlayEdit = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController id = TextEditingController();
  final TextEditingController token = TextEditingController();
  final TextEditingController category = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController puzzle = TextEditingController();
  final TextEditingController value = TextEditingController(text: "0");
  // token edit
  final TextEditingController tokenEdit = TextEditingController();
  final TextEditingController categoryEdit = TextEditingController();
  final TextEditingController descriptionEdit = TextEditingController();
  final TextEditingController puzzleEdit = TextEditingController();
  final TextEditingController valueEdit = TextEditingController();

  Future<Code> addCode(Code code) async {
    DocumentReference<Code> codeDoc = userCodeRef.doc();
    code.id = codeDoc.id;
    code.date = DateTime.now();
    await codeDoc.set(code);
    notifyListeners();
    return Future<Code>.value(code);
  }

  Future<Stage> addCodeStage(Stage stage) async {
    DocumentReference<Stage> stageDoc = userStageRef.doc();
    stage.id = stageDoc.id;
    stage.date = DateTime.now();
    await stageDoc.set(stage);
    notifyListeners();
    return Future<Stage>.value(stage);
  }

  Future<List<Code>> getCodeList() async {
    // Obtém os documentos da coleção 'Code'
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Code').get();

    // Converte os documentos em uma lista de objetos Code
    List<Code> codeList = querySnapshot.docs.map((doc) {
      return Code.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    return codeList;
  }

  Future<List<Stage>> getStageList() async {
    // Obtém os documentos da coleção 'Code'
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Stage').get();

    // Converte os documentos em uma lista de objetos Code
    List<Stage> stageList = querySnapshot.docs.map((doc) {
      return Stage.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    return stageList;
  }

  Stream<List<Code>> get codeStream {
    return _firestore.collection('Code').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Code.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<Stage>> get codeStreamFilter {
    return _firestore.collection('Stage').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Stage.fromJson(doc.data());
      }).toList();
    });
  }

  Future removePlay(int category, String id) async {
    switch (category) {
      case 0:
        await userCodeRef.doc(id).delete();
        break;
      case 1:
        await userStageRef.doc(id).delete();
        break;
      // case 2:
      //   await userStaffRef.doc(id).delete();
      //   break;
      default:
    }
  }

  Future updateCode(Code code) async {
    QuerySnapshot querySnapshot =
        await userCodeRef.where('id', isEqualTo: code.id).get();

    // Função auxiliar para construir dinamicamente o mapa de atualização
    Map<String, dynamic> buildUpdateData(Code code) {
      Map<String, dynamic> data = {};

      if (code.description != null && descriptionEdit.text.isNotEmpty) {
        data['description'] = descriptionEdit.text;
      }
      if (code.token != null && tokenEdit.text.isNotEmpty) {
        data['token'] = tokenEdit.text;
      }
      if (code.category != null && categoryEdit.text.isNotEmpty) {
        data['category'] = categoryEdit.text;
      }
      if (code.value != null && valueEdit.text.isNotEmpty) {
        data['value'] = double.parse(valueEdit.text);
      }

      return data;
    }

    if (querySnapshot.docs.isNotEmpty) {
      // Se houver documentos encontrados, atualizar o primeiro documento encontrado
      DocumentSnapshot document = querySnapshot.docs.first;
      Map<String, dynamic> updateData = buildUpdateData(code);

      if (updateData.isNotEmpty) {
        await document.reference.update(updateData);
      }
    }
  }

  Future updateCodeStage(Stage stage) async {
    QuerySnapshot querySnapshot =
        await userStageRef.where('id', isEqualTo: stage.id).get();

    // Função auxiliar para construir dinamicamente o mapa de atualização
    Map<String, dynamic> buildUpdateData(Stage stage) {
      Map<String, dynamic> data = {};

      if (stage.description != null && descriptionEdit.text.isNotEmpty) {
        data['description'] = descriptionEdit.text;
      }
      if (stage.token != null && tokenEdit.text.isNotEmpty) {
        data['token'] = tokenEdit.text;
      }
      // if (stage.category != null && categoryEdit.text.isNotEmpty) {
      //   data['category'] = categoryEdit.text;
      // }
      if (stage.puzzle != null && puzzleEdit.text.isNotEmpty) {
        data['puzzle'] = puzzleEdit.text;
      }

      return data;
    }

    if (querySnapshot.docs.isNotEmpty) {
      // Se houver documentos encontrados, atualizar o primeiro documento encontrado
      DocumentSnapshot document = querySnapshot.docs.first;
      Map<String, dynamic> updateData = buildUpdateData(stage);

      if (updateData.isNotEmpty) {
        await document.reference.update(updateData);
      }
    }
  }

  String? categoryToString(Category category) {
    switch (category) {
      case Category.freezing:
        return 'Congelar';
      case Category.protect:
        return 'Escudo';
      case Category.pay:
        return 'Subtrair';
      case Category.receive:
        return 'Adicionar';
      case Category.stage:
        return 'Prova';
      default:
        return null;
    }
  }

  Category? categoryFromString(String? category) {
    switch (category) {
      case 'Congelar':
        return Category.freezing;
      case 'Escudo':
        return Category.protect;
      case 'Subtrair':
        return Category.pay;
      case 'Adicionar':
        return Category.receive;
      case 'Prova':
        return Category.stage;
      default:
        return null;
    }
  }

  //OPERAÇÕES COM O HIVE
  Future<void> saveCodeListToHive(List<Code> codeList) async {
    // Obtém a caixa onde os códigos serão armazenados
    final codeBox = await Hive.openBox<Code>('codeBox');

    // Salva os códigos na caixa
    for (var code in codeList) {
      if (code.id != null) {
        await codeBox.put(
            code.id, code); // Usa o ID como chave para cada código
      }
    }
  }

  Future<List<Code>> getCodeListFromHive() async {
    // Obtém a caixa onde os códigos estão armazenados
    final codeBox = await Hive.openBox<Code>('codeBox');

    // Recupera todos os códigos da caixa
    final codeList = codeBox.values.toList();

    return codeList;
  }

  Future<void> saveStageListToHive(List<Stage> stageList) async {
    try {
      final stageBox = Hive.box<Stage>('stageBox');
      await stageBox
          .clear(); // Opcional: limpa a caixa antes de adicionar novos itens

      for (var stage in stageList) {
        if (stage.id != null) {
          await stageBox.put(
              stage.id, stage); // Usa o ID como chave para cada stage
        }
      }
      print('Lista de estágios salva com sucesso no Hive.');
    } catch (e) {
      print('Erro ao salvar a lista de estágios no Hive: $e');
    }
  }

  Future<List<Stage>> getStageListFromHive() async {
    // Obtém a caixa onde os códigos estão armazenados
    final codeBox = await Hive.openBox<Stage>('stageBox');

    // Recupera todos os códigos da caixa
    final codeList = codeBox.values.toList();

    return codeList;
  }

  void execultCode(Category category, String token) async {
    UserController userController = UserController();

    if (category == Category.receive) {
      List<Code> listCodes = await getCodeListFromHive();
      for (var code in listCodes) {
        if (code.token == token) {
          print("Token correto");
          await userController.updateUserTeamHive('credit', code.value);
          return;
        }
      }
    } else {}
  }
}
