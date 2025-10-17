// lib/presentation/pages/module_detail_page.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ModuleDetailPage extends StatefulWidget {
  final String title;
  final String description;
  final String asset;
  final String videoUrl;
  final String? moduleKey; // opcional: 'sismos', 'deslaves', 'incendios', 'huracanes'

  const ModuleDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.asset,
    required this.videoUrl,
    this.moduleKey,
  });

  @override
  State<ModuleDetailPage> createState() => _ModuleDetailPageState();
}

class _ModuleDetailPageState extends State<ModuleDetailPage> {
  bool isYouTube = false;
  bool loading = true;
  YoutubePlayerController? ytController;
  VideoPlayerController? videoController;
  ChewieController? chewieController;

  // Quiz state
  late List<Question> _questions;
  int _currentIndex = 0;
  Map<int, int> _answers = {}; // preguntaIndex -> opciónIndex
  bool _quizCompleted = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _questions = _questionsForModule(_detectModuleKey());
  }

  String _detectModuleKey() {
    if (widget.moduleKey != null && widget.moduleKey!.isNotEmpty) {
      return widget.moduleKey!.toLowerCase();
    }
    final t = widget.title.toLowerCase();
    if (t.contains('sismo')) return 'sismos';
    if (t.contains('deslave')) return 'deslaves';
    if (t.contains('incendio')) return 'incendios';
    if (t.contains('huracan') || t.contains('huracán')) return 'huracanes';
    return 'general';
  }

  void _initializeVideo() async {
    final url = widget.videoUrl;
    isYouTube = url.contains('youtube.com') || url.contains('youtu.be');

    if (isYouTube) {
      final videoId = YoutubePlayer.convertUrlToId(url);
      ytController = YoutubePlayerController(
        initialVideoId: videoId ?? '',
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
      setState(() => loading = false);
    } else {
      try {
        videoController = VideoPlayerController.networkUrl(Uri.parse(url));
        await videoController!.initialize();
        chewieController = ChewieController(
          videoPlayerController: videoController!,
          autoPlay: false,
          looping: false,
          allowFullScreen: true,
        );
      } catch (e) {
        debugPrint('Error inicializando video: $e');
      }
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    ytController?.dispose();
    chewieController?.dispose();
    videoController?.dispose();
    super.dispose();
  }

  // --- QUIZ DATA ---
  List<Question> _questionsForModule(String key) {
    switch (key) {
      case 'sismos':
        return [
          Question(
            text: '¿Cuál es la acción recomendada DURANTE un sismo?',
            options: [
              'Correr hacia las ventanas para salir rápido',
              'Agacharse, cubrirse y sujetarse',
              'Encender luces y electrodomésticos',
              'Subir a la azotea inmediatamente'
            ],
            correctIndex: 1,
            explanation: 'Durante un sismo lo correcto es agacharse, cubrirse y sujetarse en un lugar seguro.'
          ),
          Question(
            text: '¿Qué elemento es importante tener en tu mochila de emergencia?',
            options: ['Agua','Un libro','Zapatos de tacón','Juguetes'],
            correctIndex: 0,
            explanation: 'Una mochila de emergencia debe incluir agua, alimentos no perecederos, linterna y primeros auxilios.'
          ),
          Question(
            text: 'Después de un sismo, ¿qué debes verificar primero?',
            options: ['La conexión a Internet','Fugas de gas y daños estructurales','Tu correo electrónico','El horario de clases'],
            correctIndex: 1,
            explanation: 'Primero revisa fugas de gas, eléctricos y daños que puedan ser peligrosos antes de mover a las personas.'
          ),
        ];
      case 'deslaves':
        return [
          Question(
            text: '¿Cuál es una medida preventiva contra deslaves?',
            options: [
              'Construir en laderas inestables',
              'Evitar deforestación y mantener drenajes',
              'Excavar sin permisos',
              'Tirar basura en quebradas'
            ],
            correctIndex: 1,
            explanation: 'Mantener vegetación y buenos drenajes ayuda a reducir riesgo de deslaves.'
          ),
          Question(
            text: 'Si vives en zona de deslaves y escuchas ruido extraño en la ladera, ¿qué haces?',
            options: ['Ignorarlo','Evacuar hacia un lugar seguro','Ir a sacar fotos','Quedarte en casa'],
            correctIndex: 1,
            explanation: 'El ruido puede indicar movimiento de tierra — evacua y avisa a autoridades.'
          ),
        ];
      case 'incendios':
        return [
          Question(
            text: 'En caso de incendio en tu vivienda, ¿qué debes hacer primero?',
            options: ['Abrir todas las ventanas','Salir del lugar y llamar a emergencias','Intentar apagar sin plan','Buscar agua caliente'],
            correctIndex: 1,
            explanation: 'La prioridad es poner a salvo a las personas y llamar a los bomberos.'
          ),
          Question(
            text: '¿Qué elemento NO debes usar para apagar una llama en olla con aceite?',
            options: ['Tapar la olla','Usar un extintor adecuado','Verter agua','Retirar la olla del fuego (si es seguro)'],
            correctIndex: 2,
            explanation: 'Nunca verter agua en aceite en llamas; puede provocar explosión y propagación.'
          ),
        ];
      case 'huracanes':
        return [
          Question(
            text: 'Antes de un huracán, ¿qué es vital preparar?',
            options: [
              'Kit de emergencia con baterías y agua',
              'Salir a la calle a mirar el viento',
              'Dejar ventanas abiertas',
              'Guardar gasolina cerca de la casa'
            ],
            correctIndex: 0,
            explanation: 'Kit con agua, linterna, radio y medicinas es esencial.'
          ),
          Question(
            text: 'Durante un huracán, ¿qué lugar es más seguro en la casa?',
            options: ['Cerca de ventanas','En sótanos inundables','En habitaciones interiores sin ventanas','En el techo'],
            correctIndex: 2,
            explanation: 'Una habitación interior sin ventanas reduce riesgo por vidrios y vientos.'
          ),
        ];
      default:
        return [
          Question(
            text: '¿Qué debes hacer ante una emergencia?',
            options: ['Panic','Seguir plan de emergencia','Esperar a que otros llamen por ti','Nada'],
            correctIndex: 1,
            explanation: 'Tener y seguir un plan de emergencia es lo más efectivo.'
          ),
        ];
    }
  }

  // --- QUIZ LOGIC ---
  void _selectAnswer(int optionIndex) {
    if (_quizCompleted) return;
    setState(() {
      _answers[_currentIndex] = optionIndex;
    });
  }

  void _nextQuestion() {
    if (_answers[_currentIndex] == null) {
      // no answer selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una opción antes de continuar')),
      );
      return;
    }
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _submitQuiz();
    }
  }

  void _submitQuiz() {
    _score = 0;
    for (int i = 0; i < _questions.length; i++) {
      final a = _answers[i];
      if (a != null && a == _questions[i].correctIndex) _score++;
    }
    setState(() {
      _quizCompleted = true;
    });
  }

  void _retryQuiz() {
    setState(() {
      _answers.clear();
      _currentIndex = 0;
      _quizCompleted = false;
      _score = 0;
    });
  }

  // --- BUILD UI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFF234A68),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(widget.asset, height: 120, fit: BoxFit.contain),
            const SizedBox(height: 12),
            Text(widget.description, style: const TextStyle(fontSize: 15, height: 1.4)),
            const SizedBox(height: 18),
            const Text('Video informativo', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Video player
            if (loading)
              const Center(child: CircularProgressIndicator())
            else if (isYouTube && ytController != null)
              YoutubePlayer(controller: ytController!)
            else if (chewieController != null && videoController != null)
              AspectRatio(aspectRatio: videoController!.value.aspectRatio, child: Chewie(controller: chewieController!))
            else
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Text('No se pudo cargar el video')),
              ),

            const SizedBox(height: 20),

            // QUIZ collapsible card
            _buildQuizCard(),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              icon: const Icon(Icons.bookmark_border),
              label: const Text('Guardar módulo'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF234A68), minimumSize: const Size.fromHeight(48)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Módulo guardado en favoritos')));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0,4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quiz de aprendizaje', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Responde las preguntas para comprobar lo aprendido.', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),

          // If completed -> show results
          if (_quizCompleted) _buildQuizResult() else _buildQuestionView(),
        ],
      ),
    );
  }

  Widget _buildQuestionView() {
    final q = _questions[_currentIndex];
    final selected = _answers[_currentIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pregunta ${_currentIndex + 1} de ${_questions.length}', style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(q.text, style: const TextStyle(fontSize: 15)),
        const SizedBox(height: 12),
        ...List.generate(q.options.length, (i) {
          final isSelected = selected == i;
          return RadioListTile<int>(
            value: i,
            groupValue: selected,
            onChanged: (v) => _selectAnswer(v ?? 0),
            title: Text(q.options[i]),
            activeColor: const Color(0xFF234A68),
            selected: isSelected,
          );
        }),
        const SizedBox(height: 8),
        Row(
          children: [
            if (_currentIndex > 0)
              TextButton(
                onPressed: () => setState(() => _currentIndex--),
                child: const Text('Anterior'),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: _nextQuestion,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF234A68)),
              child: Text(_currentIndex == _questions.length - 1 ? 'Enviar' : 'Siguiente'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuizResult() {
    final total = _questions.length;
    final percent = (100 * _score / total).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Resultado: $_score / $total', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text('Porcentaje: $percent%', style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 12),

        // Detailed feedback
        const Text('Explicaciones:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...List.generate(_questions.length, (i) {
          final q = _questions[i];
          final user = _answers[i];
          final correct = q.correctIndex;
          final isOk = user != null && user == correct;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isOk ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('P${i+1}: ${q.text}', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text('Tu respuesta: ${user != null ? q.options[user] : 'Sin responder'}'),
              const SizedBox(height: 4),
              Text('Respuesta correcta: ${q.options[correct]}', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('Explicación: ${q.explanation}', style: const TextStyle(color: Colors.black54)),
            ]),
          );
        }),

        const SizedBox(height: 12),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _retryQuiz,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF234A68)),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () {
                // Aquí podrías guardar el resultado en backend o localmente
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resultado guardado localmente')));
              },
              child: const Text('Guardar resultado'),
            ),
          ],
        )
      ],
    );
  }
}

// Simple model para las preguntas
class Question {
  final String text;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  Question({
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}
