import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/shared/models/models.dart';
import 'risk_threat_analysis_event.dart';
import 'risk_threat_analysis_state.dart';

class RiskThreatAnalysisBloc extends Bloc<RiskThreatAnalysisEvent, RiskThreatAnalysisState> {
  RiskThreatAnalysisBloc() : super(const RiskThreatAnalysisState()) {
    on<ToggleProbabilidadDropdown>(_onToggleProbabilidadDropdown);
    on<ToggleIntensidadDropdown>(_onToggleIntensidadDropdown);
    on<SelectProbabilidad>(_onSelectProbabilidad);
    on<SelectIntensidad>(_onSelectIntensidad);
    on<ResetDropdowns>(_onResetDropdowns);
    on<ChangeBottomNavIndex>(_onChangeBottomNavIndex);
    on<UpdateProbabilidadSelection>(_onUpdateProbabilidadSelection);
    on<UpdateIntensidadSelection>(_onUpdateIntensidadSelection);
  }

  void _onToggleProbabilidadDropdown(
    ToggleProbabilidadDropdown event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    emit(state.copyWith(
      isProbabilidadDropdownOpen: !state.isProbabilidadDropdownOpen,
      isIntensidadDropdownOpen: false, // Cerrar el otro dropdown
    ));
  }

  void _onToggleIntensidadDropdown(
    ToggleIntensidadDropdown event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    emit(state.copyWith(
      isIntensidadDropdownOpen: !state.isIntensidadDropdownOpen,
      isProbabilidadDropdownOpen: false, // Cerrar el otro dropdown
    ));
  }

  void _onSelectProbabilidad(
    SelectProbabilidad event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    emit(state.copyWith(
      selectedProbabilidad: event.probabilidad,
      isProbabilidadDropdownOpen: false, // Cerrar dropdown después de seleccionar
    ));
  }

  void _onSelectIntensidad(
    SelectIntensidad event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    emit(state.copyWith(
      selectedIntensidad: event.intensidad,
      isIntensidadDropdownOpen: false, // Cerrar dropdown después de seleccionar
    ));
  }

  void _onResetDropdowns(
    ResetDropdowns event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    emit(const RiskThreatAnalysisState());
  }

  void _onChangeBottomNavIndex(
    ChangeBottomNavIndex event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    emit(state.copyWith(currentBottomNavIndex: event.index));
  }

  void _onUpdateProbabilidadSelection(
    UpdateProbabilidadSelection event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    final updatedSelections = Map<String, String>.from(state.probabilidadSelections);
    updatedSelections[event.category] = event.level;
    
    emit(state.copyWith(probabilidadSelections: updatedSelections));
  }

  void _onUpdateIntensidadSelection(
    UpdateIntensidadSelection event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    final updatedSelections = Map<String, String>.from(state.intensidadSelections);
    updatedSelections[event.category] = event.level;
    
    emit(state.copyWith(intensidadSelections: updatedSelections));
  }

  // Método helper para calcular el promedio de probabilidad
  double calculateProbabilidadAverage() {
    if (state.probabilidadSelections.isEmpty) return 0.0;
    
    double totalScore = 0.0;
    int count = 0;
    
    for (final level in state.probabilidadSelections.values) {
      int value = _getLevelValue(level);
      if (value > 0) {
        totalScore += value;
        count++;
      }
    }
    
    return count > 0 ? totalScore / count : 0.0;
  }

  // Método helper para calcular el promedio de intensidad
  double calculateIntensidadAverage() {
    if (state.intensidadSelections.isEmpty) return 0.0;
    
    double totalScore = 0.0;
    int count = 0;
    
    for (final level in state.intensidadSelections.values) {
      int value = _getLevelValue(level);
      if (value > 0) {
        totalScore += value;
        count++;
      }
    }
    
    return count > 0 ? totalScore / count : 0.0;
  }

  // Método helper para mapear niveles a valores numéricos
  int _getLevelValue(String level) {
    if (level.contains('BAJO') && !level.contains('MEDIO')) {
      return 1;
    } else if (level.contains('MEDIO') && level.contains('ALTO')) {
      return 3;
    } else if (level.contains('MEDIO')) {
      return 2;
    } else if (level.contains('ALTO')) {
      return 4;
    }
    return 0;
  }

  // Método para calcular la calificación final de amenaza
  String calculateThreatRating() {
    final probAverage = calculateProbabilidadAverage();
    final intAverage = calculateIntensidadAverage();
    
    if (probAverage == 0.0 || intAverage == 0.0) {
      return 'SIN CALIFICAR';
    }
    
    final finalScore = (probAverage + intAverage) / 2;
    
    if (finalScore <= 1.5) {
      return 'BAJO';
    } else if (finalScore <= 2.5) {
      return 'MEDIO';
    } else if (finalScore <= 3.5) {
      return 'MEDIO-ALTO';
    } else {
      return 'ALTO';
    }
  }

  // Método para calcular el porcentaje de completado
  double calculateCompletionPercentage() {
    const totalCategories = 7; // 6 categorías de probabilidad + 1 de intensidad
    final completedCategories = state.probabilidadSelections.length + state.intensidadSelections.length;
    return completedCategories / totalCategories;
  }

