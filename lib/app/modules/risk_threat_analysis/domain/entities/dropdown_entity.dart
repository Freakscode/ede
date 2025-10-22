import 'package:equatable/equatable.dart';

/// Entidad de dominio para estado de dropdown
/// Encapsula la lógica de negocio relacionada con dropdowns
class DropdownEntity extends Equatable {
  final bool isProbabilidadOpen;
  final bool isIntensidadOpen;
  final Map<String, bool> dynamicDropdowns;
  
  const DropdownEntity({
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
  static DropdownEntity initial() {
    return const DropdownEntity();
  }

  /// Factory method: Crear estado con dropdown de probabilidad abierto
  static DropdownEntity withProbabilidadOpen() {
    return const DropdownEntity(isProbabilidadOpen: true);
  }

  /// Factory method: Crear estado con dropdown de intensidad abierto
  static DropdownEntity withIntensidadOpen() {
    return const DropdownEntity(isIntensidadOpen: true);
  }

  /// Método de negocio: Crear copia con cambios
  DropdownEntity copyWith({
    bool? isProbabilidadOpen,
    bool? isIntensidadOpen,
    Map<String, bool>? dynamicDropdowns,
  }) {
    return DropdownEntity(
      isProbabilidadOpen: isProbabilidadOpen ?? this.isProbabilidadOpen,
      isIntensidadOpen: isIntensidadOpen ?? this.isIntensidadOpen,
      dynamicDropdowns: dynamicDropdowns ?? this.dynamicDropdowns,
    );
  }

  /// Método de negocio: Alternar dropdown de probabilidad
  DropdownEntity toggleProbabilidad() {
    return copyWith(isProbabilidadOpen: !isProbabilidadOpen);
  }

  /// Método de negocio: Alternar dropdown de intensidad
  DropdownEntity toggleIntensidad() {
    return copyWith(isIntensidadOpen: !isIntensidadOpen);
  }

  /// Método de negocio: Alternar dropdown dinámico
  DropdownEntity toggleDynamic(String subClassificationId) {
    final newDynamicDropdowns = Map<String, bool>.from(dynamicDropdowns);
    newDynamicDropdowns[subClassificationId] = !(newDynamicDropdowns[subClassificationId] ?? false);
    return copyWith(dynamicDropdowns: newDynamicDropdowns);
  }

  /// Método de negocio: Cerrar todos los dropdowns
  DropdownEntity closeAll() {
    return const DropdownEntity();
  }

  @override
  String toString() {
    return 'DropdownEntity(isProbabilidadOpen: $isProbabilidadOpen, isIntensidadOpen: $isIntensidadOpen, '
           'hasOpenDropdown: $hasOpenDropdown)';
  }
}
