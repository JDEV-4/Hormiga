import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapaIncidentesPage extends StatelessWidget {
  final Map<String, dynamic>? incidenteNuevo;

  const MapaIncidentesPage({super.key, this.incidenteNuevo});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> incidentes = [
      {
        'tipo': 'Incendio',
        'descripcion': 'Incendio en el barrio San José',
        'ubicacion': LatLng(12.1333, -86.2500),
      },
      {
        'tipo': 'Inundación',
        'descripcion': 'Calle principal de Masaya bloqueada por agua',
        'ubicacion': LatLng(11.9744, -86.0947),
      },
    ];

    if (incidenteNuevo != null) {
      incidentes.add(incidenteNuevo!);
    }

    final LatLng center = incidenteNuevo != null
        ? incidenteNuevo!['ubicacion']
        : LatLng(12.8654, -85.2072); // Nicaragua por defecto

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Incidentes'),
        backgroundColor: const Color(0xFF006D65),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
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
                  child: Icon(
                    Icons.location_on,
                    color: incidente == incidenteNuevo
                        ? Colors.green
                        : Colors.red,
                    size: 40,
                  ),
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
        ],
      ),
    );
  }
}
