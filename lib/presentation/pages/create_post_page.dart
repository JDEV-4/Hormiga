// lib/presentation/pages/create_post_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import '../controllers/home_controller.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  bool _loading = false;

  // Ubicación
  Position? _position;
  bool _gettingLocation = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? img = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );
      if (img != null) {
        setState(() => _pickedImage = img);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo seleccionar la imagen')),
        );
      }
    }
  }

  Future<void> _getLocation() async {
    setState(() => _gettingLocation = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Permiso de ubicación denegado')),
            );
          }
          setState(() => _gettingLocation = false);
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permiso de ubicación denegado permanentemente. Habilítalo en ajustes.')),
          );
        }
        setState(() => _gettingLocation = false);
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 8),
      );
      setState(() => _position = pos);
    } catch (e) {
      debugPrint('Error getting location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo obtener la ubicación')),
        );
      }
    } finally {
      setState(() => _gettingLocation = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final postData = {
        'title': _titleCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'imagePath': _pickedImage?.path,
        'latitude': _position?.latitude,
        'longitude': _position?.longitude,
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Llamamos al HomeController para crear la publicación
      final controller = context.read<HomeController>();
      await controller.createPost(postData);

      // Devolver true para que HomePage sepa que se creó un post
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      debugPrint('Error al crear post: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error creando la publicación')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (c) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () {
                Navigator.pop(c);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () {
                Navigator.pop(c);
                _pickImage(ImageSource.camera);
              },
            ),
            if (_pickedImage != null)
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Eliminar imagen'),
                onTap: () {
                  Navigator.pop(c);
                  setState(() => _pickedImage = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _previewImage() {
    if (_pickedImage == null) {
      return Container(
        height: 140,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: Text('No hay imagen seleccionada')),
      );
    } else {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(_pickedImage!.path),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: 6,
            top: 6,
            child: InkWell(
              onTap: () => setState(() => _pickedImage = null),
              child: Container(
                decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear publicación'),
        backgroundColor: const Color(0xFF234A68),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Título
                TextFormField(
                  controller: _titleCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    hintText: 'Escribe un título para tu publicación',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'El título es obligatorio' : null,
                ),
                const SizedBox(height: 12),

                // Descripción
                TextFormField(
                  controller: _descCtrl,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Cuenta brevemente lo que quieres compartir',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'La descripción es obligatoria' : null,
                ),
                const SizedBox(height: 12),

                // Imagen
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Imagen', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _showImageOptions,
                  child: _previewImage(),
                ),
                const SizedBox(height: 12),

                // Ubicación
                Row(
                  children: [
                    Expanded(
                      child: _position == null
                          ? OutlinedButton.icon(
                              onPressed: _gettingLocation ? null : _getLocation,
                              icon: const Icon(Icons.my_location),
                              label: Text(_gettingLocation ? 'Obteniendo...' : 'Obtener ubicación'),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Ubicación obtenida', style: TextStyle(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                Text('Lat: ${_position!.latitude.toStringAsFixed(6)}'),
                                Text('Lng: ${_position!.longitude.toStringAsFixed(6)}'),
                                TextButton.icon(
                                  onPressed: _getLocation,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Actualizar'),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _loading ? null : _submit,
                        icon: _loading
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.send),
                        label: Text(_loading ? 'Publicando...' : 'Publicar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF234A68),
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _loading ? null : () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
