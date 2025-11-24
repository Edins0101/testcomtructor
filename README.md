# 📘 README – QuickQuote App

## 📌 Introducción

**QuickQuote** es una aplicación móvil desarrollada en **Flutter**, diseñada para gestionar productos, cotizaciones y prioridades de atención en un flujo optimizado.
Incluye consumo de APIs REST, manejo centralizado del estado, UI responsiva y navegación personalizada utilizando overlays controlados por un provider.

---

## 🛠️ Instalación y ejecución

### 1. Clonar el repositorio

```bash
git clone https://github.com/usuario/quickquote.git
cd quickquote
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Configurar entorno

Editar `main.dart` si deseas cambiar el ambiente:

```dart
String environment = const String.fromEnvironment(
  'ENVIRONMENT',
  defaultValue: Environment.dev,
);
Environment().initConfig(environment);
```

### 4. Ejecutar la app

```bash
flutter run
```

---

# 🏛️ Diseño y Arquitectura

La arquitectura utilizada sigue un enfoque por **capas**:

---

## **1. Capa de Presentación (UI)**

Incluye todas las pantallas y widgets:

* `ProductsWidget`
* `ProductDetailWidget`
* `QuoteCartPage`
* `QuotesPriorityWidget`
* `QuoteDetailWidget`

Layout general:
`MainLayout` encapsula app bar, navegación inferior, stack de páginas modales y alertas.

Se usan widgets reusables:

* `QuoteCard`, `ProjectGroupCard`
* `ProductCard`
* `QuoteProductItemCard`
* `QuoteSummaryCard`

---

## **2. Capa de Estado (Providers)**

Mantenida con **Provider + ChangeNotifier**.

### 🔹 FunctionalProvider

Controla:

* Navegación modal (stack de páginas con GlobalKey)
* Manejo de alerts
* Ítems del BottomNavigationBar

### 🔹 QuoteProvider

Controla:

* Producto seleccionado
* Cantidad actual
* Subtotal en tiempo real
* Carrito de cotización
* Total general

---

## **3. Capa de Datos / Servicios**

Modelos:

* `ProductResponse`
* `ProductDetailData`
* `QuotePriority`, `QuoteProjectGroup`
* `QuoteDetailData`

Servicios:

* `ProductService`
* `QuoteService`

Estructura estándar de respuesta:

```dart
GeneralResponse<T>
```

Maneja: `error`, `message`, `data`.

---

## **4. Helpers**

* `DateHelper` → fechas en español
* `GlobalHelper` → generación de keys
* `InterceptorHttp` → llamadas HTTP centralizadas

---

# ⭐ Pregunta 4 – DESARROLLO AVANZADO

## ✔️ Función interna: `getQuotesByPriority()`

Esta función devuelve las cotizaciones **ordenadas por prioridad** y **opcionalmente agrupadas por proyecto**.

### 📌 **Formula o lógica de priorización**

Cada cotización tiene:

* `hoursLeft` → horas restantes antes de expirar
* `impactScore` → impacto del cliente:

  * VIP = 3
  * Standard = 2
  * Internal = 1

Se usa puntaje combinado:

```
priorityScore = (impactScore * 1000) - hoursLeft
```

Motivación:

* Cotizaciones con **mayor impacto** suben automáticamente.
* Cotizaciones con **menos tiempo** también suben.
* El multiplicador (1000) asegura que impacto tiene mayor peso que tiempo, pero el tiempo puede desempatar.

### 📌 Filtrado y ordenamiento

1. Obtener toda la lista de cotizaciones desde la BD.
2. Calcular `priorityScore` a cada una.
3. Ordenarlas de mayor → menor prioridad.

### 📌 Agrupación opcional por proyecto

Si `groupByProject = true`:

```json
{
  "groupByProject": true,
  "groups": [
    {
      "projectId": 2,
      "projectName": "Remodelación Local Comercial",
      "quotes": [ ... ]
    },
    {
      "projectId": null,
      "projectName": "Sin proyecto",
      "quotes": [ ... ]
    }
  ]
}
```

Si `groupByProject = false`:

```json
[
  { "id": 1, "total": 150, ... },
  { "id": 2, "total": 60, ... }
]
```

### 📌 Manejo de cotizaciones sin proyecto

Las cotizaciones con:

```json
"projectId": null
```

van en un grupo especial:

```
projectName = "Sin proyecto"
```

para mantener consistencia visual.

---

# 📄 Justificación técnica

### ✔️ ¿Por qué esa fórmula?

* **Impacto del cliente** es más relevante desde el punto de vista del negocio.
* **Tiempo restante** evita que cotizaciones urgentes se queden atrás.
* **La fórmula es predictable**, fácil de testear y fácil de ajustar si negocio quiere cambios.

### ✔️ ¿Por qué permitir agrupar por proyecto?

Beneficios:

* Permite a supervisores ver trabajo por proyecto rápidamente.
* Estructura de respuesta más flexible.
* Facilita navegación en apps móviles tipo collapsibles o sections.

---

# ❓ “¿Por qué elegiste esa base local?” → **PostgreSQL**

Para el backend se elegi **PostgreSQL**.

### ✔️ Razones técnicas:

* Muy robusta para queries complejas (agrupación por proyecto, cálculos de prioridad).
* Soporte sólido para **JSONB**, útil si la estructura cambia.
* ACID completo → transacciones seguras.
* Escalabilidad vertical y horizontal.
* Funciones avanzadas: `generated columns`, `materialized views`.

### ✔️ Razones prácticas:

* Open-source y altamente estándar.
* Fácil de integrar con frameworks modernos (.NET, Nest, etc.)
* Manejo confiable de relaciones para cotizaciones ↔ proyectos ↔ items.


