import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
// Este widget es la raíz de la aplicación.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Widget _defaultHome = CircularProgressIndicator();
  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _checkLoginStatus();
  }

// Cargar la preferencia de tema almacenada
  void _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? themeIndex = prefs.getInt('themeMode');
    setState(() {
      _themeMode = ThemeMode.values[themeIndex ?? 0];
    });
  }

// Verificar si el usuario ha iniciado sesión
  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    setState(() {
      if (userId != null) {
        _defaultHome = HomeScreen(
          onThemeChanged: _toggleThemeMode,
        );
      } else {
        _defaultHome = LoginScreen(
          onThemeChanged: _toggleThemeMode,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Red Social Básica',
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.light()),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.light()),
      themeMode: _themeMode, // Modo de tema seleccionado
      home: _defaultHome,
    );
  }

  void _toggleThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
    _saveThemePreference(mode);
  }

// Guardar la preferencia de tema
  void _saveThemePreference(ThemeMode mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
  }
}

class MyHomePage extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;
  MyHomePage({required this.onThemeChanged});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Red Social Básica'),
        actions: [
          PopupMenuButton<ThemeMode>(
            onSelected: onThemeChanged,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: ThemeMode.system,
                child: Text('Predeterminado'),
              ),
              PopupMenuItem(
                value: ThemeMode.light,
                child: Text('Modo Claro'),
              ),
              PopupMenuItem(
                value: ThemeMode.dark,
                child: Text('Modo Oscuro'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Text('Bienvenido a la Red Social Básica'),
      ),
    );
  }
}
