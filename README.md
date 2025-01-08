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

## Arquitectura

### Patrón de Diseño
La aplicación implementa Clean Architecture con BLoC (Business Logic Component) como patrón de gestión de estado, estructurada en las siguientes capas:

# **Resumen de la Aplicación de Evaluación de Edificaciones**

## **Índice de Contenidos**

1. [Introducción](#introducción)
2. [Arquitectura de la Aplicación](#arquitectura-de-la-aplicación)
   - [Patrones Utilizados](#patrones-utilizados)
   - [Estructura de Carpetas](#estructura-de-carpetas)
3. [Funcionalidades Principales](#funcionalidades-principales)
   - [Identificación de la Evaluación](#identificación-de-la-evaluación)
   - [Identificación de la Edificación](#identificación-de-la-edificación)
   - [Descripción de la Edificación](#descripción-de-la-edificación)
   - [Identificación de Riesgos Externos](#identificación-de-riesgos-externos)
   - [Evaluación de Daños](#evaluación-de-daños)
   - [Nivel de Daño en la Edificación](#nivel-de-daño-en-la-edificación)
   - [Habitabilidad de la Edificación](#habitabilidad-de-la-edificación)
   - [Acciones Recomendadas y Medidas de Seguridad](#acciones-recomendadas-y-medidas-de-seguridad)
   - [Resumen de la Evaluación](#resumen-de-la-evaluación)
4. [Estado y Gestión con BLoC](#estado-y-gestión-con-bloc)
5. [Generación y Manejo de Reportes](#generación-y-manejo-de-reportes)
6. [Consideraciones Finales](#consideraciones-finales)

---

## **Introducción**

La aplicación de Evaluación de Edificaciones está diseñada para facilitar la recopilación, gestión y análisis de datos relacionados con la infraestructura de edificaciones. Utiliza tecnologías modernas de desarrollo móvil con Flutter, implementando patrones de diseño eficientes para garantizar una experiencia de usuario fluida y una gestión de estado robusta.

## **Arquitectura de la Aplicación**

### **Patrones Utilizados**

- **BLoC (Business Logic Component):** Un patrón que separa la lógica de negocio de la interfaz de usuario, facilitando pruebas y mantenimiento.
- **MVVM (Modelo-Vista-ViewModel):** Aunque principalmente utiliza BLoC, algunos conceptos de MVVM se integran para manejar la interacción entre la UI y los datos.

### **Estructura de Carpetas**

La aplicación está organizada en varias carpetas para mantener una separación clara de responsabilidades:

lib/
├── domain/
│ └── models/
│ └── evaluacion_model.dart
├── presentation/
│ ├── blocs/
│ │ ├── form/
│ │ │ ├── acciones/
│ │ │ ├── descripcionEdificacion/
│ │ │ ├── edificacion/
│ │ │ ├── evaluacion/
│ │ │ ├── evaluacionDanos/
│ │ │ ├── habitabilidad/
│ │ │ ├── nivelDano/
│ │ │ └── riesgosExternos/
│ ├── pages/
│ │ └── eval/
│ │ ├── sect_2/
│ │ ├── sect_3/
│ │ ├── sect_4/
│ │ ├── sect_5/
│ │ ├── sect_8/
│ │ └── resumen_evaluacion_page.dart
│ └── widgets/
├── utils/
└── main.dart

## **Funcionalidades Principales**

### **Identificación de la Evaluación**

Esta sección recopila información básica sobre la evaluación, como fecha, hora, ID del grupo y evento asociado. Permite al usuario ingresar detalles esenciales para contextualizar la evaluación realizada.

### **Identificación de la Edificación**

En esta sección se registran los datos fundamentales de la edificación, incluyendo:

- Nombre de la edificación
- Dirección
- Comuna y barrio
- Contacto y teléfono de emergencia

### **Descripción de la Edificación**

Proporciona una descripción detallada de la edificación, cubriendo aspectos como:

- Número de pisos y sótanos
- Área total construida
- Año de construcción
- Uso principal
- Sistema estructural y materiales utilizados
- Sistemas de entrepiso y cubierta
- Elementos no estructurales
- Datos adicionales relevantes

### **Identificación de Riesgos Externos**

Permite identificar y evaluar riesgos externos que podrían afectar la estabilidad o habitabilidad de la edificación. Los riesgos incluyen:

- Caída de objetos de edificios adyacentes
- Colapso o probable colapso de edificios adyacentes
- Falla en sistemas de distribución de servicios públicos
- Inestabilidad del terreno y movimientos en masa
- Accesos y salidas obstruidos
- Riesgos adicionales especificados por el usuario

### **Evaluación de Daños**

Esta funcionalidad permite determinar la existencia y gravedad de diferentes condiciones que afectan a la edificación, tales como:

- Colapso total o parcial
- Asentamiento severo en elementos estructurales
- Inclinación o desviación importante
- Problemas de inestabilidad en el suelo de cimentación
- Riesgo de caídas de elementos de la edificación

### **Nivel de Daño en la Edificación**

Evalúa el porcentaje de afectación y la severidad de los daños, clasificando el nivel de daño en categorías como:

- Sin daño
- Bajo
- Medio
- Alto
- Daño severo

### **Habitabilidad de la Edificación**

Determina si la edificación es habitable según los criterios evaluados, considerando factores como:

- Nivel de daño
- Existencia de riesgos externos
- Compromiso de accesos y estabilidad

### **Acciones Recomendadas y Medidas de Seguridad**

Basado en la evaluación previa, esta sección sugiere acciones y medidas de seguridad a implementar, tales como:

- Restringir acceso de peatones o vehículos
- Evacuación parcial o total
- Establecer vigilancia permanente
- Monitoreo estructural
- Aislamiento de áreas peligrosas
- Demolición de elementos en riesgo
- Manejo de sustancias peligrosas
- Desconexión de servicios públicos

### **Resumen de la Evaluación**

Proporciona una visión consolidada de toda la evaluación realizada, mostrando todos los datos recopilados en las secciones anteriores. Además, ofrece opciones para:

- Descargar el resumen en formato PDF o CSV
- Enviar el resumen por correo electrónico en formato PDF o CSV

El resumen permite a los usuarios revisar y compartir la información de manera eficiente.

## **Estado y Gestión con BLoC**

La aplicación utiliza el patrón BLoC para manejar el estado de manera eficiente y mantener una clara separación entre la lógica de negocio y la interfaz de usuario. Cada sección de la evaluación tiene su propio BLoC y estado asociado, permitiendo una gestión modular y escalable.

### **Principales BLoCs Implementados**

- **EvaluacionBloc:** Gestiona el estado de la identificación de la evaluación.
- **EdificacionBloc:** Maneja los datos de la identificación de la edificación.
- **DescripcionEdificacionBloc:** Administra la descripción detallada de la edificación.
- **RiesgosExternosBloc:** Controla la identificación y evaluación de riesgos externos.
- **EvaluacionDanosBloc:** Gestiona la evaluación de daños existentes.
- **NivelDanoBloc:** Determina el nivel de daño en la edificación.
- **HabitabilidadBloc:** Evalúa la habitabilidad basada en los criterios establecidos.
- **AccionesBloc:** Gestiona las acciones recomendadas y medidas de seguridad.

Cada BLoC responde a eventos específicos y emite estados que reflejan los cambios en los datos, permitiendo que las vistas reaccionen de manera reactiva a estos cambios.

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

---

**Nota:** Asegúrate de tener todas las dependencias necesarias instaladas y correctamente configuradas en el archivo `pubspec.yaml`, incluyendo `flutter_bloc` y `flutter_speed_dial`, para el correcto funcionamiento de la aplicación.

