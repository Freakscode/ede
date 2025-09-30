import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:caja_herramientas/app/shared/models/models.dart';

class ExpandableDropdownField extends StatefulWidget {
  final String hint;
  final String? value;
  final bool isSelected;
  final VoidCallback? onTap;
  final List<DropdownCategory> categories;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? textColor;
  final Function(String category, String level)? onSelectionChanged;
  final Map<String, dynamic>? calculationDetails;

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
    this.onSelectionChanged,
    this.calculationDetails,
  });

  @override
  State<ExpandableDropdownField> createState() =>
      _ExpandableDropdownFieldState();
}

class _ExpandableDropdownFieldState extends State<ExpandableDropdownField> {
  Map<String, bool> _expandedCategories = {};
  Map<String, String?> _selectedLevels = {}; // Para almacenar el nivel seleccionado por categoría

  // Método helper para obtener el valor numérico del nivel seleccionado
  int _getSelectedLevelValue(String categoryTitle) {
    final selectedLevel = _selectedLevels[categoryTitle];
    if (selectedLevel == null) return 0;
    
    // Mapear los niveles a sus valores numéricos
    if (selectedLevel.contains('BAJO') && !selectedLevel.contains('MEDIO')) {
      return 1;
    } else if (selectedLevel.contains('MEDIO') && selectedLevel.contains('ALTO')) {
      return 3;
    } else if (selectedLevel.contains('MEDIO')) {
      return 2;
    } else if (selectedLevel.contains('ALTO')) {
      return 4;
    }
    return 0;
  }

  // Método para calcular el promedio usando wi (wi × valor) dividido por total de selecciones
  double _calculateAverageScore() {
    if (widget.calculationDetails == null) {
      // Fallback al método anterior si no hay datos de wi
      if (_selectedLevels.isEmpty) return 0.0;
      
      final selectedCategories = widget.categories.where((category) => 
          _selectedLevels[category.title] != null).toList();
      
      if (selectedCategories.isEmpty) return 0.0;
      
      double totalScore = 0.0;
      int count = 0;
      
      for (final category in selectedCategories) {
        final value = _getSelectedLevelValue(category.title);
        if (value > 0) {
          totalScore += value;
          count++;
        }
      }
      
      return count > 0 ? totalScore / count : 0.0;
    }
    
    // Usar datos de wi del calculationDetails
    final categories = widget.calculationDetails!['categories'] as List<Map<String, dynamic>>?;
    if (categories == null || categories.isEmpty) return 0.0;
    
    double totalCalificacion = 0.0;
    int validCategories = 0;
    
    for (final categoryData in categories) {
      final calificacion = categoryData['calificacion'] as int? ?? 0;
      if (calificacion > 0) {
        totalCalificacion += calificacion.toDouble();
        validCategories++;
      }
    }
    
    return validCategories > 0 ? totalCalificacion / validCategories : 0.0;
  }

  // Método para obtener el color dinámico basado en el promedio
  Color _getScoreColor() {
    final score = _calculateAverageScore();
    
    if (score == 0) {
      return Colors.transparent; // No mostrar si no hay score
    } else if (score <= 1.5) {
      return const Color(0xFF22C55E); // Verde - BAJO
    } else if (score <= 2.5) {
      return const Color(0xFFFDE047); // Amarillo - MEDIO
    } else if (score <= 3.5) {
      return const Color(0xFFFB923C); // Naranja - MEDIO-ALTO  
    } else {
      return const Color(0xFFDC2626); // Rojo - ALTO
    }
  }

