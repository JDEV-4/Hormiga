# A24 — Aplicación Hackathon Disruptivo Nicaragua 2025 (Equipo JEDIK)

**Propósito (breve)**
A24 es una aplicación desarrollada con **Flutter (Dart)** para el Hackathon Disruptivo Nicaragua 2025. Su objetivo es ofrecer una herramienta educativa y de alerta ciudadana ante amenazas (inundaciones, deslaves, derrumbes, etc.), con georreferenciación de reportes, mapa interactivo y un chatbot educativo llamado **“La Hormiga”**.

> En la rama `Javier` se encuentra la parte del desarollo de Flutter.

---

## Funcionalidades principales (resumen)

* Módulo educativo sobre riesgos y medidas preventivas.
* Reporte de incidentes con geolocalización (modo local).
* Chatbot “La Hormiga” (avances en la rama `chatbot`).

## Ramas del repositorio

* `main` — Contiene licencia y README principal.
* `Javier` — Código de la aplicación Flutter (MVC), todo el frontend y la persistencia local (esta rama).
* `chatbot` — Avances e integración del chatbot.

---

## Requisitos previos

* Flutter SDK (estable).
* Git.
* Emulador Android o navegador (para Flutter Web) o dispositivo físico.
* (Opcional) `adb` para dispositivos Android.

---

## Instalación (pasos rápidos)

1. Clona el repositorio y cambia a la rama `Javier`:

```bash
git clone https://github.com/JDEV-4/Hormiga.git
cd Hormiga
git checkout Javier
```

2. Instala las dependencias:

```bash
flutter pub get
```

3. (Opcional) Limpia la build si algo falla:

```bash
flutter clean
flutter pub get
```

---

## Cómo ejecutar la aplicación

### Ver dispositivos conectados / disponibles

```bash
flutter devices
```

### Ejecutar en el navegador (Flutter Web)

```bash
flutter run -d chrome
```

ó

```bash
flutter run -d web-server
```

### Ejecutar en emulador Android / iOS

* Inicia el emulador (Android Studio / AVD o Xcode Simulator).
* Ejecuta:

```bash
flutter run
```

(si hay más de un dispositivo, usa `-d <device-id>` obtenido con `flutter devices`)

### Ejecutar en dispositivo físico (USB)

1. Habilita modo desarrollador y depuración USB en el dispositivo.
2. Conecta el dispositivo por USB y confirma con:

```bash
flutter devices
```

3. Ejecuta:

```bash
flutter run -d <device-id>
```

### Generar APK release (Android)

```bash
flutter build apk --release
```


## Estructura común (sugerida)

```
/lib
  /controllers
  /models
  /services
  /views
  /db
  main.dart
/assets
pubspec.yaml
```

---

## Assets

* Coloca imágenes en `assets/images/`.
* En `pubspec.yaml` declara:

```yaml
flutter:
  assets:
    - assets/images/
```

* Usa en código:

```dart
Image.asset('assets/images/logo.png')
```

---

## Errores comunes y soluciones rápidas

* **404 en imágenes:** revisa la ruta en `Image.asset` y la sección `assets:` en `pubspec.yaml`; luego `flutter clean` + `flutter pub get`.
* **No se conecta a API (si decides usar una):** para emulador Android usa `10.0.2.2` en lugar de `localhost`.



## Licencia y créditos

* Proyecto para Hackathon Disruptivo Nicaragua 2025 — Equipo **JEDIK**.
