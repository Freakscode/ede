# EDE - Evaluación de Daños en Edificaciones

## Descripción
EDE es una aplicación móvil desarrollada en Flutter para la evaluación y registro de daños en edificaciones post-evento (sismos, inundaciones, etc.). Permite a los evaluadores realizar inspecciones estructurales de manera sistemática y eficiente, con capacidad de trabajo offline y sincronización posterior.

## Objetivo
Facilitar y estandarizar el proceso de evaluación de daños en edificaciones después de eventos naturales o antrópicos, proporcionando una herramienta digital que permita:
- Realizar evaluaciones estructurales sistemáticas
- Mantener registros consistentes y accesibles
- Trabajar sin conexión en zonas afectadas
- Sincronizar datos cuando haya conectividad
- Generar reportes estandarizados

---

## Índice de Contenidos

1. [Introducción](#introducción)
2. [Instalación](#instalación)
3. [Arquitectura de la Aplicación](#arquitectura-de-la-aplicación)
   - [Patrones Utilizados](#patrones-utilizados)
   - [Estructura de Carpetas](#estructura-de-carpetas)
4. [Funcionalidades Principales](#funcionalidades-principales)
   - [Identificación de la Evaluación](#identificación-de-la-evaluación)
   - [Identificación de la Edificación](#identificación-de-la-edificación)
   - [Descripción de la Edificación](#descripción-de-la-edificación)
   - [Identificación de Riesgos Externos](#identificación-de-riesgos-externos)
   - [Evaluación de Daños](#evaluación-de-daños)
   - [Nivel de Daño en la Edificación](#nivel-de-daño-en-la-edificación)
   - [Habitabilidad de la Edificación](#habitabilidad-de-la-edificación)
   - [Acciones Recomendadas y Medidas de Seguridad](#acciones-recomendadas-y-medidas-de-seguridad)
   - [Resumen de la Evaluación](#resumen-de-la-evaluación)
5. [Estado y Gestión con BLoC](#estado-y-gestión-con-bloc)
6. [Generación y Manejo de Reportes](#generación-y-manejo-de-reportes)
7. [Consideraciones Finales](#consideraciones-finales)
8. [Licencia](#licencia)

---

## Introducción

La aplicación de Evaluación de Edificaciones está diseñada para facilitar la recopilación, gestión y análisis de datos relacionados con la infraestructura de edificaciones. Utiliza tecnologías modernas de desarrollo móvil con Flutter, implementando patrones de diseño eficientes para garantizar una experiencia de usuario fluida y una gestión de estado robusta.

---

## Instalación

1. **Clonar el repositorio:**
   ```bash
   git clone <URL_DEL_REPOSITORIO>
   cd <NOMBRE_DEL_PROYECTO>
   ```

2. **Instalar dependencias:**
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación:**
   - Para Android:
     ```bash
     flutter run -d emulator-5554
     ```
   - Para iOS:
     ```bash
     flutter run -d <NOMBRE_DEL_SIMULADOR>
     ```

4. **Configurar entornos (si aplica):**
   - Verificar que las API keys, bases de datos o configuraciones necesarias estén correctamente configuradas en `lib/utils/`.

---

## Arquitectura de la Aplicación

### Patrones Utilizados

- **BLoC (Business Logic Component):** Un patrón que separa la lógica de negocio de la interfaz de usuario, facilitando pruebas y mantenimiento.
- **MVVM (Modelo-Vista-ViewModel):** Aunque principalmente utiliza BLoC, algunos conceptos de MVVM se integran para manejar la interacción entre la UI y los datos.

### Estructura de Carpetas

```plaintext
lib/
├── domain/
│   └── models/
│       └── evaluacion_model.dart
├── presentation/
│   ├── blocs/
│   │   ├── form/
│   │   │   ├── acciones/
│   │   │   ├── descripcionEdificacion/
│   │   │   ├── edificacion/
│   │   │   ├── evaluacion/
│   │   │   ├── evaluacionDanos/
│   │   │   ├── habitabilidad/
│   │   │   ├── nivelDano/
│   │   │   └── riesgosExternos/
│   ├── pages/
│   │   └── eval/
│   │       ├── sect_2/
│   │       ├── sect_3/
│   │       ├── sect_4/
│   │       ├── sect_5/
│   │       ├── sect_8/
│   │       └── resumen_evaluacion_page.dart
│   └── widgets/
├── utils/
└── main.dart
```

---

## Funcionalidades Principales

### Identificación de la Evaluación
Recopila información básica sobre la evaluación, como fecha, hora, ID del grupo y evento asociado.

### Identificación de la Edificación
Registra datos fundamentales como nombre de la edificación, dirección, comuna, contacto, etc.

### Descripción de la Edificación
Incluye aspectos como número de pisos, área total, año de construcción, uso principal, entre otros.

### Identificación de Riesgos Externos
Evalúa riesgos externos como caída de objetos, inestabilidad del terreno, obstrucción de accesos, etc.

### Evaluación de Daños
Determina la existencia y gravedad de condiciones como colapso parcial, inestabilidad del suelo, etc.

### Nivel de Daño en la Edificación
Clasifica el nivel de daño en las categorías: sin daño, bajo, medio, alto, severo.

### Habitabilidad de la Edificación
Evalúa si la edificación es habitable según los criterios establecidos.

### Acciones Recomendadas y Medidas de Seguridad
Sugerencias como evacuación, demolición, monitoreo estructural, etc.

### Resumen de la Evaluación
Genera un resumen consolidado en formato PDF o CSV, con opciones para descarga y envío.

---

## Estado y Gestión con BLoC

La aplicación utiliza el patrón BLoC para manejar el estado de manera eficiente. Cada sección tiene su propio BLoC.

**Principales BLoCs Implementados:**
- **EvaluacionBloc:** Maneja la identificación de la evaluación.
- **EdificacionBloc:** Administra los datos de la edificación.
- **DescripcionEdificacionBloc:** Gestiona la descripción estructural.
- **RiesgosExternosBloc:** Controla riesgos externos.
- **EvaluacionDanosBloc:** Evalúa los daños.
- **NivelDanoBloc:** Clasifica el nivel de daño.
- **HabitabilidadBloc:** Determina la habitabilidad.
- **AccionesBloc:** Gestiona las acciones recomendadas.

---

## Generación y Manejo de Reportes

**Opciones Disponibles:**
- Descargar o enviar reportes en formato PDF.
- Descargar o enviar datos en formato CSV.

---

## Licencia

Este proyecto está licenciado bajo la [MIT License](LICENSE).

