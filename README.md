# Mobile Activity 5 - API Challenge

## Descripción del proyecto

Este proyecto consiste en una aplicación de recetas de cocina desarrollada en SwiftUI que utiliza la API pública TheMealDB para obtener información sobre diferentes platillos

La aplicación permite explorar una lista de recetas y seleccionar una para consultar mas informacion como el nombre del platillo, su imagen, ingredientes e instrucciones de preparación

## API utilizada

La aplicación utiliza TheMealDB una API pública que proporciona información sobre recetas de diferentes países

**Página oficial:** https://www.themealdb.com/

**Endpoint de ejemplo:**
https://www.themealdb.com/api/json/v1/1/search.php?s=

La aplicación realiza solicitudes GET mediante URLSession para obtener información en formato JSON y mostrarla en la interfaz

## Funcionalidades principales

- Conexión a la API pública TheMealDB
- Visualización de una lista de recetas
- Navegación entre la lista y una vista de detalles utilizando NavigationStack
- Visualización de imágenes y nombres de platillos
- Consulta de ingredientes e instrucciones de preparación
- Indicador de carga mediante ProgressView

## Arquitectura MVVM

La aplicación utiliza el patrón Model-View-ViewModel (MVVM) para mantener el código organizado.

- **Model:** Define la estructura de los datos de las recetas recibidos desde la API
- **View:** Muestra las recetas y permite navegar entre las diferentes pantallas
- **ViewModel:** Realiza las solicitudes a la API, procesa los datos y administra los estados de carga y error

## Cómo ejecutar la aplicación

- Xcode: 27v
- Conexión a Internet

**Pasos:**

1. Descargar desde GitHub
2. Abrir el proyecto en Xcode
3. Seleccionar un simulador de iPhone
4. Compilar y ejecutar la aplicación
5. Esperar a que se carguen las recetas desde TheMealDB
6. Seleccionar una receta para visualizar sus detalles, ingredientes e instrucciones
