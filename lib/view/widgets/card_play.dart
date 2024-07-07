import 'package:flutter/material.dart';

enum CartaTipo { escudo, congelar }

class CardPlay extends StatelessWidget {
  final String src;
  final bool isUsed;
  final CartaTipo tipo;
  const CardPlay({
    Key? key,
    required this.src,
    required this.isUsed,
    required this.tipo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 70,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white, // Cor da borda
          width: 2.0, // Largura da borda
        ),
        borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
      ),
      child: isUsed
          ? CustomPaint(
              size: const Size(100, 100),
              painter: tipo == CartaTipo.escudo
                  ? EscudoPainter()
                  : CongelarPainter(),
            )

          /*Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset(
                  src,
                  width: 44,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ],
            )*/
          : const Center(
              child: Icon(
                Icons.add,
                size: 20,
                color: Colors.white,
              ),
            ),
    );
  }
}

class EscudoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 3)
      ..lineTo(size.width * 3 / 4, size.height)
      ..lineTo(size.width / 4, size.height)
      ..lineTo(0, size.height / 3)
      ..close();

    canvas.drawPath(path, paint);

    paint.color = Colors.white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.0;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CongelarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.lightBlue
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width * 3 / 4, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width / 4, size.height / 2)
      ..close();

    canvas.drawPath(path, paint);

    paint.color = Colors.white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.0;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
