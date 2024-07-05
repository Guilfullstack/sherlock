import 'package:flutter/material.dart';

class ListTeamController extends StatefulWidget {
  
  final String? equipe;
   const ListTeamController({super.key, this.equipe});

  

  @override
  State<ListTeamController> createState() => _ListTeamControllerState();
}

class _ListTeamControllerState extends State<ListTeamController> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.equipe ?? "Sem nome"),
      leading: const CircleAvatar(
        child: Icon(Icons.people),
      ),
      trailing: PopupMenuButton<String>(
  onSelected: (String value) {
    // Ação a ser tomada quando um item do menu for selecionado
    print('Você selecionou: $value');
  },
  itemBuilder: (BuildContext context) {
    return [
      const PopupMenuItem<String>(
        value: 'Opção 1',
        child: Row(
          children: [
            Icon(Icons.edit),
            SizedBox(width: 8),
            Text('Opção 1'),
          ],
        ),
      ),
      const PopupMenuItem<String>(
        value: 'Opção 2',
        child: Row(
          children: [
            Icon(Icons.delete),
            SizedBox(width: 8),
            Text('Opção 2'),
          ],
        ),
      ),
      const PopupMenuItem<String>(
        value: 'Opção 3',
        child: Row(
          children: [
            Icon(Icons.share),
            SizedBox(width: 8),
            Text('Opção 3'),
          ],
        ),
      ),
    ];
  },
  icon: const Icon(Icons.more_vert), // Ícone do botão de ação
),

    );
  }
}
