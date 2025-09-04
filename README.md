# Caja de Herramientas

## Descripción
Caja de Herramientas es una aplicación móvil desarrollada en Flutter que proporciona múltiples utilidades y herramientas para diferentes propósitos. Incluye funcionalidades de evaluación de daños en edificaciones, gestión de usuarios, habitabilidad y otras herramientas útiles.

## Objetivo
Proporcionar una plataforma unificada con diversas herramientas digitales que permitan:
- Realizar evaluaciones estructurales sistemáticas
- Gestionar información de usuarios y habitabilidad
- Mantener registros consistentes y accesibles
- Trabajar sin conexión cuando sea necesario
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

## **Generación y Manejo de Reportes**

Una de las funcionalidades clave de la aplicación es la capacidad de generar reportes resumidos de la evaluación en formatos PDF y CSV. Esto facilita la documentación y el compartir de la información evaluada.

### **Opciones Disponibles**

- **Descargar PDF:** Permite al usuario descargar el resumen de la evaluación en formato PDF.
- **Enviar PDF:** Facilita el envío del resumen por correo electrónico en formato PDF.
- **Descargar CSV:** Permite descargar los datos de la evaluación en formato CSV para análisis adicional.
- **Enviar CSV:** Facilita el envío de los datos en formato CSV por correo electrónico.

Estas opciones están integradas como botones flotantes accesibles desde la pantalla de resumen de la evaluación, utilizando el paquete `flutter_speed_dial` para una navegación intuitiva.

## **Consideraciones Finales**

La aplicación de Evaluación de Edificaciones está diseñada con una arquitectura modular y escalable, utilizando patrones de diseño modernos que facilitan el mantenimiento y la extensión de funcionalidades. El uso de BLoC asegura una gestión eficiente del estado, mientras que la interfaz de usuario intuitiva permite a los usuarios realizar evaluaciones detalladas y generar reportes de manera sencilla.

Se recomienda continuar expandiendo las funcionalidades según las necesidades específicas, implementando pruebas unitarias para garantizar la robustez del sistema y optimizando la interfaz para una mejor experiencia de usuario.

