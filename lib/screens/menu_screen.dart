import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'Mi barrio más limpio', 'icon': Icons.house},
      {'title': 'Mis Reportes', 'icon': Icons.report},
      {'title': 'Próximos Eventos', 'icon': Icons.campaign},
      {'title': 'Horario del camión', 'icon': Icons.event},
      {'title': 'Configuración', 'icon': Icons.settings},
      {'title': 'Acerca de', 'icon': Icons.info},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (context, idx) {
          final it = items[idx];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(it['icon'] as IconData, size: 36),
                  const SizedBox(height: 12),
                  Text(it['title'] as String, textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
