import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import '../utils/ubicacion_helper.dart';

class ReporteScreen extends StatefulWidget {
  const ReporteScreen({super.key});

  @override
  State<ReporteScreen> createState() => _ReporteScreenState();
}

class _ReporteScreenState extends State<ReporteScreen> {
  String? ciudadSeleccionada; // 🔹 Nombre de la ciudad
  File? imagenSeleccionada;
  final TextEditingController _descripcionController = TextEditingController();

  Future<void> elegirUbicacion() async {
    String? ciudad = await UbicacionHelper.obtenerCiudadActual();
    if (ciudad != null) {
      setState(() => ciudadSeleccionada = ciudad);
    }
  }

  Future<void> seleccionarImagen() async {
    final picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() => imagenSeleccionada = File(imagen.path));
    }
  }

  void eliminarImagen() {
    setState(() => imagenSeleccionada = null);
  }

  void guardarReporte() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Reporte enviado (simulado)")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reporte de Incidente"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🐜 Logo
            Center(
              child: Image.asset("assets/images/Hormiga.png", height: 100),
            ),
            const SizedBox(height: 20),

            // ampo de descripción
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(
                    hintText: "Descripción del incidente",
                    border: InputBorder.none,
                    icon: Icon(Icons.description, color: Colors.blueAccent),
                  ),
                  maxLines: 3,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // btón de subir foto
            ElevatedButton.icon(
              onPressed: seleccionarImagen,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.photo_camera),
              label: const Text("Subir foto"),
            ),

            //Imagen seleccionada
            if (imagenSeleccionada != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 150, // 🔹 menos alta
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: FileImage(imagenSeleccionada!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: eliminarImagen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            //Botón ubicación
            ElevatedButton.icon(
              onPressed: elegirUbicacion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.location_on),
              label: const Text("Agregar ubicación"),
            ),
            if (ciudadSeleccionada != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Ubicación seleccionada: $ciudadSeleccionada",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // Botón enviar
            ElevatedButton.icon(
              onPressed: guardarReporte,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.send),
              label: const Text(
                "Enviar reporte",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
