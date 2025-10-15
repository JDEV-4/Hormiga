import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapaIncidentesPage extends StatelessWidget {
  final Map<String, dynamic>? incidenteNuevo;

  const MapaIncidentesPage({super.key, this.incidenteNuevo});

  // Función que devuelve el icono según el tipo de incidente
  Widget _getMarkerIcon(String tipo, bool esNuevo) {
    String iconPath;
    switch (tipo) {
      case 'Incendio':
        iconPath = 'assets/icons/fire.png';
        break;
      case 'Inundación':
        iconPath = 'assets/icons/water.png';
        break;
      case 'Deslizamiento':
        iconPath = 'assets/icons/landslide.png';
        break;
      case 'Corte de energía':
        iconPath = 'assets/icons/power.png';
        break;
      default:
        iconPath = 'assets/icons/fire.png'; // icono por defecto
    }

    return Image.asset(
      iconPath,
      width: 40,
      height: 40,
      color: esNuevo ? Colors.green : null, // resalta el nuevo
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> incidentes = [
      {
        'tipo': 'Incendio',
        'descripcion': 'Incendio en el barrio San José',
        'ubicacion': LatLng(12.1333, -86.2500),
        'comunidad': 'San José',
      },
      {
        'tipo': 'Inundación',
        'descripcion': 'Calle principal de Masaya bloqueada por agua',
        'ubicacion': LatLng(11.9744, -86.0947),
        'comunidad': 'Masaya Centro',
      },
    ];

    if (incidenteNuevo != null) {
      incidentes.add(incidenteNuevo!);
    }

    final LatLng center = incidenteNuevo != null
        ? incidenteNuevo!['ubicacion']
        : LatLng(12.8654, -85.2072); // Centro de Nicaragua por defecto

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Incidentes'),
        backgroundColor: const Color(0xFF006D65),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: center,
          initialZoom: incidenteNuevo != null ? 14.5 : 7.2,
          maxZoom: 18,
          minZoom: 6,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=5cckFGWliszSoq3ezirR',
            userAgentPackageName: 'com.example.hormiga',
          ),
          MarkerLayer(
            markers: incidentes.map((incidente) {
              bool esNuevo = incidente == incidenteNuevo;
              return Marker(
                point: incidente['ubicacion'],
                width: 60,
                height: 60,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (_) => _buildIncidentInfo(incidente),
                    );
                  },
                  child: _getMarkerIcon(incidente['tipo'], esNuevo),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentInfo(Map<String, dynamic> incidente) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            incidente['tipo'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006D65),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            incidente['descripcion'],
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Comunidad: ${incidente['comunidad']}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            'Lat: ${incidente['ubicacion'].latitude}, Lng: ${incidente['ubicacion'].longitude}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
