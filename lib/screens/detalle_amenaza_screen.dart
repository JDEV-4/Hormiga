import 'package:flutter/material.dart';

class DetalleAmenazaScreen extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String icono;

  const DetalleAmenazaScreen({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(icono, style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 20),
            Text(
              descripcion,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
