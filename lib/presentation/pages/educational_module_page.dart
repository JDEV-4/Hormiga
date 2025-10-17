// lib/presentation/pages/educational_module_page.dart
import 'package:flutter/material.dart';
import 'module_detail_page.dart';

class EducationalModulePage extends StatelessWidget {
  const EducationalModulePage({super.key});

  static const Color kBlue = Color(0xFF234A68);

  final List<_ModuleItem> items = const [
    _ModuleItem(
      keyName: 'sismos',
      title: 'Sismos',
      description:
          '¿Sabes qué hacer antes, durante y después de un sismo? Prepárate y protege a tu comunidad.',
      asset: 'assets/img/sismos.png',
      videoUrl: 'https://youtu.be/XY0SIyuoqqQ?si=tVr8QxErYAhD-3jW',
    ),
    _ModuleItem(
      keyName: 'deslaves',
      title: 'Deslaves',
      description:
          'Aprende cómo prevenir y actuar ante deslaves o derrumbes en tu comunidad.',
      asset: 'assets/img/deslave.png',
      videoUrl: 'https://youtu.be/D142XygQGFc?si=SjFCmLmaTBr3ASZ6',
    ),
    _ModuleItem(
      keyName: 'incendios',
      title: 'Incendios',
      description:
          'Evita riesgos y conoce las medidas para enfrentar un incendio en tu comunidad.',
      asset: 'assets/img/incendios.png',
      videoUrl: 'https://youtu.be/UGjnPiU8VDk?si=JE2OsMD0Oe4QOnG2',
    ),
    _ModuleItem(
      keyName: 'huracanes',
      title: 'Huracanes',
      description:
          'Infórmate sobre los protocolos de seguridad frente a huracanes y tormentas.',
      asset: 'assets/img/huracanes.png',
      videoUrl: 'https://youtu.be/6Im9ezEwFdw?si=rqgBV2kU_AyUJW_v',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: AppBar(
        backgroundColor: kBlue,
        elevation: 0,
        title: const Text(
          'Módulo Educativo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Conoce cómo actuar ante amenazas naturales y protege a tu comunidad.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: GridView.count(
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.95,
                  children: items.map((item) {
                    return _ModuleCard(
                      item: item,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ModuleDetailPage(
                              title: item.title,
                              description: item.description,
                              asset: item.asset,
                              videoUrl: item.videoUrl ?? '',
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final _ModuleItem item;
  final VoidCallback onTap;

  const _ModuleCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 12,
                offset: Offset(0, 6),
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 72,
                child: Center(
                  child: _buildIconOrPlaceholder(item.asset, item.keyName),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  item.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    height: 1.18,
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconOrPlaceholder(String asset, String key) {
    return Image.asset(
      asset,
      width: 64,
      height: 64,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return CircleAvatar(
          radius: 30,
          backgroundColor: const Color(0xFFF2F6F8),
          child: Icon(
            _guessIcon(key),
            color: const Color(0xFF234A68),
            size: 28,
          ),
        );
      },
    );
  }

  IconData _guessIcon(String key) {
    switch (key) {
      case 'sismos':
        return Icons.location_on;
      case 'deslaves':
        return Icons.terrain;
      case 'incendios':
        return Icons.local_fire_department;
      case 'huracanes':
        return Icons.water_damage;
      default:
        return Icons.info;
    }
  }
}

class _ModuleItem {
  final String keyName;
  final String title;
  final String description;
  final String asset;
  final String? videoUrl;

  const _ModuleItem({
    required this.keyName,
    required this.title,
    required this.description,
    required this.asset,
    this.videoUrl,
  });
}
