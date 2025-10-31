import 'package:caja_herramientas/app/core/theme/theme_colors.dart';
import 'package:flutter/material.dart';

// Constantes para mejor mantenimiento
const double _animationDuration = 300.0;
const double _maxDropdownHeight = 200.0;
const int _listViewThreshold = 5;

/// Un dropdown personalizado que se expande y contrae con animaciones suaves.
/// 
/// Este widget es genérico y puede manejar cualquier tipo de datos.
/// Utiliza AnimatedSize para transiciones suaves y ListView.builder para
/// optimizar el rendimiento con listas grandes.
class CustomExpandableDropdown<T> extends StatefulWidget {
  /// Etiqueta que se muestra arriba del campo
  final String label;
  
  /// Valor actualmente seleccionado
  final T? value;
  
  /// Lista de opciones disponibles
  final List<T> items;
  
  /// Callback que se ejecuta cuando se selecciona un item
  final ValueChanged<T?> onChanged;
  
  /// Función de validación opcional
  final String? Function(T?)? validator;
  
  /// Función que construye el texto a mostrar para cada item
  final String Function(T) itemBuilder;
  
  /// Texto placeholder cuando no hay valor seleccionado
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
    extends State<CustomExpandableDropdown<T>> {
  bool _isExpanded = false;
  String? _errorText;

  @override
  void didUpdateWidget(CustomExpandableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Si el valor cambió, cerrar el dropdown si está abierto
    if (oldWidget.value != widget.value) {
      if (_isExpanded) {
        setState(() {
          _isExpanded = false;
        });
      }
      // Limpiar error si el valor cambió
      if (_errorText != null) {
        setState(() {
          _errorText = null;
        });
      }
    }
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _selectItem(T item) {
    widget.onChanged(item);
    setState(() {
      _isExpanded = false;
      _errorText = null;
    });
  }

  Widget _buildDropdownItem(T item, int index) {
    final isLast = index == widget.items.length - 1;
    return InkWell(
      onTap: () => _selectItem(item),
      borderRadius: isLast
          ? const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            )
          : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          border: !isLast
              ? Border(
                  bottom: BorderSide(
                    color: ThemeColors.grisMedio.withOpacity(0.3),
                    width: 0.5,
                  ),
                )
              : null,
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
            color: ThemeColors.azulDAGRD,
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
          child: Semantics(
            label: '${widget.label}. ${widget.value != null ? widget.itemBuilder(widget.value as T) : widget.hintText}',
            hint: 'Toca para abrir opciones',
            button: true,
            child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: ThemeColors.blancoDAGRD,
              border: Border.all(color: ThemeColors.grisMedio, width: 1),
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
                  duration: Duration(milliseconds: _animationDuration.round()),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: ThemeColors.grisMedio,
                    size: 20,
                  ),
                ),
              ],
            ),
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
                color: ThemeColors.error,
                fontFamily: 'Work Sans',
                fontSize: 12,
              ),
            ),
          ),

        // Expandable container
        AnimatedSize(
          duration: Duration(milliseconds: _animationDuration.round()),
          curve: Curves.easeInOut,
          child: _isExpanded
              ? Container(
                  constraints: const BoxConstraints(
                    maxHeight: _maxDropdownHeight,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColors.blancoDAGRD,
                    border: Border.all(color: ThemeColors.grisMedio, width: 1),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: widget.items.length > _listViewThreshold
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.items.length,
                          itemBuilder: (context, index) {
                            final item = widget.items[index];
                            return _buildDropdownItem(item, index);
                          },
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: widget.items.asMap().entries.map((entry) {
                            return _buildDropdownItem(entry.value, entry.key);
                          }).toList(),
                        ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
