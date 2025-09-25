import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class UbicacionHelper {
  // Obtiene la ubicación actual del dispositivo
  static Future<LatLng?> obtenerUbicacionActual() async {
    bool servicioHabilitado;
    LocationPermission permiso;

    servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) return null;

    permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) return null;
    }

    if (permiso == LocationPermission.deniedForever) return null;

    Position posicion = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LatLng(posicion.latitude, posicion.longitude);
  }

  // Obtiene el nombre de la ciudad a partir de la ubicación actual
  static Future<String?> obtenerCiudadActual() async {
    LatLng? ubicacion = await obtenerUbicacionActual();
    if (ubicacion == null) return null;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        ubicacion.latitude,
        ubicacion.longitude,
      );
      if (placemarks.isNotEmpty) {
        return placemarks.first.locality ??
            placemarks.first.subAdministrativeArea;
      }
    } catch (e) {
      print("Error al obtener la ciudad: $e");
    }

    return null;
  }
}
