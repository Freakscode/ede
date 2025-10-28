/// Enum para definir los modos de operación del formulario
enum FormMode {
  /// Modo creación: Crear un nuevo formulario
  create,
  
  /// Modo edición: Editar un formulario existente
  edit,
}

/// Extensión para facilitar el uso del enum
extension FormModeExtension on FormMode {
  /// Convierte el modo a string
  String get value {
    switch (this) {
      case FormMode.create:
        return 'create';
      case FormMode.edit:
        return 'edit';
    }
  }
  
  /// Convierte string a modo
  static FormMode fromString(String value) {
    switch (value.toLowerCase()) {
      case 'create':
        return FormMode.create;
      case 'edit':
        return FormMode.edit;
      default:
        return FormMode.create; // Default
    }
  }
  
  /// Verifica si es modo creación
  bool get isCreate => this == FormMode.create;
  
  /// Verifica si es modo edición
  bool get isEdit => this == FormMode.edit;
}