  // Método para verificar si debe mostrar el container
  bool _shouldShowScoreContainer() {
    final score = _calculateAverageScore();
    return score > 0;
  }

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
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
                    ],
                  ),
                ),
                if (_shouldShowScoreContainer())
                  Container(
                    width: 50,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: _getScoreColor(),
                    ),
                    child: Center(
                      child: Text(
                        _calculateAverageScore().toStringAsFixed(1).replaceAll('.', ','),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFFFFFFF), // #FFF
                          fontFamily: 'Work Sans',
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700,
                          height: 16 / 14, // 114.286% line-height (16px/14px)
                        ),
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
                    category,
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
    DropdownCategory category,
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
                  category.title,
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
                child: Center(
                  child: Text(
                    _getSelectedLevelValue(category.title).toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _selectedLevels[category.title] != null 
                          ? const Color(0xFF1E1E1E)
                          : const Color(0xFFD1D5DB),
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
            children: category.levels
                .map(
                  (level) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 4),
                      child: _buildLevelButton(level, category.title),
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
                    _expandedCategories[category.title] = !(_expandedCategories[category.title] ?? false);
                  });
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      (_expandedCategories[category.title] ?? false)
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
                      (_expandedCategories[category.title] ?? false)
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
          if (_expandedCategories[category.title] ?? false) ...[
            const SizedBox(height: 16),
            _buildDetailedLevels(category),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailedLevels(DropdownCategory category) {
    final detailedLevels = category.detailedLevels ?? _getDefaultDetailedLevels();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...detailedLevels.map((level) => _buildDetailedLevelItem(level)),
      ],
    );
  }

  Widget _buildDetailedLevelItem(RiskLevel level) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: level.color),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: level.color,
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
                  children: _parseTitle(level.title),
                ),
              ),
            ),
            if (level.description != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  level.description!,
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
            if (level.items != null) ...[
              const SizedBox(height: 8),
              ...(level.items!.map(
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
            if (level.note != null) ...[
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
                    children: _parseNote(level.note!),
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

  List<RiskLevel> _getDefaultDetailedLevels() {
    // Datos de ejemplo basados en la imagen
    return [
      RiskLevel.bajo(),
      RiskLevel.medioBajo(),
      RiskLevel.medioAlto(),
      RiskLevel.alto(),
    ];
  }

  Widget _buildLevelButton(String level, String categoryTitle) {
    bool isSelected = _selectedLevels[categoryTitle] == level;
    
    Color backgroundColor;
    Color selectedBackgroundColor;
    
    if (level.contains('BAJO') && !level.contains('MEDIO')) {
      backgroundColor = const Color(0xFFDCFCE7); // Verde claro desactivado
      selectedBackgroundColor = const Color(0xFF22C55E); // Verde activado
    } else if (level.contains('MEDIO') && level.contains('ALTO')) {
      backgroundColor = const Color(0xFFFFEDD5); // Naranja claro desactivado
      selectedBackgroundColor = const Color(0xFFFB923C); // Naranja activado
    } else if (level.contains('MEDIO')) {
      backgroundColor = const Color(0xFFFEF9C3); // Amarillo claro desactivado
      selectedBackgroundColor = const Color(0xFFFDE047); // Amarillo activado
    } else {
      backgroundColor = const Color(0xFFFEE2E2); // Rojo claro desactivado
      selectedBackgroundColor = const Color(0xFFDC2626); // Rojo activado
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          // Si el nivel ya está seleccionado, deseleccionarlo
          if (_selectedLevels[categoryTitle] == level) {
            _selectedLevels[categoryTitle] = null;
          } else {
            // Seleccionar el nuevo nivel
            _selectedLevels[categoryTitle] = level;
            
            // Notificar la selección si hay callback
            if (widget.onSelectionChanged != null) {
              widget.onSelectionChanged!(categoryTitle, level);
            }
          }
        });
      },
      child: Container(
        width: 80,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? selectedBackgroundColor : backgroundColor,
          borderRadius: BorderRadius.circular(4),
          border: isSelected 
              ? Border.all(color: selectedBackgroundColor, width: 2)
              : null,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                level,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF000000),
                  fontFamily: 'Work Sans',
                  fontSize: 12,
                  fontWeight: isSelected 
                      ? FontWeight.w600 
                      : FontWeight.w400,
                  height: 1.2,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }


}
