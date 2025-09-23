import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter_svg/svg.dart';

class ExpandableDropdownField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dropdown Header
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? DAGRDColors.amarDAGRD
                  : (backgroundColor ?? Colors.white),
              border: Border.all(
                color: isSelected
                    ? DAGRDColors.amarDAGRD
                    : (borderColor ?? const Color(0xFFD1D5DB)),
                width: 1,
              ),
              borderRadius: isSelected
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
                    value ?? hint,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF1E1E1E)
                          : (value != null
                                ? (textColor ?? const Color(0xFF1E1E1E))
                                : const Color(0xFF1E1E1E)),
                      fontFamily: 'Work Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 24 / 16, // 150% line-height
                    ),
                  ),
                ),
                Icon(
                  isSelected
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: isSelected
                      ? const Color(0xFF1E1E1E)
                      : const Color(0xFF666666),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        // Expanded Content
        if (isSelected)
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
                ...categories.map(
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
                      margin: const EdgeInsets.only(right: 8),
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
                  // Acción para "Ver todos los niveles"
                },
                child: const Text(
                  '↓ Ver todos los niveles',
                  style: TextStyle(
                    color: Color(0xFF3B82F6),
                    fontFamily: 'Work Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Acción para "No Aplica"
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF3F4F6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'No Aplica',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontFamily: 'Work Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelButton(String level) {
    Color backgroundColor;
    if (level.contains('BAJO') && !level.contains('MEDIO')) {
      backgroundColor = const Color(0xFF10B981); // Verde
    } else if (level.contains('MEDIO')) {
      backgroundColor = DAGRDColors.amarDAGRD; // Amarillo
    } else {
      backgroundColor = const Color(0xFFEF4444); // Rojo
    }

    return GestureDetector(
      onTap: () {
        // Acción al seleccionar nivel
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            level,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1E1E1E),
              fontFamily: 'Work Sans',
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