  // Método para obtener el puntaje final numérico
  double calculateFinalScore() {
    final probAverage = calculateProbabilidadAverage();
    final intAverage = calculateIntensidadAverage();
    
    if (probAverage == 0.0 || intAverage == 0.0) {
      return 0.0;
    }
    
    return (probAverage + intAverage) / 2;
  }

  // Método para obtener el color de fondo basado en la calificación
  Color getThreatBackgroundColor() {
    final rating = calculateThreatRating();
    
    switch (rating) {
      case 'BAJO':
        return const Color(0xFF22C55E); // Verde
      case 'MEDIO':
        return const Color(0xFFFDE047); // Amarillo
      case 'MEDIO-ALTO':
        return const Color(0xFFFB923C); // Naranja
      case 'ALTO':
        return const Color(0xFFDC2626); // Rojo
      default:
        return const Color(0xFFD1D5DB); // Gris
    }
  }

  // Método para obtener el color del texto basado en la calificación
  Color getThreatTextColor() {
    final rating = calculateThreatRating();
    
    switch (rating) {
      case 'BAJO':
      case 'MEDIO-ALTO':
      case 'ALTO':
        return const Color(0xFFFFFFFF); // Blanco
      case 'MEDIO':
      default:
        return const Color(0xFF1E1E1E); // Negro/Gris oscuro
    }
  }

  // Método para obtener el texto formateado de la calificación
  String getFormattedThreatRating() {
    final rating = calculateThreatRating();
    
    if (rating == 'SIN CALIFICAR') {
      return rating;
    }
    
    final score = calculateFinalScore().toStringAsFixed(1).replaceAll('.', ',');
    
    // Si el rating es largo, usar salto de línea
    if (rating.length > 5) {
      return '$score\n$rating';
    }
    
    return '$score $rating';
  }

  // Método para obtener categorías dinámicas basadas en el evento seleccionado
  List<DropdownCategory> getCategoriesForEvent(String selectedEvent) {
    switch (selectedEvent) {
      case 'Movimiento en Masa':
        return _movimientoEnMasaCategories;
      case 'Incendio Forestal':
        return _incendioForestalCategories;
      case 'Inundación':
        return _inundacionCategories;
      case 'Avenida Torrencial':
        return _avenidaTorrencialCategories;
      default:
        return _defaultCategories;
    }
  }

  // Método para obtener las categorías de intensidad
  List<DropdownCategory> getIntensidadCategories() {
    return [DropdownCategory.intensidad()];
  }

