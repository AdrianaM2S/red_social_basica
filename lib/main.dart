import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/users_screen.dart';

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

  // Guardar la preferencia de tema
  void _saveThemePreference(ThemeMode mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Red Social Básica',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.light(
          secondary: const Color.fromARGB(255, 66, 36, 69),
        ),
        appBarTheme: AppBarTheme(
          color: const Color.fromARGB(228, 137, 59, 197),
          iconTheme: IconThemeData(color: const Color.fromARGB(255, 0, 0, 0)),
          titleTextStyle: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0), fontSize: 20),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.dark(
          secondary: const Color.fromARGB(255, 56, 18, 70),
        ),
      ),
      themeMode: _themeMode, // Modo de tema seleccionado
      home: HomeScreen(
        onThemeChanged: _toggleThemeMode,
      ),
    );
  }

  void _toggleThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
    _saveThemePreference(mode);
  }
}

class HomeScreen extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;

  HomeScreen({required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Red Social Básica'),
        actions: [
          IconButton(
            icon: Icon(Icons.people),
            onPressed: () {
              // Añadir una animación de transición al navegar entre pantallas
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      UsersScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(begin: begin, end: end).chain(
                      CurveTween(curve: curve),
                    );
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                        position: offsetAnimation, child: child);
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.thumb_up_alt_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Funcionalidad la activada de Like')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Funcionalidad la activada de Share')),
              );
            },
          ),
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
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Bienvenido a la Red Social Básica')),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Bienvenido a la Red Social Básica',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
