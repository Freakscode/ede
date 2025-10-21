# Módulo Home - Clean Architecture

Este módulo ha sido refactorizado para seguir los principios de **Clean Architecture**, separando claramente las responsabilidades en capas bien definidas.

## 📁 Estructura

```
lib/app/modules/home/
├── domain/                     # 🎯 Capa de Dominio
│   ├── entities/               # Entidades de negocio
│   │   ├── home_entity.dart
│   │   ├── form_entity.dart
│   │   ├── tutorial_entity.dart
│   │   └── entities.dart
│   ├── use_cases/              # Casos de uso
│   │   ├── get_home_state_usecase.dart
│   │   ├── update_home_state_usecase.dart
│   │   ├── manage_forms_usecase.dart
│   │   ├── manage_tutorial_usecase.dart
│   │   └── use_cases.dart
│   ├── repositories/           # Interfaces de repositorios
│   │   └── home_repository_interface.dart
│   └── domain.dart
├── data/                       # 🎯 Capa de Datos
│   ├── models/                 # Modelos de datos
│   │   ├── home_model.dart
│   │   ├── tutorial_model.dart
│   │   └── models.dart
│   ├── repositories/           # Implementaciones de repositorios
│   │   ├── home_repository_implementation.dart
│   │   └── repositories.dart
│   └── data.dart
├── presentation/               # 🎯 Capa de Presentación
│   ├── bloc/                   # BLoC solo para UI state
│   │   ├── home_bloc.dart
│   │   ├── home_event.dart
│   │   ├── home_state.dart
│   │   └── bloc.dart
│   ├── pages/                  # Páginas (referencias a ui/pages)
│   │   └── pages.dart
│   ├── widgets/                # Widgets (referencias a ui/widgets)
│   │   └── widgets.dart
│   └── presentation.dart
├── ui/                         # 🎨 UI existente (mantenida)
│   ├── pages/
│   └── widgets/
├── home.dart                   # Barrel file principal
└── README.md
```

## 🏗️ Arquitectura

### **Capa de Dominio** (`domain/`)
- **Entidades**: Representan los objetos de negocio con su lógica
- **Casos de Uso**: Encapsulan la lógica de negocio específica
- **Interfaces de Repositorios**: Contratos para la persistencia

### **Capa de Datos** (`data/`)
- **Modelos**: Mapean entre entidades y datos persistentes
- **Implementaciones de Repositorios**: Manejan la persistencia real
- **Fuentes de Datos**: SQLite, SharedPreferences, Hive

### **Capa de Presentación** (`presentation/`)
- **BLoC**: Solo maneja el estado de la UI
- **Páginas**: Referencias a las páginas existentes en `ui/`
- **Widgets**: Referencias a los widgets existentes en `ui/`

## 🔄 Flujo de Datos

```
UI (Widgets/Pages) 
    ↓
BLoC (Presentation Layer)
    ↓
Use Cases (Domain Layer)
    ↓
Repository Interface (Domain Layer)
    ↓
Repository Implementation (Data Layer)
    ↓
Data Sources (SQLite, SharedPreferences, Hive)
```

## 🎯 Beneficios de la Refactorización

### **Antes (Problemático)**
- ❌ Lógica de negocio mezclada con presentación
- ❌ Dependencias directas a servicios externos
- ❌ Responsabilidades múltiples en el BLoC
- ❌ Difícil de testear y mantener

### **Después (Clean Architecture)**
- ✅ Separación clara de responsabilidades
- ✅ Lógica de negocio en casos de uso
- ✅ BLoC solo maneja estado de UI
- ✅ Fácil de testear y mantener
- ✅ Independiente de frameworks externos

## 🚀 Uso

### **Inyección de Dependencias**
```dart
// Los componentes están registrados en injection_container.dart
final homeBloc = sl<HomeBloc>();
```

### **Casos de Uso**
```dart
// Obtener estado del home
final homeEntity = await getHomeStateUseCase.execute();

// Actualizar estado
await updateHomeStateUseCase.execute(newHomeEntity);

// Gestionar formularios
final forms = await manageFormsUseCase.getAllForms();
await manageFormsUseCase.createForm(eventName: 'Movimiento en Masa');

// Gestionar tutorial
final tutorialConfig = await manageTutorialUseCase.getTutorialConfig();
```

### **BLoC**
```dart
// El BLoC ahora solo maneja eventos de UI
context.read<HomeBloc>().add(HomeNavBarTapped(2));
context.read<HomeBloc>().add(LoadForms());
context.read<HomeBloc>().add(SelectRiskEvent('Movimiento en Masa'));
```

## 📝 Notas de Migración

1. **Páginas y Widgets**: Se mantienen en `ui/` para no romper la funcionalidad existente
2. **BLoC Anterior**: Se mantiene en `bloc/` como respaldo temporal
3. **Compatibilidad**: Los imports existentes siguen funcionando
4. **Migración Gradual**: Se puede migrar página por página al nuevo BLoC

## 🧪 Testing

La nueva arquitectura facilita el testing:

```dart
// Test de casos de uso
test('should return home state', () async {
  // Arrange
  when(mockRepository.getHomeState()).thenAnswer((_) async => mockHomeEntity);
  
  // Act
  final result = await useCase.execute();
  
  // Assert
  expect(result, equals(mockHomeEntity));
});

// Test de BLoC
test('should emit loading then success when forms are loaded', () async {
  // Arrange
  when(mockUseCase.getAllForms()).thenAnswer((_) async => mockForms);
  
  // Act
  bloc.add(LoadForms());
  
  // Assert
  expectLater(bloc.stream, emitsInOrder([
    isA<HomeState>().having((s) => s.isLoadingForms, 'isLoadingForms', true),
    isA<HomeState>().having((s) => s.savedForms, 'savedForms', mockForms),
  ]));
});
```

## 🔧 Próximos Pasos

1. **Migrar Páginas**: Actualizar páginas para usar el nuevo BLoC
2. **Tests**: Agregar tests unitarios para casos de uso
3. **Documentación**: Expandir documentación de casos de uso específicos
4. **Optimización**: Optimizar consultas de base de datos si es necesario