  // Categorías por defecto (cuando no hay evento seleccionado)
  static List<DropdownCategory> get _defaultCategories => [
    DropdownCategory.custom(
      title: 'Probabilidad',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: ['Seleccione un evento específico para ver las categorías correspondientes.'],
        ),
        RiskLevel.medioBajo(
          customItems: ['Seleccione un evento específico para ver las categorías correspondientes.'],
        ),
        RiskLevel.medioAlto(
          customItems: ['Seleccione un evento específico para ver las categorías correspondientes.'],
        ),
        RiskLevel.alto(
          customItems: ['Seleccione un evento específico para ver las categorías correspondientes.'],
        ),
      ],
    ),
  ];

  // Categorías para Movimiento en Masa
  static List<DropdownCategory> get _movimientoEnMasaCategories => [
    DropdownCategory.custom(
      title: 'Características Geotécnicas',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Pendientes bajas modeladas en suelos (< 5°).',
            'Pendientes bajas, medias o altas, modeladas en roca sana o levemente meteorizada sin fracturas.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Pendientes moderadas modeladas en suelos (5° - 15°).',
            'Pendientes bajas modeladas en suelos (< 5°), en condiciones saturadas.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Pendientes altas modeladas en suelos (15° - 30°).',
            'Pendientes moderadas modeladas en suelos (5° - 15°), en condiciones saturadas.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Pendientes medias o altas modeladas en roca fracturada.',
            'Pendientes muy altas modeladas en suelos (> 30°).',
            'Pendientes altas modeladas en suelos (15° - 30°), en condiciones saturadas.',
            'Pendientes medias o altas, modeladas en llenos antrópicos.',
          ],
          customNote:
              'NOTA: En caso de tratarse de llenos antrópicos constituidos sin sustento técnico (vertimiento libre de materiales de excavación, escombros y basuras)',
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Intervención Antrópica',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Sin intervención antrópica significativa.',
            'Manejo adecuado del terreno.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Intervención mínima controlada.',
            'Medidas de control implementadas.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Intervención moderada sin control adecuado.',
            'Cortes y rellenos sin técnica apropiada.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Intervención severa descontrolada.',
            'Cortes verticales sin soporte.',
            'Rellenos sin compactación.',
            'Modificación drástica del drenaje natural.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Manejo aguas lluvia',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Sistema de drenaje completo y funcional.',
            'Mantenimiento regular del sistema.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Sistema de drenaje básico funcional.',
            'Mantenimiento ocasional.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Sistema de drenaje deficiente.',
            'Encharcamientos frecuentes.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Sin sistema de drenaje.',
            'Concentración de aguas superficiales.',
            'Erosión activa por escorrentía.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Manejo de redes hidro sanitarias',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Redes en excelente estado.',
            'Sin fugas ni infiltraciones.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: ['Redes en buen estado.', 'Fugas menores controladas.'],
        ),
        RiskLevel.medioAlto(
          customItems: ['Redes con deterioro moderado.', 'Fugas frecuentes.'],
        ),
        RiskLevel.alto(
          customItems: [
            'Redes en mal estado.',
            'Fugas permanentes y significativas.',
            'Saturación del suelo por filtraciones.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Antecedentes',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Sin antecedentes de movimientos.',
            'Zona estable históricamente.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Antecedentes menores aislados.',
            'Eventos de baja magnitud.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Antecedentes moderados documentados.',
            'Eventos recurrentes de magnitud media.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Antecedentes de eventos mayores.',
            'Historial de deslizamientos significativos.',
            'Eventos recientes y recurrentes.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Evidencias de materialización o reactivación',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: ['Sin evidencias visibles.', 'Terreno estable.'],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Evidencias menores localizadas.',
            'Grietas superficiales aisladas.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Evidencias moderadas.',
            'Grietas en desarrollo.',
            'Deformaciones menores.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Evidencias claras de inestabilidad.',
            'Grietas activas y en expansión.',
            'Movimientos visibles recientes.',
            'Deformaciones significativas.',
          ],
        ),
      ],
    ),
  ];

  // Categorías para Incendio Forestal
  static List<DropdownCategory> get _incendioForestalCategories => [
    DropdownCategory.custom(
      title: 'Combustible',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Vegetación dispersa con bajo contenido de materia seca.',
            'Zonas con alta humedad y poca acumulación de material vegetal.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Vegetación moderada con contenido medio de materia seca.',
            'Algunas zonas con acumulación de material vegetal.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Vegetación densa con alto contenido de materia seca.',
            'Acumulación considerable de material vegetal combustible.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Vegetación muy densa y seca.',
            'Gran acumulación de material vegetal combustible.',
            'Presencia de especies altamente inflamables.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Condiciones Meteorológicas',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Alta humedad relativa (>60%).',
            'Temperaturas bajas a moderadas.',
            'Vientos débiles.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Humedad relativa moderada (40-60%).',
            'Temperaturas moderadas.',
            'Vientos moderados.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Baja humedad relativa (20-40%).',
            'Temperaturas altas.',
            'Vientos fuertes.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Muy baja humedad relativa (<20%).',
            'Temperaturas muy altas.',
            'Vientos muy fuertes.',
            'Sequía prolongada.',
          ],
        ),
      ],
    ),
  ];

  // Categorías para Inundación
  static List<DropdownCategory> get _inundacionCategories => [
    DropdownCategory.custom(
      title: 'Características Hidrológicas',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Cuenca con buen sistema de drenaje.',
            'Pendientes adecuadas para evacuación de agua.',
            'Sin antecedentes de inundación.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Sistema de drenaje moderado.',
            'Pendientes variables.',
            'Antecedentes menores de inundación.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Sistema de drenaje deficiente.',
            'Pendientes inadecuadas.',
            'Antecedentes moderados de inundación.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Sin sistema de drenaje.',
            'Zona de planicie inundable.',
            'Historial recurrente de inundaciones.',
            'Desbordamiento frecuente de cauces.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Precipitación',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Precipitaciones bajas y regulares.',
            'Buena distribución temporal de lluvias.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Precipitaciones moderadas.',
            'Algunas concentraciones temporales.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Precipitaciones altas.',
            'Concentración temporal significativa.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Precipitaciones muy altas.',
            'Lluvias torrenciales concentradas.',
            'Eventos extremos recurrentes.',
          ],
        ),
      ],
    ),
  ];

  // Categorías para Avenida Torrencial
  static List<DropdownCategory> get _avenidaTorrencialCategories => [
    DropdownCategory.custom(
      title: 'Características de la Cuenca',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Cuenca amplia con pendientes suaves.',
            'Buena cobertura vegetal.',
            'Tiempo de concentración alto.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Cuenca moderada con pendientes medias.',
            'Cobertura vegetal regular.',
            'Tiempo de concentración medio.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Cuenca pequeña con pendientes altas.',
            'Cobertura vegetal escasa.',
            'Tiempo de concentración bajo.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Cuenca muy pequeña y empinada.',
            'Sin cobertura vegetal.',
            'Tiempo de concentración muy bajo.',
            'Cauces encañonados.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Sedimentos y Detritos',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Baja disponibilidad de sedimentos.',
            'Cauces estables.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Disponibilidad moderada de sedimentos.',
            'Estabilidad relativa de cauces.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Alta disponibilidad de sedimentos.',
            'Cauces con procesos erosivos activos.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Muy alta disponibilidad de sedimentos.',
            'Cauces muy inestables.',
            'Procesos erosivos intensos.',
            'Acumulación de detritos y material sólido.',
          ],
        ),
      ],
    ),
  ];
}