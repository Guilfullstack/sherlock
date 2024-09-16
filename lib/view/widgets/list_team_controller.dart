import 'package:flutter/material.dart';
import 'package:sherlock/controller/user_controller.dart';

class ListTeamController extends StatefulWidget {
  final String? equipe;
  final Function()? onTapEdit;
  final Function()? onTapRemove;
  final Function()? onTapAddValue;
  final Function(bool?)? onChanged;
  final double? credit;
  final String? status;
  final String? category;
  final bool? user;
  final bool? code;
  final bool? stage;
  final bool? addValue;
  final bool? history;
  final bool? remove;
  final bool? check;
  final bool? valueChack;
  final DateTime? dateHistory;
  const ListTeamController({
    super.key,
    this.equipe,
    this.onTapEdit,
    this.onTapRemove,
    this.credit,
    this.status,
    this.user = false,
    this.code = false,
    this.category,
    this.stage,
    this.addValue,
    this.onTapAddValue,
    this.history = true,
    this.dateHistory,
    this.remove = true,
    this.check = false,
    this.onChanged,
    this.valueChack,
  });

  @override
  State<ListTeamController> createState() => _ListTeamControllerState();
}

class _ListTeamControllerState extends State<ListTeamController> {
  UserController user = UserController();

  TextSpan _buildHighlightedText(String text) {
    // Definir palavras a serem destacadas
    const highlightKeywords = [
      'Equipe',
      'equipe',
      'Adicionado',
      'Subtraido',
      'congela equipe',
      'Prova',
      'congelou'
    ];

    // Separar o texto por espaços para análise
    final words = text.split(' ');

    // Lista de TextSpan para construir o texto formatado
    final children = <TextSpan>[];

    // Variável para rastrear a palavra anterior
    String? previousWord;

    for (var word in words) {
      if (highlightKeywords.contains(previousWord)) {
        // Adicionar a palavra destacada
        children.add(TextSpan(
          text: '$word ',
          style: const TextStyle(
            color: Colors.red, // Cor do destaque
            fontWeight: FontWeight.bold, // Peso do destaque
          ),
        ));
      } else {
        // Adicionar a palavra normal
        children.add(TextSpan(
          text: '$word ',
          style: const TextStyle(
            color: Colors.white, // Cor normal
          ),
        ));
      }

      // Atualizar a palavra anterior
      previousWord = word;
    }

    return TextSpan(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: widget.history == true
            ? Text(
                widget.equipe ?? "Sem nome",
                style: TextStyle(
                  color: ThemeData().primaryColorLight,
                ),
              )
            : RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: ThemeData().primaryColorLight,
                  ),
                  children: [
                    _buildHighlightedText(widget.equipe ?? ""),
                    const TextSpan(
                      text: "\nData: ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text:
                          user.formatDate(widget.dateHistory ?? DateTime.now()),
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
        subtitle: widget.code == true
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.stage != true)
                    Text(
                      "Categoria: ${widget.category ?? ""}",
                      style: TextStyle(color: ThemeData().primaryColorLight),
                    ),
                  if (widget.stage != true)
                    Text(
                      "Valor: ${widget.credit == 0 ? "Sem valor" : widget.credit}",
                      style: TextStyle(color: ThemeData().primaryColorLight),
                    ),
                  Text(
                    "Código: ${widget.status ?? ""}",
                    style: TextStyle(color: ThemeData().primaryColorLight),
                  ),
                ],
              )
            : widget.user == false
                ? Text(
                    "Estatus: ${widget.status ?? ""}\nCreditos: ${widget.credit?.toStringAsFixed(2) ?? '0.00'}")
                : null,
        leading: widget.history == false
            ? null
            : widget.check == true
                ? Checkbox(
                    value: widget.valueChack, onChanged: widget.onChanged)
                : CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 95, 95, 95),
                    child: widget.code == true
                        ? const Icon(
                            Icons.token,
                            color: Colors.black,
                          )
                        : const Icon(
                            Icons.people,
                            color: Colors.black,
                          ),
                  ),
        trailing: PopupMenuButton<String>(
          tooltip: "Menu",
          itemBuilder: (BuildContext context) {
            return [
              if (widget.history == true)
                PopupMenuItem<String>(
                  onTap: widget.onTapEdit,
                  child: const Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Editar'),
                    ],
                  ),
                ),
              if (widget.remove == true)
                PopupMenuItem<String>(
                  onTap: widget.onTapRemove,
                  child: const Row(
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 8),
                      Text('Remover'),
                    ],
                  ),
                ),
              if (widget.addValue == true)
                PopupMenuItem<String>(
                  onTap: widget.onTapAddValue,
                  child: const Row(
                    children: [
                      Icon(Icons.task),
                      SizedBox(width: 8),
                      Text('Estatus'),
                    ],
                  ),
                ),
              // PopupMenuItem<String>(
              //   enabled: widget.onDesktop == false ? true : false,
              //   onTap: widget.onTapHistory,
              //   child: const Row(
              //     children: [
              //       Icon(Icons.history),
              //       SizedBox(width: 8),
              //       Text('Historico'),
              //     ],
              //   ),
              // ),
            ];
          },
          icon: const Icon(Icons.more_vert), // Ícone do botão de ação
        ),
      ),
    );
  }
}
