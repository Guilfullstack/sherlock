import 'package:flutter/material.dart';

class ListTeamController extends StatefulWidget {
  final String? equipe;
  final Function()? onTapEdit;
  final Function()? onTapRemove;
  final Function()? onTapAddValue;
  final double? credit;
  final String? status;
  final String? category;
  final bool? user;
  final bool? code;
  final bool? stage;
  final bool? addValue;
  final bool? history;
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
  });

  @override
  State<ListTeamController> createState() => _ListTeamControllerState();
}

class _ListTeamControllerState extends State<ListTeamController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          widget.equipe ?? "Sem nome",
          style: TextStyle(
            color: ThemeData().primaryColorLight,
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
