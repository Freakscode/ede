import 'package:equatable/equatable.dart';

/// Value Object para estado de dropdown
/// Encapsula la lógica de negocio relacionada con dropdowns
class DropdownState extends Equatable {
  final bool isProbabilidadOpen;
  final bool isIntensidadOpen;
  final Map<String, bool> dynamicDropdowns;
  
  const DropdownState({
    this.isProbabilidadOpen = false,
    this.isIntensidadOpen = false,
    this.dynamicDropdowns = const {},
  });

  @override
  List<Object?> get props => [isProbabilidadOpen, isIntensidadOpen, dynamicDropdowns];

  /// Lógica de negocio: ¿Hay algún dropdown abierto?
  bool get hasOpenDropdown => isProbabilidadOpen || isIntensidadOpen || dynamicDropdowns.values.any((isOpen) => isOpen);

  /// Lógica de negocio: ¿Está cerrado un dropdown específico?
  bool isDynamicDropdownOpen(String subClassificationId) {
    return dynamicDropdowns[subClassificationId] ?? false;
  }

  /// Lógica de negocio: ¿Están todos los dropdowns cerrados?
  bool get allDropdownsClosed => !hasOpenDropdown;

  /// Factory method: Crear estado inicial
  static DropdownState initial() {
    return const DropdownState();
  }

  /// Factory method: Crear estado con dropdown de probabilidad abierto
  static DropdownState withProbabilidadOpen() {
    return const DropdownState(isProbabilidadOpen: true);
  }

  /// Factory method: Crear estado con dropdown de intensidad abierto
  static DropdownState withIntensidadOpen() {
    return const DropdownState(isIntensidadOpen: true);
  }

  /// Método de negocio: Crear copia con cambios
  DropdownState copyWith({
    bool? isProbabilidadOpen,
    bool? isIntensidadOpen,
    Map<String, bool>? dynamicDropdowns,
  }) {
    return DropdownState(
      isProbabilidadOpen: isProbabilidadOpen ?? this.isProbabilidadOpen,
      isIntensidadOpen: isIntensidadOpen ?? this.isIntensidadOpen,
      dynamicDropdowns: dynamicDropdowns ?? this.dynamicDropdowns,
    );
  }

  /// Método de negocio: Alternar dropdown de probabilidad
  DropdownState toggleProbabilidad() {
    return copyWith(isProbabilidadOpen: !isProbabilidadOpen);
  }

  /// Método de negocio: Alternar dropdown de intensidad
  DropdownState toggleIntensidad() {
    return copyWith(isIntensidadOpen: !isIntensidadOpen);
  }

  /// Método de negocio: Alternar dropdown dinámico
  DropdownState toggleDynamic(String subClassificationId) {
    final newDynamicDropdowns = Map<String, bool>.from(dynamicDropdowns);
    newDynamicDropdowns[subClassificationId] = !(newDynamicDropdowns[subClassificationId] ?? false);
    return copyWith(dynamicDropdowns: newDynamicDropdowns);
  }

  /// Método de negocio: Cerrar todos los dropdowns
  DropdownState closeAll() {
    return const DropdownState();
  }

  @override
  String toString() {
    return 'DropdownState(isProbabilidadOpen: $isProbabilidadOpen, isIntensidadOpen: $isIntensidadOpen, '
           'hasOpenDropdown: $hasOpenDropdown)';
  }
}
