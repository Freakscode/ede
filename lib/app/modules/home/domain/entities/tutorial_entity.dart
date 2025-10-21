import 'package:equatable/equatable.dart';

/// Entidad de dominio para tutorial
/// Encapsula la lógica de negocio relacionada con tutoriales
class TutorialEntity extends Equatable {
  final bool showTutorial;
  final bool tutorialShown;
  final DateTime? lastShown;
  final int showCount;
  final bool isEnabled;

  const TutorialEntity({
    required this.showTutorial,
    required this.tutorialShown,
    this.lastShown,
    this.showCount = 0,
    this.isEnabled = true,
  });

  /// Factory constructor para crear tutorial inicial
  factory TutorialEntity.initial() {
    return const TutorialEntity(
      showTutorial: true,
      tutorialShown: false,
      isEnabled: true,
    );
  }

  /// Factory constructor para crear tutorial deshabilitado
  factory TutorialEntity.disabled() {
    return const TutorialEntity(
      showTutorial: false,
      tutorialShown: false,
      isEnabled: false,
    );
  }

  /// Copia con cambios
  TutorialEntity copyWith({
    bool? showTutorial,
    bool? tutorialShown,
    DateTime? lastShown,
    int? showCount,
    bool? isEnabled,
  }) {
    return TutorialEntity(
      showTutorial: showTutorial ?? this.showTutorial,
      tutorialShown: tutorialShown ?? this.tutorialShown,
      lastShown: lastShown ?? this.lastShown,
      showCount: showCount ?? this.showCount,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  /// Lógica de negocio: ¿Debe mostrarse el tutorial?
  bool get shouldShow => isEnabled && showTutorial && !tutorialShown;

  /// Lógica de negocio: ¿Ha sido mostrado el tutorial?
  bool get hasBeenShown => tutorialShown;

  /// Lógica de negocio: ¿Está deshabilitado el tutorial?
  bool get isDisabled => !isEnabled;

  /// Lógica de negocio: ¿Es la primera vez que se muestra?
  bool get isFirstTime => showCount == 0;

  /// Lógica de negocio: ¿Ha sido mostrado recientemente?
  bool get wasShownRecently {
    if (lastShown == null) return false;
    final diff = DateTime.now().difference(lastShown!);
    return diff.inHours < 24;
  }

  /// Lógica de negocio: ¿Puede ser mostrado nuevamente?
  bool get canBeShownAgain {
    if (!isEnabled) return false;
    if (showTutorial && !tutorialShown) return true;
    if (tutorialShown && !wasShownRecently) return true;
    return false;
  }

  /// Lógica de negocio: Marcar como mostrado
  TutorialEntity markAsShown() {
    return copyWith(
      tutorialShown: true,
      lastShown: DateTime.now(),
      showCount: showCount + 1,
    );
  }

  /// Lógica de negocio: Habilitar tutorial
  TutorialEntity enable() {
    return copyWith(
      isEnabled: true,
      showTutorial: true,
    );
  }

  /// Lógica de negocio: Deshabilitar tutorial
  TutorialEntity disable() {
    return copyWith(
      isEnabled: false,
      showTutorial: false,
    );
  }

  /// Lógica de negocio: Resetear tutorial
  TutorialEntity reset() {
    return copyWith(
      tutorialShown: false,
      lastShown: null,
      showCount: 0,
      showTutorial: true,
    );
  }

  /// Lógica de negocio: Validar si el tutorial es válido
  bool isValid() {
    return isEnabled && showCount >= 0;
  }

  /// Lógica de negocio: Obtener descripción del estado
  String get statusDescription {
    if (!isEnabled) return 'Deshabilitado';
    if (showTutorial && !tutorialShown) return 'Pendiente de mostrar';
    if (tutorialShown) return 'Ya mostrado';
    return 'No disponible';
  }

  /// Lógica de negocio: Obtener tiempo transcurrido desde última visualización
  Duration? get timeSinceLastShown {
    if (lastShown == null) return null;
    return DateTime.now().difference(lastShown!);
  }

  @override
  List<Object?> get props => [
        showTutorial,
        tutorialShown,
        lastShown,
        showCount,
        isEnabled,
      ];

  @override
  String toString() {
    return 'TutorialEntity(showTutorial: $showTutorial, tutorialShown: $tutorialShown, '
           'lastShown: $lastShown, showCount: $showCount, isEnabled: $isEnabled)';
  }
}
