import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapaIncidentesScreen extends StatefulWidget {
  final Map<String, dynamic>?
  reporteInicial; // Reporte recibido desde otra pantalla

  const MapaIncidentesScreen({super.key, this.reporteInicial});

  @override
  State<MapaIncidentesScreen> createState() => _MapaIncidentesScreenState();
}

class _MapaIncidentesScreenState extends State<MapaIncidentesScreen> {
  final MapController _mapController = MapController();
  static const LatLng _nicaraguaCenter = LatLng(12.1364, -86.2514);

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
    if (widget.reporteInicial != null) {
      _incidentes.add(widget.reporteInicial!);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _ajustarMapa());
  }

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
            Text(
              "Teléfono: ${incidente['telefono']}",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Correo: ${incidente['correo']}",
              style: const TextStyle(color: Colors.white),
            ),
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
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.map, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Mapa de Incidentes",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Visualización de reportes activos",
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //Filtro de categorías con íconos
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ["Todos", "Sismo", "Inundación", "Deslave"].map((
                    categoria,
                  ) {
                    int cantidad = categoria == "Todos"
                        ? _incidentes.length
                        : _incidentes
                              .where((i) => i["tipo"] == categoria)
                              .length;

                    bool seleccionado = _categoriaFiltrada == categoria;
                    Color colorIconoTexto = seleccionado
                        ? Colors.white
                        : Colors.blueGrey;

                    IconData icono;
                    switch (categoria) {
                      case "Sismo":
                        icono = Icons.warning;
                        break;
                      case "Inundación":
                        icono = Icons.water_drop;
                        break;
                      case "Deslave":
                        icono = Icons.landslide;
                        break;
                      default:
                        icono = Icons.all_inclusive;
                        break;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: seleccionado
                                ? _colorPorTipo(categoria)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ChoiceChip(
                          avatar: Icon(icono, color: colorIconoTexto),
                          label: Text(
                            "$categoria ($cantidad)",
                            style: TextStyle(
                              color: colorIconoTexto,
                              fontWeight: seleccionado
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: seleccionado,
                          selectedColor: _colorPorTipo(categoria),
                          onSelected: (_) {
                            setState(() {
                              _categoriaFiltrada = categoria;
                            });
                            _ajustarMapa();
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Mapa estilizado
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blueGrey.shade100),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                clipBehavior: Clip.antiAlias,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _nicaraguaCenter,
                    initialZoom: 10,
                    maxZoom: 18,
                    minZoom: 5,
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
            ),
          ],
        ),
      ),

      // Botón flotante para centrar el mapa
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1976D2),
        onPressed: () => _mapController.move(_nicaraguaCenter, 10),
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}
