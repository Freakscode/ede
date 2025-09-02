# Sistema de Inyección de Dependencias con get_it

Este proyecto utiliza **get_it** para la inyección de dependencias, siguiendo los principios de **Clean Architecture**.

## Estructura del Sistema

### Service Locator
- **Archivo**: `lib/core/service_locator.dart`
- **Propósito**: Configurar y registrar todas las dependencias del proyecto
- **Instancia Global**: `serviceLocator` (GetIt instance)

### Capas de la Arquitectura

#### 1. Data Layer (`lib/data/`)
- **Models**: Representaciones de datos para la capa de datos
- **DataSources**: 
  - `LocalDatabase`: Manejo de SQLite local
  - `RemoteApi`: Cliente HTTP para APIs remotas
  - `SecureStorageService`: Almacenamiento seguro
- **Repositories**: Implementaciones concretas de los repositorios

#### 2. Domain Layer (`lib/domain/`)
- **Entities**: Modelos de dominio puros
- **Repositories**: Interfaces/contratos abstractos
- **Use Cases**: Casos de uso de negocio

#### 3. Presentation Layer (`lib/presentation/`)
- **Pages**: Vistas de la aplicación
- **Widgets**: Componentes UI reutilizables
- **BLoCs**: Gestión de estado

## Configuración y Uso

### 1. Inicialización
```dart
import 'core/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Cargar variables de entorno
  await dotenv.load(fileName: Environment.fileName);
  
  // Configurar Service Locator
  await setupServiceLocator();
  
  runApp(MyApp());
}
```

### 2. Uso en BLoCs o Services
```dart
class MyBloc {
  final AuthRepository _authRepository;
  final EvaluacionRepository _evaluacionRepository;

  MyBloc()
    : _authRepository = serviceLocator<AuthRepository>(),
      _evaluacionRepository = serviceLocator<EvaluacionRepository>();
}
```

### 3. Uso en Widgets
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authRepository = serviceLocator<AuthRepository>();
    
    return Scaffold(/* ... */);
  }
}
```

### 4. Use Cases Disponibles
```dart
// Obtener use cases
final saveEvaluacion = serviceLocator<SaveEvaluacionUseCase>();
final getEvaluaciones = serviceLocator<GetEvaluacionesUseCase>();
final syncEvaluaciones = serviceLocator<SyncEvaluacionesUseCase>();
final login = serviceLocator<LoginUseCase>();
```

## Dependencias Registradas

### Dependencias Externas
- `SharedPreferences`: Almacenamiento de preferencias
- `Database` (SQLite): Base de datos local
- `http.Client`: Cliente HTTP

### Data Sources
- `LocalDatabase`: Manejo de base de datos SQLite
- `RemoteApi`: Cliente para APIs remotas

### Repositories
- `AuthRepository`: Autenticación y autorización
- `EvaluacionRepository`: Gestión de evaluaciones
- `SyncRepository`: Sincronización de datos

### Use Cases
- `SaveEvaluacionUseCase`: Guardar evaluaciones
- `GetEvaluacionesUseCase`: Obtener evaluaciones
- `SyncEvaluacionesUseCase`: Sincronizar datos
- `LoginUseCase`: Iniciar sesión

## Variables de Entorno

El archivo `.env` debe contener:
```env
JWT_SECRET=tu_clave_secreta_jwt
JWT_EXPIRATION_DAYS=30
username=tu_usuario
password=tu_contraseña
API_URL=http://localhost:3000/api
```

## Base de Datos Local

Se utiliza SQLite con las siguientes tablas:
- **evaluaciones**: Almacena evaluaciones con estado de sincronización
- **users**: Información de usuarios y tokens

## Flujo de Datos

1. **UI Layer** → Use Cases
2. **Use Cases** → Repository Interfaces
3. **Repository Implementations** → Data Sources
4. **Data Sources** → External APIs/Database

## Testing

Para testing, puedes resetear las dependencias:
```dart
import 'core/service_locator.dart';

// En tus tests
await serviceLocator.reset();
await setupServiceLocator();
```

## Arquitectura Clean

```
┌─────────────────────────────────────────────────────────┐
│                  Presentation Layer                     │
│              (UI, BLoCs, Widgets)                      │
├─────────────────────────────────────────────────────────┤
│                   Domain Layer                          │
│          (Entities, Use Cases, Repositories)           │
├─────────────────────────────────────────────────────────┤
│                    Data Layer                           │
│        (Models, DataSources, Repositories Impl)        │
├─────────────────────────────────────────────────────────┤
│               External Dependencies                      │
│         (Database, HTTP, Shared Preferences)           │
└─────────────────────────────────────────────────────────┘
```

## Ventajas del Sistema

1. **Desacoplamiento**: Cada capa es independiente
2. **Testabilidad**: Fácil mockear dependencias
3. **Mantenibilidad**: Cambios aislados por capa
4. **Escalabilidad**: Fácil agregar nuevas funcionalidades
5. **Inyección de Dependencias**: Gestión centralizada con get_it
