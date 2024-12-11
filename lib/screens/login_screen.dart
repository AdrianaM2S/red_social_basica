// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  LoginScreen({required this.onThemeChanged});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
        actions: [
          PopupMenuButton<ThemeMode>(
            onSelected: widget.onThemeChanged,
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: ThemeMode.system, child: Text('Predeterminado')),
              PopupMenuItem(value: ThemeMode.light, child: Text('Modo Claro')),
              PopupMenuItem(value: ThemeMode.dark, child: Text('Modo Oscuro')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Correo Electrónico'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu correo electrónico';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!.trim();
                      },
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Nombre de Usuario'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu nombre de usuario';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!.trim();
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      child: Text('Iniciar Sesión'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        List<User> users = await apiService.getUsers();
        User? user = users.firstWhere(
          (user) =>
              user.email.toLowerCase() == _email.toLowerCase() &&
              user.username == _password,
          orElse: () => User(id: 0, email: '', username: '', name: ''),
        );

        if (user.id != 0) {
          // Guardar la sesión del usuario
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('userId', user.id);
          await prefs.setString('userName', user.name);

          // Navegar a la pantalla principal
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(onThemeChanged: widget.onThemeChanged),
            ),
          );
        } else {
          _showError('Credenciales incorrectas');
        }
      } catch (e) {
        _showError('Error al iniciar sesión. Inténtalo de nuevo.');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
