import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapaIncidentesScreen extends StatefulWidget {
  const MapaIncidentesScreen({super.key});

  @override
  State<MapaIncidentesScreen> createState() => _MapaIncidentesScreenState();
}

class _MapaIncidentesScreenState extends State<MapaIncidentesScreen> {
  final MapController _mapController = MapController();

  static const LatLng _nicaraguaCenter = LatLng(12.1364, -86.2514);

  // Lista de incidentes con datos del usuario que lo reportó
  final List<Map<String, dynamic>> _incidentes = [
    {
      "tipo": "Inundación",
      "lat": 12.1470,
      "lng": -86.2734,
      "reportadoPor": "Juan Pérez",
      "telefono": "555-1234",
      "correo": "juan@example.com",
    },
    {
      "tipo": "Deslave",
      "lat": 12.0840,
      "lng": -86.2250,
      "reportadoPor": "María López",
      "telefono": "555-5678",
      "correo": "maria@example.com",
    },
    {
      "tipo": "Sismo",
      "lat": 12.1200,
      "lng": -86.2500,
      "reportadoPor": "Carlos Gómez",
      "telefono": "555-9012",
      "correo": "carlos@example.com",
    },
    {
      "tipo": "Inundación",
      "lat": 12.1300,
      "lng": -86.2000,
      "reportadoPor": "Ana Martínez",
      "telefono": "555-3456",
      "correo": "ana@example.com",
    },
  ];

  String _categoriaFiltrada = "Todos";

  List<Map<String, dynamic>> get _incidentesFiltrados {
    if (_categoriaFiltrada == "Todos") return _incidentes;
    return _incidentes.where((i) => i["tipo"] == _categoriaFiltrada).toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ajustarMapa());
  }

  // Ajustar centro y zoom automáticamente según los incidentes visibles
  void _ajustarMapa() {
    if (_incidentesFiltrados.isEmpty) return;

    double minLat = _incidentesFiltrados.first["lat"];
    double maxLat = minLat;
    double minLng = _incidentesFiltrados.first["lng"];
    double maxLng = minLng;

    for (var i in _incidentesFiltrados) {
      minLat = i["lat"] < minLat ? i["lat"] : minLat;
      maxLat = i["lat"] > maxLat ? i["lat"] : maxLat;
      minLng = i["lng"] < minLng ? i["lng"] : minLng;
      maxLng = i["lng"] > maxLng ? i["lng"] : maxLng;
    }

    LatLng center = LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2);

    // Ajustar zoom según diferencia lat/lng
    double latDiff = maxLat - minLat;
    double lngDiff = maxLng - minLng;
    double zoom = 10.0;

    double maxDiff = latDiff > lngDiff ? latDiff : lngDiff;
    if (maxDiff < 0.01)
      zoom = 16;
    else if (maxDiff < 0.03)
      zoom = 14;
    else if (maxDiff < 0.06)
      zoom = 13;
    else if (maxDiff < 0.1)
      zoom = 12;
    else if (maxDiff < 0.2)
      zoom = 11;

    _mapController.move(center, zoom);
  }

  Color _colorPorTipo(String tipo) {
    switch (tipo) {
      case "Inundación":
        return Colors.blue;
      case "Deslave":
        return Colors.orange;
      case "Sismo":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _iconoPorTipo(String tipo) {
    switch (tipo) {
      case "Inundación":
        return Icons.water_drop;
      case "Deslave":
        return Icons.landslide;
      case "Sismo":
        return Icons.warning;
      default:
        return Icons.location_on;
    }
  }

  // Mostrar información del incidente incluyendo datos del usuario
  void _mostrarInfoIncidente(Map<String, dynamic> incidente) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        color: _colorPorTipo(incidente["tipo"]).withOpacity(0.9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(_iconoPorTipo(incidente["tipo"]), color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  incidente["tipo"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Reportado por: ${incidente['reportadoPor']}",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              "Teléfono: ${incidente['telefono']}",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 2),
            Text(
              "Correo: ${incidente['correo']}",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              "Ubicación: ${incidente['lat']}, ${incidente['lng']}",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _mapController.move(
                  LatLng(incidente["lat"], incidente["lng"]),
                  16,
                );
              },
              icon: const Icon(Icons.location_pin),
              label: const Text("Ir al incidente"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _colorPorTipo(incidente["tipo"]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa de Incidentes"),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: Column(
        children: [
          // Filtro de categorías con contador
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["Todos", "Sismo", "Inundación", "Deslave"].map((
                  categoria,
                ) {
                  int cantidad = categoria == "Todos"
                      ? _incidentes.length
                      : _incidentes.where((i) => i["tipo"] == categoria).length;

                  bool seleccionado = _categoriaFiltrada == categoria;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text("$categoria ($cantidad)"),
                      selected: seleccionado,
                      onSelected: (_) {
                        setState(() {
                          _categoriaFiltrada = categoria;
                        });
                        _ajustarMapa();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Mapa
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _nicaraguaCenter,
                initialZoom: 10,
                maxZoom: 18,
                minZoom: 5,
                onTap: (_, __) {},
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: _incidentesFiltrados.map<Marker>((i) {
                    return Marker(
                      point: LatLng(i["lat"], i["lng"]),
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () => _mostrarInfoIncidente(i),
                        child: Icon(
                          _iconoPorTipo(i["tipo"]),
                          color: _colorPorTipo(i["tipo"]),
                          size: 40,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
