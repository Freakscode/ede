import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';

class CustomExpandableDropdown<T> extends StatefulWidget {
  final String label;
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final String Function(T) itemBuilder;
  final String hintText;

  const CustomExpandableDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    required this.itemBuilder,
    this.hintText = 'Seleccione una opción',
  });

  @override
  State<CustomExpandableDropdown<T>> createState() =>
      _CustomExpandableDropdownState<T>();
}

class _CustomExpandableDropdownState<T>
    extends State<CustomExpandableDropdown<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _selectItem(T item) {
    widget.onChanged(item);
    setState(() {
      _isExpanded = false;
      _errorText = null;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: const TextStyle(
            color: DAGRDColors.azulDAGRD,
            fontFamily: 'Work Sans',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.33333, // 16px / 12px = 1.33333 (133.333%)
          ),
        ),
        const SizedBox(height: 8),

        // Input field
        GestureDetector(
          onTap: _toggleExpansion,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: DAGRDColors.blancoDAGRD,
              border: Border.all(color: DAGRDColors.grisMedio, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.value != null
                        ? widget.itemBuilder(widget.value as T)
                        : widget.hintText,
                    style: TextStyle(
                      color: widget.value != null
                          ? const Color(0xFF1E1E1E)
                          : const Color(0xFFCCCCCC),
                      fontFamily: 'Work Sans',
                      fontSize: widget.value != null ? 14 : 12,
                      fontWeight: widget.value != null
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: DAGRDColors.grisMedio,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Error text
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _errorText!,
              style: const TextStyle(
                color: DAGRDColors.error,
                fontFamily: 'Work Sans',
                fontSize: 12,
              ),
            ),
          ),

        // Expandable container
        ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: _expandAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: DAGRDColors.blancoDAGRD,
                border: Border.all(color: DAGRDColors.grisMedio, width: 1),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: widget.items.map((T item) {
                  return InkWell(
                    onTap: () => _selectItem(item),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        widget.itemBuilder(item),
                        style: const TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontFamily: 'Work Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
