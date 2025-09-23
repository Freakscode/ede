import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter_svg/svg.dart';

class ExpandableDropdownField extends StatefulWidget {
  final String hint;
  final String? value;
  final bool isSelected;
  final VoidCallback? onTap;
  final List<Map<String, dynamic>> categories;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? textColor;

  const ExpandableDropdownField({
    super.key,
    required this.hint,
    required this.isSelected,
    required this.categories,
    this.value,
    this.onTap,
    this.borderColor,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<ExpandableDropdownField> createState() =>
      _ExpandableDropdownFieldState();
}

class _ExpandableDropdownFieldState extends State<ExpandableDropdownField> {
  bool _isDetailsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dropdown Header
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? DAGRDColors.amarDAGRD
                  : (widget.backgroundColor ?? Colors.white),
              border: Border.all(
                color: widget.isSelected
                    ? DAGRDColors.amarDAGRD
                    : (widget.borderColor ?? const Color(0xFFD1D5DB)),
                width: 1,
              ),
              borderRadius: widget.isSelected
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    )
                  : BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.value ?? widget.hint,
                    style: TextStyle(
                      color: widget.isSelected
                          ? const Color(0xFF1E1E1E)
                          : (widget.value != null
                                ? (widget.textColor ?? const Color(0xFF1E1E1E))
                                : const Color(0xFF1E1E1E)),
                      fontFamily: 'Work Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 24 / 16, // 150% line-height
                    ),
                  ),
                ),
                Icon(
                  widget.isSelected
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: widget.isSelected
                      ? const Color(0xFF1E1E1E)
                      : const Color(0xFF666666),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        // Expanded Content
        if (widget.isSelected)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD1D5DB)),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ...widget.categories.map(
                  (category) => _buildCategorySection(
                    context,
                    category['title'] as String,
                    category['levels'] as List<String>,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String title,
    List<String> levels,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontFamily: 'Work Sans',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 18 / 15, // 120% line-height
                  ),
                ),
              ),
              SvgPicture.asset(
                AppIcons.info,
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF1E1E1E),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                ),
                child: const Center(
                  child: Text(
                    '0',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFD1D5DB),
                      fontFamily: 'Work Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 16 / 20, // 80% line-height
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: levels
                .map(
                  (level) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 4),
                      child: _buildLevelButton(level),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isDetailsExpanded = !_isDetailsExpanded;
                  });
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      _isDetailsExpanded
                          ? AppIcons.arrowUp
                          : AppIcons.arrowDown,
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF2563EB),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isDetailsExpanded
                          ? 'Ocultar detalles'
                          : 'Ver todos los niveles',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontFamily: 'Work Sans',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 16 / 15, // 106.667% line-height
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Acción para "No Aplica"
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF9FAFB),
                  minimumSize: const Size(0, 30),
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'No Aplica',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontFamily: 'Work Sans',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 16 / 15, // 106.667% line-height
                  ),
                ),
              ),
            ],
          ),
          // Contenido expandible con detalles
          if (_isDetailsExpanded) ...[
            const SizedBox(height: 16),
            _buildDetailedLevels(title),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailedLevels(String categoryTitle) {
    final detailedLevels = _getDetailedLevelsForCategory(categoryTitle);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...detailedLevels.map((level) => _buildDetailedLevelItem(level)),
      ],
    );
  }

  Widget _buildDetailedLevelItem(Map<String, dynamic> level) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: level['color'] as Color),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: level['color'] as Color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontFamily: 'Work Sans',
                    fontSize: 12,
                    height: 16 / 12, // 133.333% line-height
                  ),
                  children: _parseTitle(level['title'] as String),
                ),
              ),
            ),
            if (level['description'] != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  level['description'] as String,
                  style: const TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontFamily: 'Work Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    height: 20 / 12, // 166.667% line-height
                  ),
                ),
              ),
            ],
            if (level['items'] != null) ...[
              const SizedBox(height: 8),
              ...((level['items'] as List<String>).map(
                (item) => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontFamily: 'Work Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                            color: Color(0xFF1E1E1E),
                            fontFamily: 'Work Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            height: 20 / 12, // 166.667% line-height (20px/12px)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ],
            if (level['note'] != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(10),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontFamily: 'Work Sans',
                      fontSize: 12,
                      height: 20 / 12, // 166.667% line-height (20px/12px)
                    ),
                    children: _parseNote(level['note'] as String),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<TextSpan> _parseTitle(String title) {
    // Buscar el patrón "BAJO (1):", "MEDIO - BAJO (2):", etc.
    final regex = RegExp(r'^([A-Z\s\-]+\s\(\d+\):)\s*(.*)$');
    final match = regex.firstMatch(title);

    if (match != null) {
      return [
        TextSpan(
          text: match.group(1), // La parte en negrita (ej: "BAJO (1):")
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        if (match.group(2)?.isNotEmpty == true)
          TextSpan(
            text: ' ${match.group(2)}', // El resto del texto en peso normal
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
      ];
    }

    // Si no coincide con el patrón, devolver todo en peso normal
    return [
      TextSpan(
        text: title,
        style: const TextStyle(fontWeight: FontWeight.w400),
      ),
    ];
  }

  List<TextSpan> _parseNote(String note) {
    // Buscar el patrón "NOTA:" al inicio
    if (note.startsWith('NOTA:')) {
      return [
        const TextSpan(
          text: 'NOTA:',
          style: TextStyle(fontWeight: FontWeight.w500), // Medium para "NOTA:"
        ),
        TextSpan(
          text: note.substring(5), // El resto del texto en peso normal
          style: const TextStyle(fontWeight: FontWeight.w300),
        ),
      ];
    }

    // Si no empieza con "NOTA:", devolver todo en peso normal
    return [
      TextSpan(
        text: note,
        style: const TextStyle(fontWeight: FontWeight.w400),
      ),
    ];
  }

  List<Map<String, dynamic>> _getDetailedLevelsForCategory(String category) {
    // Datos de ejemplo basados en la imagen
    return [
      {
        'title':
            'BAJO (1): Las características del escenario sugieren que la probabilidad de que se presente el evento es mínima',
        'color': const Color(0xFF22C55E),
        'items': [
          'Pendientes bajos modeladas en suelos (< 5°).',
          'Pendientes bajas, medias o altas, modeladas en roca sana o levemente meteorizada sin fracturas.',
        ],
      },
      {
        'title': 'MEDIO - BAJO (2): Las características del escenario sugieren que es poco probable de que se presente el evento',
        'color': const Color(0xFFFDE047),
        'items': [
          'Pendientes moderadas modeladas en suelos (5° - 15°).',
          'Pendientes bajas modeladas en suelos (< 5°), en condiciones saturadas.',
        ],
      },
      {
        'title': 'MEDIO - ALTO (3): Las características del escenario sugieren la probabilidad moderada de que se presente el evento.',
        'color': const Color(0xFFFB923C),
        'items': [
          'Pendientes altas modeladas en suelos (15° - 30°).',
          'Pendientes moderadas modeladas en suelos (5° - 15°), en condiciones saturadas.',
        ],
      },
      {
        'title': 'ALTO (4): Las características del escenario sugieren la probabilidad de que se presente el evento.',
        'color': const Color(0xFFDC2626),
        'items': [
          'Pendientes medias o altas modeladas en roca fracturada.',
          'Pendientes muy altas modeladas en suelos (> 30°).',
          'Pendientes altas modeladas en suelos (15° - 30°), en condiciones saturadas.',
          'Pendientes medias o altas, modeladas en llenos antrópicos.',
        ],
        'note': 'NOTA: En caso de tratarse de llenos antrópicos constituidos sin sustento técnico (vertimiento libre de materiales de excavación, escombros y basuras)',
      },
    ];
  }

  Widget _buildLevelButton(String level) {
    Color backgroundColor;
    if (level.contains('BAJO') && !level.contains('MEDIO')) {
      backgroundColor = const Color(0xFF22C55E); // Verde
    } else if (level.contains('MEDIO') && level.contains('ALTO')) {
      backgroundColor = const Color(0xFFFB923C); // Naranja para MEDIO ALTO
    } else if (level.contains('MEDIO')) {
      backgroundColor = const Color(0xFFFDE047); // Amarillo
    } else {
      backgroundColor = const Color(0xFFDC2626); // Rojo
    }

    return GestureDetector(
      onTap: () {
        // Acción al seleccionar nivel
      },
      child: Container(
        width: 80,
        height: 50,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            level,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF000000),
              fontFamily: 'Work Sans',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 16 / 12, // 133.333% line-height
            ),
          ),
        ),
      ),
    );
  }
}
