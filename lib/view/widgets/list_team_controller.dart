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
  final bool? usedCardFreeze;
  final bool? usedCardProtect;
  final bool? isLoged;
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
    this.usedCardFreeze,
    this.usedCardProtect,
    this.isLoged,
  });

  @override
  State<ListTeamController> createState() => _ListTeamControllerState();
}

class _ListTeamControllerState extends State<ListTeamController> {
  UserController user = UserController();

  TextSpan _buildHighlightedText(String text) {
    // Expressão regular para identificar o texto entre aspas
    final RegExp quoteRegExp = RegExp(r'".+?"');

    // Lista de TextSpan para construir o texto formatado
    final children = <TextSpan>[];

    // Usar a expressão regular para separar o texto em partes
    final matches = quoteRegExp.allMatches(text);

    int currentIndex = 0;

    for (final match in matches) {
      // Pega o texto anterior à próxima parte entre aspas
      if (match.start > currentIndex) {
        final normalText = text.substring(currentIndex, match.start);
        children.add(TextSpan(
          text: normalText,
          style: const TextStyle(color: Colors.white), // Estilo normal
        ));
      }

      // Pega o texto entre aspas e remove as aspas
      final highlightedText = match.group(0)?.replaceAll('"', '');
      if (highlightedText != null) {
        children.add(TextSpan(
          text: highlightedText, // O texto entre aspas, sem as aspas
          style: const TextStyle(
            color: Colors.red, // Cor do destaque
            fontWeight: FontWeight.bold, // Peso do destaque
          ),
        ));
      }

      // Atualizar o índice atual
      currentIndex = match.end;
    }

    // Adicionar qualquer texto restante após a última parte destacada
    if (currentIndex < text.length) {
      final remainingText = text.substring(currentIndex);
      children.add(TextSpan(
        text: remainingText,
        style: const TextStyle(color: Colors.white), // Estilo normal
      ));
    }

    return TextSpan(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), // Bordas arredondadas
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Cor da sombra
              spreadRadius: 2, // Espalhamento da sombra
              blurRadius: 5, // Desfoque da sombra
              offset: const Offset(0, 3), // Posição da sombra (x, y)
            ),
          ],
        ),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                        text: user
                            .formatDate(widget.dateHistory ?? DateTime.now()),
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
                      "Credito: ${widget.credit?.toStringAsFixed(2) ?? '0.00'}\nEstatus: ${widget.status ?? ""}"
                      "\nUsou Carta Congelar. ${widget.usedCardFreeze == true ? "Usada" : "Não Usada"}"
                      "\nUsou Carta Proteção. ${widget.usedCardProtect == true ? "Usada" : "Não Usada"}"
                      "\nEsta logado. ${widget.isLoged == true ? "Logado" : "Deslogado"}",
                      style: const TextStyle(color: Colors.white),
                    )
                  : null,
          leading: widget.history == false
              ? null
              : widget.check == true
                  ? Checkbox(
                      fillColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        if (states.contains(WidgetState.disabled)) {
                          return Colors.white.withOpacity(.32);
                        }
                        return Colors.white;
                      }),
                      focusColor: Colors.black,
                      checkColor: Colors.black,
                      value: widget.valueChack,
                      onChanged: widget.onChanged)
                  : null,
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
                        Text('Gerenciar'),
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
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ), // Ícone do botão de ação
          ),
        ),
      ),
    );
  }
}
