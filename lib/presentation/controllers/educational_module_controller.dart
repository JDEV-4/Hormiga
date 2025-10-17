import 'package:flutter/foundation.dart';

class Lesson {
  final String id;
  final String title;
  final String content;
  bool completed;

  Lesson({
    required this.id,
    required this.title,
    required this.content,
    this.completed = false,
  });
}

class Module {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final List<Lesson> lessons;

  Module({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.lessons,
  });

  double get progress {
    if (lessons.isEmpty) return 0.0;
    final completed = lessons.where((l) => l.completed).length;
    return completed / lessons.length;
  }
}

class EducationalModuleController extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  final List<Module> _modules = [];

  List<Module> get modules => List.unmodifiable(_modules);

  EducationalModuleController() {
    // opcional: carga inicial
    loadModules();
  }

  Future<void> loadModules() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // Simula carga (en producción reemplaza por fetch a API/local)
      await Future.delayed(const Duration(milliseconds: 400));
      _modules.clear();
      _modules.addAll(_sampleModules());
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Error cargando módulos';
      notifyListeners();
    }
  }

  Module? getModuleById(String id) {
    try {
      return _modules.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  Lesson? getLessonById(String moduleId, String lessonId) {
    final module = getModuleById(moduleId);
    if (module == null) return null;
    try {
      return module.lessons.firstWhere((l) => l.id == lessonId);
    } catch (_) {
      return null;
    }
  }

  void toggleLessonCompleted(String moduleId, String lessonId) {
    final lesson = getLessonById(moduleId, lessonId);
    if (lesson == null) return;
    lesson.completed = !lesson.completed;
    notifyListeners();
  }

  List<Module> _sampleModules() {
    return [
      Module(
        id: 'm1',
        title: 'Seguridad Comunitaria',
        description: 'Conceptos básicos sobre prevención y respuesta ante incidentes.',
        thumbnailUrl: 'https://via.placeholder.com/150/006D65/ffffff?text=Seguridad',
        lessons: [
          Lesson(
            id: 'm1l1',
            title: 'Introducción a la seguridad',
            content:
                'En esta lección aprenderás los conceptos básicos de seguridad comunitaria y por qué es importante participar.',
          ),
          Lesson(
            id: 'm1l2',
            title: 'Prevención de riesgos',
            content:
                'Medidas prácticas para prevenir riesgos comunes en la comunidad: incendios, inundaciones, derrames, etc.',
          ),
        ],
      ),
      Module(
        id: 'm2',
        title: 'Primeros Auxilios',
        description: 'Guía rápida para atender emergencias hasta que llegue ayuda profesional.',
        thumbnailUrl: 'https://via.placeholder.com/150/FF7043/ffffff?text=Auxilios',
        lessons: [
          Lesson(
            id: 'm2l1',
            title: 'RCP básico',
            content:
                'Conceptos de RCP: cuándo aplicarlo, pasos 1-2-3 y consideraciones de seguridad.',
          ),
          Lesson(
            id: 'm2l2',
            title: 'Control de hemorragias',
            content:
                'Cómo aplicar presión, vendajes y cuándo evacuar al herido.',
          ),
          Lesson(
            id: 'm2l3',
            title: 'Atención a quemaduras',
            content:
                'Clasificación de quemaduras y medidas inmediatas de primeros auxilios.',
          ),
        ],
      ),
      Module(
        id: 'm3',
        title: 'Uso de la App La Hormiga',
        description: 'Cómo reportar incidentes, usar el mapa y comunicarse con la comunidad.',
        thumbnailUrl: 'https://via.placeholder.com/150/42A5F5/ffffff?text=App',
        lessons: [
          Lesson(
            id: 'm3l1',
            title: 'Reportar incidente',
            content:
                'Paso a paso para reportar un incidente correctamente: fotos, ubicación y descripción.',
          ),
          Lesson(
            id: 'm3l2',
            title: 'Mapa de incidentes',
            content:
                'Explora cómo interpretar marcadores, filtrar por tipo de incidente y compartir ubicación.',
          ),
        ],
      ),
    ];
  }
}
