import 'package:flutter/material.dart';

class ListUsersStaff<T> extends StatelessWidget {
  final Stream<List<T>> stream;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final String emptyMessage;
  final String errorMessage;

  const ListUsersStaff({
    super.key,
    required this.stream,
    required this.itemBuilder,
    required this.emptyMessage,
    required this.errorMessage,
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

        return ListView.builder(
          itemCount: listData.length,
          itemBuilder: (context, index) {
            return itemBuilder(context, listData[index], index);
          },
        );
      },
    );
  }
}
