import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';
import 'widgets/label_bubble.dart';
import 'widgets/lines_painter.dart';
import 'widgets/line_model.dart';


/// ---------------------------
/// Overlay tipo "póster" + labels
/// ---------------------------
class TutorialPosterOverlayScreen extends StatelessWidget {
  TutorialPosterOverlayScreen({super.key});

  final _labelData = [
    _LabelData(
      textTop: 'Botón\nir atrás',
      position: Offset(0.4, 0),
      align: Alignment.centerRight,
    ),
    _LabelData(
      textTop: 'Botón información\nde ayuda para cada sección',
      position: Offset(0.69, 0),
      align: Alignment.bottomCenter,
    ),
    _LabelData(
      textTop: 'Botón\ninicio\nde sesión\nUsuarios\nDAGRD',
      position: Offset(1.15, 0.15),
      align: Alignment.centerLeft,
    ),
    _LabelData(
      textTop: 'Menú de acciones principales',
      position: Offset(0.38, 1.28),
      align: Alignment.bottomCenter,
    ),
  ];

  final _lineData = [
    // from: punto en la imagen (relativo), to: punto del label (relativo)
    // Line(from: Offset(0.13, 0.13), to: Offset(0.13, 0.08)), // back
    Line(from: Offset(0.62, 0.14), to: Offset(0.75, 0.14)), // info (más corta)
    Line(from: Offset(0.49, 0.10), to: Offset(0.49, 0.02)), // profile

    // Menú de acciones principales (línea amarilla con 3 puntos y esquinas)
    // Ajusta estos valores para que coincidan visualmente con tu póster
    // Línea horizontal inferior
    Line(from: Offset(0.1, 1.05), to: Offset(0.62, 1.05)),
    // Línea vertical izquierda
    Line(from: Offset(0.1, 1.05), to: Offset(0.1, 0.97)),
    // // Línea vertical centro
    Line(from: Offset(0.28, 1.05), to: Offset(0.28, 0.97)),
    Line(from: Offset(0.45, 1.05), to: Offset(0.45, 0.97)),
    Line(from: Offset(0.62, 1.05), to: Offset(0.62, 0.97)),
    // // Línea vertical derecha
  ];


  void _close(BuildContext context) => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.black.withOpacity(0.68),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => _close(context),
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  ),
                ],
              ),
              // Título centrado
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bienvenidos a la aplicación',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Work Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 16 / 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  RichText(
                    textAlign: TextAlign.start,
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.w500,
                        height: 1.0,
                      ),
                      children: [
                        TextSpan(
                          text: 'Caja de\n',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: 'Herramientas\n',
                          style: TextStyle(
                            color: Color(0xFFFFCC00),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: 'DAGRD',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final posterWidth = constraints.maxWidth * 0.78 > 400 ? 400.0 : constraints.maxWidth * 0.9;
                  final posterHeight = posterWidth * 1.7;
                  final stackHeight = posterHeight * 1.20; // más alto para labels arriba/abajo
                  return Container(
                    width: posterWidth,
                    height: stackHeight,
                    color: Colors.red.withOpacity(0.2), // Color temporal para debug
                    child: Stack(
                      children: [
                        // Imagen del póster centrada verticalmente
                        Positioned(
                          left: 0,
                          right: 100,
                          top: (stackHeight - posterHeight) / 1.25,
                          child: Container(
                            // width: posterWidth,
                            height: posterHeight * 0.78,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              'assets/images/home_poster.png',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        // Líneas amarillas
                        Positioned(
                          left: 0,
                          right: 0,
                          top: (stackHeight - posterHeight) / 2,
                          child: SizedBox(
                            width: posterWidth,
                            height: posterHeight,
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: LinesPainter(
                                  lines: _lineData
                                      .map(
                                        (l) => Line(
                                          from: Offset(
                                            l.from.dx * posterWidth,
                                            l.from.dy * posterHeight,
                                          ),
                                          to: Offset(
                                            l.to.dx * posterWidth,
                                            l.to.dy * posterHeight,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Labels
                        ..._labelData.map(
                          (l) => Positioned(
                            left: l.position.dx * posterWidth - 110,
                            top: (stackHeight - posterHeight) / 2 + l.position.dy * posterHeight - 34,
                            child: LabelBubble(
                              top: l.textTop,
                              bottom: l.textBottom,
                              align: l.align,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Checkbox “No volver a mostrar” (solo visual, deshabilitado)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(color: Color(0xFFAAAAAA), width: 1),
                      ),
                      child: Checkbox(
                        value: false,
                        onChanged: null, // Deshabilitado
                        activeColor: DAGRDColors.azulDAGRD,
                        checkColor: Colors.white,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'No volver a mostrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Metropolis',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabelData {
  final String textTop;
  final String? textBottom;
  final Offset position; // centro aproximado de la burbuja
  final Alignment align;
  _LabelData({
    required this.textTop,
    this.textBottom,
    required this.position,
    this.align = Alignment.centerLeft,
  });
}




