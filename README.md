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
