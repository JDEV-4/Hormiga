import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificacionesScreen extends StatelessWidget {
  final List<Map<String, String>> notificaciones;

  const NotificacionesScreen({super.key, required this.notificaciones});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notificaciones',
          style: GoogleFonts.sourceSans3(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1976D2),
        elevation: 4,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF63A4FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: notificaciones.isEmpty
            ? Center(
                child: Text(
                  'No tienes notificaciones.',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: notificaciones.length,
                itemBuilder: (context, index) {
                  final notif = notificaciones[index];
                  final mensaje = notif['mensaje'] ?? '';
                  final tipo = notif['tipo'] ?? 'general';

                  // Colores e iconos
                  Color bgColor;
                  Color iconBgColor;
                  IconData icon;
                  switch (tipo.toLowerCase()) {
                    case 'deslave':
                      bgColor = Colors.orange.shade50;
                      iconBgColor = Colors.orange.shade200;
                      icon = Icons.terrain;
                      break;
                    case 'tormenta':
                      bgColor = Colors.blue.shade50;
                      iconBgColor = Colors.blue.shade200;
                      icon = Icons.cloud;
                      break;
                    case 'incendio':
                      bgColor = Colors.red.shade50;
                      iconBgColor = Colors.red.shade200;
                      icon = Icons.local_fire_department;
                      break;
                    default:
                      bgColor = Colors.grey.shade100;
                      iconBgColor = Colors.grey.shade300;
                      icon = Icons.notifications;
                  }

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: iconBgColor,
                        radius: 26,
                        child: Icon(icon, color: Colors.white, size: 28),
                      ),
                      title: Text(
                        mensaje,
                        style: GoogleFonts.sourceSans3(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.black45,
                      ),
                      onTap: () {
                        // Acción al tocar la notificación
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
