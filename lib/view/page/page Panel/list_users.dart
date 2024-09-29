import 'package:flutter/material.dart';

class ListUsers<T> extends StatelessWidget {
  final Stream<List<T>> stream;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final String emptyMessage;
  final String errorMessage;
  final double size;
  final int? columGrid;

  const ListUsers({
    super.key,
    required this.stream,
    required this.itemBuilder,
    required this.emptyMessage,
    required this.errorMessage,
    required this.size, this.columGrid,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<T>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          debugPrint("${snapshot.error}");
          return Center(child: Text(errorMessage));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(emptyMessage));
        }

        final listData = snapshot.data!;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columGrid ?? 2, // Número de colunas
            crossAxisSpacing: 10.0, // Espaço horizontal entre os itens
            mainAxisSpacing: 10.0, // Espaço vertical entre os itens
            childAspectRatio:
                size, // Ajuste o aspecto dos itens (largura/altura)
          ),
          itemCount: listData.length,
          itemBuilder: (context, index) {
            return itemBuilder(context, listData[index], index);
          },
        );
      },
    );
  }
}
