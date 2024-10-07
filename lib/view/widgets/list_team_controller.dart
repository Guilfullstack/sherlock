import 'package:flutter/material.dart';
import 'package:sherlock/controller/user_controller.dart';

class ListTeamController extends StatefulWidget {
  final String? equipe;
  final Function()? onTapEdit;
  final Function()? onTapRemove;
  final Function()? onTapAddValue;
  final Function()? config;
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
  final bool? usedCardLaCasaDePapel;
  final bool? isPayCardFreeze;
  final bool? isPayCardProtect;
  final bool? isPayCardLaCasaDePapel;
  final bool? isLoged;
  final bool? listStageProva;
  final bool? prisionBreak;
  final bool? listPrision;
  final bool? configEnabled;
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
    this.listStageProva,
    this.prisionBreak,
    this.listPrision,
    this.configEnabled,
    this.config,
    this.usedCardLaCasaDePapel,
    this.isPayCardFreeze,
    this.isPayCardProtect,
    this.isPayCardLaCasaDePapel,
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
          style: const TextStyle(color: Colors.blue), // Estilo normal
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
        style: const TextStyle(color: Colors.blue), // Estilo normal
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
          border: Border.all(color: Colors.blue),
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
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
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
                  ? Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                              text: "Credito: ",
                              style: TextStyle(color: Colors.white)),
                          TextSpan(
                            text: widget.credit?.toStringAsFixed(2) ?? '0.00',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          const TextSpan(
                              text: "\nEstatus: ",
                              style: TextStyle(color: Colors.white)),
                          TextSpan(
                            text: widget.status ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          if (widget.listPrision == false)
                            const TextSpan(
                                text: "\nUsou Carta Congelar: ",
                                style: TextStyle(color: Colors.white)),
                          if (widget.listPrision == false)
                            TextSpan(
                              text:
                                  widget.usedCardFreeze == true ? "Sim" : "Não",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          if (widget.listPrision == false)
                            const TextSpan(
                                text: "\nUsou Carta Proteção: ",
                                style: TextStyle(color: Colors.white)),
                          if (widget.listPrision == false)
                            TextSpan(
                              text: widget.usedCardProtect == true
                                  ? "Sim"
                                  : "Não",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          if (widget.listPrision == false)
                            const TextSpan(
                                text: "\nUsou Carta LCP: ",
                                style: TextStyle(color: Colors.white)),
                          if (widget.listPrision == false)
                            TextSpan(
                              text: widget.usedCardLaCasaDePapel == true
                                  ? "Sim"
                                  : "Não",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          if (widget.listPrision == false)
                            const TextSpan(
                                text: "\nComprou Carta Congelar: ",
                                style: TextStyle(color: Colors.white)),
                          if (widget.listPrision == false)
                            TextSpan(
                              text: widget.isPayCardFreeze == true
                                  ? "Sim"
                                  : "Não",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          if (widget.listPrision == false)
                            const TextSpan(
                                text: "\nComprou Carta Proteção: ",
                                style: TextStyle(color: Colors.white)),
                          if (widget.listPrision == false)
                            TextSpan(
                              text: widget.isPayCardProtect == true
                                  ? "Sim"
                                  : "Não",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          if (widget.listPrision == false)
                            const TextSpan(
                                text: "\nComprou Carta LCP: ",
                                style: TextStyle(color: Colors.white)),
                          if (widget.listPrision == false)
                            TextSpan(
                              text: widget.isPayCardLaCasaDePapel == true
                                  ? "Sim"
                                  : "Não",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          const TextSpan(
                              text: "\nPrisão: ",
                              style: TextStyle(color: Colors.white)),
                          TextSpan(
                            text:
                                widget.prisionBreak == true ? "Preso" : "Livre",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          const TextSpan(
                              text: "\nEsta logado: ",
                              style: TextStyle(color: Colors.white)),
                          TextSpan(
                            text:
                                widget.isLoged == true ? "Logado" : "Deslogado",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ],
                      ),
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
          trailing: widget.listStageProva == true
              ? null
              : PopupMenuButton<String>(
                  tooltip: "Menu",
                  color: Colors.black,
                  itemBuilder: (BuildContext context) {
                    return [
                      if (widget.history == true || widget.listPrision == true)
                        PopupMenuItem<String>(
                          onTap: widget.onTapEdit,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.prisionBreak == true
                                    ? "Abrir"
                                    : "Editar",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      if (widget.remove == true)
                        PopupMenuItem<String>(
                          onTap: widget.onTapRemove,
                          child: const Row(
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Remover',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      if (widget.addValue == true)
                        PopupMenuItem<String>(
                          onTap: widget.onTapAddValue,
                          child: const Row(
                            children: [
                              Icon(
                                Icons.task,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Gerenciar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      if (widget.configEnabled == true)
                        PopupMenuItem<String>(
                          onTap: widget.config,
                          child: const Row(
                            children: [
                              Icon(
                                Icons.settings_applications_outlined,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Config.Avançadas',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                    ];
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.blue,
                  ), // Ícone do botão de ação
                ),
        ),
      ),
    );
  }
}
