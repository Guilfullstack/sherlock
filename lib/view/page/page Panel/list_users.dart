import 'package:flutter/material.dart';

class ListUsers<T> extends StatelessWidget {
  final Stream<List<T>> stream;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final String emptyMessage;
  final String errorMessage;
  final double size;
  final double aspectRatio; // Novo parâmetro para o aspecto
  final int? columGrid;

  const ListUsers({
    super.key,
    required this.stream,
    required this.itemBuilder,
    required this.emptyMessage,
    required this.errorMessage,
    required this.size,
    this.columGrid,
    this.aspectRatio = 1.0, // Valor padrão para o aspecto
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

        return LayoutBuilder(
          builder: (context, constraints) {
            // Calcular o número de colunas baseado na largura disponível
            double width = constraints.maxWidth;
            int columns =
                columGrid ?? (width ~/ size).clamp(1, 4); // 1 a 4 colunas

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 10.0, // Espaço horizontal entre os itens
                mainAxisSpacing: 10.0, // Espaço vertical entre os itens
                childAspectRatio:
                    aspectRatio, // Ajuste o aspecto dos itens (largura/altura)
              ),
              itemCount: listData.length,
              itemBuilder: (context, index) {
                return itemBuilder(context, listData[index], index);
              },
            );
          },
        );
      },
    );
  }
}
