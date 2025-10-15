import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'mapa_incidentes_page.dart';

class ReportIncidentPage extends StatefulWidget {
  const ReportIncidentPage({super.key});

  @override
  State<ReportIncidentPage> createState() => _ReportIncidentPageState();
}

class _ReportIncidentPageState extends State<ReportIncidentPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedType;
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _incidentTypes = [
    'Inundación',
    'Incendio',
    'Deslizamiento',
    'Corte de energía',
    'Otro'
  ];

  File? _selectedImage;
  bool _showImageError = false;
  LatLng? _currentPosition;
  String _departamento = 'Desconocido';
  String _municipio = 'Desconocido';
  String _comunidad = 'Desconocido';

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _showImageError = false;
      });
    }
  }

  // Obtener ubicación precisa y nombres de lugar
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Activa la ubicación para continuar.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permisos de ubicación denegados permanentemente.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Obtener ubicación GPS exacta
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      _currentPosition = LatLng(position.latitude, position.longitude);

      // Geocoding inverso para obtener Departamento, Municipio y Comunidad
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        _departamento = place.administrativeArea ?? 'Desconocido';
        _municipio = place.subAdministrativeArea ?? 'Desconocido';
        _comunidad = place.subLocality ?? place.locality ?? 'Desconocido';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al obtener ubicación: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      Navigator.of(context).pop();
    }
  }

  void _submitReport() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    if (_selectedImage == null) {
      setState(() {
        _showImageError = true;
      });
      return;
    }

    await _getCurrentLocation();
    if (_currentPosition == null) return;

    final newIncident = {
      'tipo': _selectedType!,
      'descripcion': _descriptionController.text,
      'imagen': _selectedImage,
      'ubicacion': _currentPosition!,
      'departamento': _departamento,
      'municipio': _municipio,
      'comunidad': _comunidad,
    };

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reporte enviado'),
        content: const Text('Tu reporte fue enviado correctamente.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => MapaIncidentesPage(
                    incidenteNuevo: newIncident,
                  ),
                ),
              );
            },
            child: const Text('OK', style: TextStyle(color: Color(0xFF006D65))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar Incidente'),
        backgroundColor: const Color(0xFF006D65),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tipo de incidente',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                hint: const Text('Selecciona un tipo'),
                items: _incidentTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedType = value),
                validator: (value) =>
                    value == null ? 'Selecciona un tipo de incidente' : null,
              ),
              const SizedBox(height: 16),
              const Text('Descripción',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Describe brevemente lo ocurrido.',
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              const Text('Imagen del incidente',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedImage != null
                          ? Colors.green
                          : (_showImageError ? Colors.red : Colors.grey),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.cover)
                      : const Center(
                          child: Icon(Icons.add_a_photo,
                              size: 40, color: Colors.grey),
                        ),
                ),
              ),
              if (_showImageError)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Se requiere una imagen para validar el incidente.',
                    style: TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006D65),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text('Enviar reporte',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: _submitReport,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
