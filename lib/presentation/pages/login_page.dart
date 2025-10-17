// presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool isLogin = true; // Alterna entre Login y Registro
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  late final AnimationController _animController;
  late final Animation<double> _cardAnimation;

  static const Color azul = Color(0xFF234A68);

  final AuthController _auth = AuthController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _cardAnimation =
        CurvedAnimation(parent: _animController, curve: Curves.easeOutBack);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleForm() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void _showMessage(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.redAccent : azul,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final enteredUser = _usernameController.text.trim();
    final enteredPass = _passwordController.text;

    if (isLogin) {
      setState(() => _loading = true);
      final result = await _auth.login(enteredUser, enteredPass);
      setState(() => _loading = false);

      if (result['ok'] == true) {
        _showMessage('Inicio de sesión exitoso');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        _showMessage(result['message'] ?? 'Usuario o contraseña incorrectos', error: true);
      }
    } else {
      final phone = _phoneController.text.trim();
      if (phone.isEmpty) {
        _showMessage('Ingrese su número de teléfono', error: true);
        return;
      }

      setState(() => _loading = true);
      final result = await _auth.register(enteredUser, enteredPass, phone);
      setState(() => _loading = false);

      if (result['ok'] == true) {
        _showMessage('Registro exitoso — ahora puedes iniciar sesión');
        _usernameController.clear();
        _passwordController.clear();
        _phoneController.clear();
        setState(() => isLogin = true);
      } else {
        _showMessage(result['message'] ?? 'No se pudo registrar', error: true);
      }
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: azul, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFEFF6F8),
                    Color(0xFFF4F6F8),
                    Color(0xFFFFFFFF),
                  ],
                  stops: [0.0, 0.45, 1.0],
                ),
              ),
            ),
            Positioned(
              top: -80,
              left: -50,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: azul.withOpacity(0.10),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: azul.withOpacity(0.08),
                      blurRadius: 60,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -60,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  color: azul.withOpacity(0.06),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: azul.withOpacity(0.06),
                      blurRadius: 80,
                      spreadRadius: 16,
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: ScaleTransition(
                  scale: _cardAnimation,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
                    constraints: const BoxConstraints(maxWidth: 520),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.99),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade100, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 26,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isLogin ? 'Bienvenido de nuevo' : 'Crea tu cuenta',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: azul,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    isLogin
                                        ? 'Accede con tu usuario para continuar'
                                        : 'Regístrate para comenzar',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Divider(color: Colors.grey.shade200, thickness: 1, height: 1),
                        const SizedBox(height: 18),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _usernameController,
                                decoration: _inputDecoration(
                                    label: "Usuario", icon: Icons.person_outline),
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
                                        ? "Ingrese su usuario"
                                        : null,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: _inputDecoration(
                                    label: "Contraseña", icon: Icons.lock_outline),
                                validator: (value) => value == null || value.isEmpty
                                    ? "Ingrese su contraseña"
                                    : null,
                              ),
                              const SizedBox(height: 12),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: isLogin
                                    ? const SizedBox.shrink()
                                    : Column(
                                        children: [
                                          TextFormField(
                                            controller: _phoneController,
                                            keyboardType: TextInputType.phone,
                                            decoration: _inputDecoration(
                                                label: "Número de teléfono", icon: Icons.phone),
                                            validator: (value) {
                                              if (!isLogin &&
                                                  (value == null || value.trim().isEmpty)) {
                                                return "Ingrese su número de teléfono";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 12),
                                        ],
                                      ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _loading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: azul,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                    elevation: 6,
                                    shadowColor: azul.withOpacity(0.28),
                                  ),
                                  child: _loading
                                      ? SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(Colors.white),
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          isLogin ? "Iniciar sesión" : "Registrarse",
                                          style: const TextStyle(
                                              fontSize: 16, color: Colors.white),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isLogin ? "¿No tienes cuenta?" : "¿Ya tienes cuenta?",
                                    style: TextStyle(
                                        color: Colors.grey.shade700, fontSize: 13),
                                  ),
                                  TextButton(
                                    onPressed: _toggleForm,
                                    child: Text(
                                      isLogin ? " Regístrate" : " Inicia sesión",
                                      style: TextStyle(
                                        color: azul,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
