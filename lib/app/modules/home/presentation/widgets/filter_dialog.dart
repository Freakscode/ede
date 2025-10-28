import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/custom_date_picker.dart';

class FilterDialog extends StatefulWidget {
  final bool isUserAuthenticated;
  
  const FilterDialog({
    super.key,
    this.isUserAuthenticated = false,
  });

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    bool isUserAuthenticated = false,
  }) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return FilterDialog(isUserAuthenticated: isUserAuthenticated);
      },
    );
  }

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedPhenomenon = 'Todos';
  final TextEditingController _sireNumberController = TextEditingController();

  @override
  void dispose() {
    _sireNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Text(
                  'Filtrar por:',
                  style: TextStyle(
                    color: Color(0xFF706F6F), // GrisDAGRD
                    fontFamily: 'Work Sans',
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    height: 18.066 / 14, // 129.041%
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Rango de fechas
            _buildSection(
              title: 'Rango de fechas',
              onClear: () {
                setState(() {
                  _startDate = null;
                  _endDate = null;
                });
              },
              child: Row(
                children: [
                  Expanded(
                    child: CustomDatePicker(
                      label: 'Desde',
                      selectedDate: _startDate,
                      onDateSelected: (date) {
                        setState(() {
                          _startDate = date;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomDatePicker(
                      label: 'Hasta',
                      selectedDate: _endDate,
                      onDateSelected: (date) {
                        setState(() {
                          _endDate = date;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Fenómeno amenazante
            _buildSection(
              title: 'Fenómeno amenazante',
              onClear: () {
                setState(() {
                  _selectedPhenomenon = 'Todos';
                });
              },
              child: Container(
                padding: const EdgeInsets.only(top: 6, right: 10, bottom: 6, left: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD1D5DB), width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _selectedPhenomenon,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ['Todos', 'Movimiento en Masa', 'Inundación', 'Sequía', 'Incendio', 'Otros']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: Color(0xFF1E1E1E), // Textos
                          fontFamily: 'Work Sans',
                          fontSize: 13,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          height: 22 / 13, // 169.231%
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPhenomenon = newValue ?? 'Todos';
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Número SIRE - Solo visible si el usuario está autenticado
            if (widget.isUserAuthenticated) ...[
              _buildSection(
                title: 'Número SIRE',
                onClear: () {
                  setState(() {
                    _sireNumberController.clear();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 6, right: 10, bottom: 6, left: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFD1D5DB), width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _sireNumberController,
                    decoration: const InputDecoration(
                      hintText: 'Ingrese número de caso',
                      hintStyle: TextStyle(
                        color: Color(0xFFCCCCCC),
                        fontFamily: 'Work Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Work Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFD1D5DB), width: 1),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontFamily: 'Work Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop({
                        'startDate': _startDate,
                        'endDate': _endDate,
                        'phenomenon': _selectedPhenomenon,
                        'sireNumber': _sireNumberController.text,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DAGRDColors.azulDAGRD,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Aplicar filtros',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Work Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required VoidCallback onClear,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1E1E1E), // Textos
                fontFamily: 'Work Sans',
                fontSize: 18,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                height: 1.0,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: onClear,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Borrar',
                style: TextStyle(
                  color: Color(0xFF232B48), // AzulDAGRD
                  fontFamily: 'Work Sans',
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

