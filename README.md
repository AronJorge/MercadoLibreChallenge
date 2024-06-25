
![MVP Architecture](https://miro.medium.com/v2/resize:fit:720/format:webp/0*i9q7pRK5rZWNhT2n.png "Model-View-Presenter Architecture Diagram")

# Desarrollo de Aplicación iOS con Arquitectura MVP

## Descripción General

Este proyecto demuestra la implementación de una aplicación iOS utilizando la arquitectura Modelo-Vista-Presentador (MVP) en Swift. La aplicación está diseñada para mostrar una lista de productos, permitiendo a los usuarios seleccionar un producto para ver sus detalles.

## Arquitectura MVP

La arquitectura MVP separa la lógica de la aplicación en tres componentes interconectados, lo que permite una mejor separación de preocupaciones y una mayor escalabilidad.

- **Modelo**: Representa los datos y la lógica empresarial de la aplicación. Se encarga de obtener, procesar.
- **Vista**: Maneja la capa de presentación. Muestra los datos proporcionados por el Presentador y envía acciones del usuario al Presentador.
- **Presentador**: Actúa como intermediario entre el Modelo y la Vista. Recupera datos del Modelo, los procesa (si es necesario) y los pasa a la Vista.

## Características

- Listar productos en una vista de colección.
- Ver información detallada sobre cada producto en una nueva vista.
- Manejo de errores y notificaciones al usuario.

## Componentes

### ProductViewController

Maneja la visualización de productos. Utiliza una vista de colección para mostrar una cuadrícula de elementos de productos.

### ProductDetailView

Muestra información detallada sobre un producto seleccionado, incluyendo nombre, precio entre otros atributos.

### ProductPresenter

Gestiona la comunicación entre el `ProductViewController` y el modelo, manejando interacciones de los usuarios y actualizando la vista con nuevos datos.

### Modelos

Incluye clases y estructuras que representan los datos de negocio (p.ej., `Product`, `Attribute`) y la lógica.

## Configuración


### Prerrequisitos

Antes de ejecutar el proyecto, asegúrate de tener instalado CocoaPods en tu sistema. Si no lo tienes instalado, puedes instalarlo con el siguiente comando:

```bash
sudo gem install cocoapods
cd MercadoLibreChallenge
pod install
```

abrir MercadoLibreChallenge.xcworkspace

1. Clonar el repositorio:
https://github.com/AronJorge/MercadoLibreChallenge.git

3. Ejecutar el proyecto:
- Selecciona un dispositivo o simulador objetivo.
- Presiona el botón 'Run'.

## Dependencias

- [SDWebImage](https://github.com/SDWebImage/SDWebImage): Utilizado para la carga y caché de imágenes de forma asíncrona.

## Pruebas

Se incluyen pruebas unitarias para asegurar que la lógica y las interfaces de la app funcionen como se espera.

