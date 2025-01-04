import 'package:flutter/material.dart';
import '../../../blocs/form/identificacionEvaluacion/id_evaluacion_state.dart';

class EventoButton extends StatelessWidget {
  final TipoEvento evento;
  final bool isSelected;
  final VoidCallback onPressed;

  const EventoButton({
    super.key,
    required this.evento,
    required this.isSelected,
    required this.onPressed,
  });

  IconData _getIconForEvento(TipoEvento evento) {
    switch (evento) {
      case TipoEvento.inundacion:
        return Icons.water;
      case TipoEvento.deslizamiento:
        return Icons.landscape;
      case TipoEvento.sismo:
        return Icons.vibration;
      case TipoEvento.viento:
        return Icons.air;
      case TipoEvento.incendio:
        return Icons.local_fire_department;
      case TipoEvento.explosion:
        return Icons.flash_on;
      case TipoEvento.estructural:
        return Icons.home_work;
      case TipoEvento.otro:
        return Icons.more_horiz;
    }
  }

  String _getNombreEvento(TipoEvento evento) {
    switch (evento) {
      case TipoEvento.inundacion:
        return 'Inundación';
      case TipoEvento.deslizamiento:
        return 'Deslizamiento';
      case TipoEvento.sismo:
        return 'Sismo';
      case TipoEvento.viento:
        return 'Viento';
      case TipoEvento.incendio:
        return 'Incendio';
      case TipoEvento.explosion:
        return 'Explosión';
      case TipoEvento.estructural:
        return 'Estructural';
      case TipoEvento.otro:
        return 'Otro';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconForEvento(evento),
                size: 32,
                color: isSelected ? Colors.white : Colors.black87,
              ),
              const SizedBox(height: 8),
              Text(
                _getNombreEvento(evento),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
