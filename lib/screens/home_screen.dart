import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'users_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'post_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  HomeScreen({required this.onThemeChanged});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiService apiService = ApiService();
  late Future<List<Post>> futurePosts;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    futurePosts = apiService.getPosts();
    _loadUserInfo();
  }

  // Método para cargar el nombre del usuario desde SharedPreferences
  void _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, $_userName'),
        actions: [
          IconButton(
            icon: Icon(Icons.people),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UsersScreen()),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'theme') {
                _showThemeSelection();
              } else if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'theme',
                child: Text('Cambiar Tema'),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Text('Cerrar Sesión'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Post> posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return _buildPostCard(posts[index]);
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(
                post.userId.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              post.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Autor ID: ${post.userId}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostDetailScreen(post: post)),
              );
            },
          ),
          Image.network(
            'https://via.placeholder.com/300',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              post.body,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_up_alt_outlined),
                      onPressed: () {
                        // Funcionalidad de Me Gusta (simulada)
                      },
                    ),
                    Text('Me Gusta'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                        // Funcionalidad de Compartir (simulada)
                      },
                    ),
                    Text('Compartir'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeSelection() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Seleccionar Tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text('Predeterminado'),
              value: ThemeMode.system,
              groupValue: ThemeMode.system,
              onChanged: (value) {
                widget.onThemeChanged(value!);
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text('Modo Claro'),
              value: ThemeMode.light,
              groupValue: ThemeMode.light,
              onChanged: (value) {
                widget.onThemeChanged(value!);
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text('Modo Oscuro'),
              value: ThemeMode.dark,
              groupValue: ThemeMode.dark,
              onChanged: (value) {
                widget.onThemeChanged(value!);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          onThemeChanged: widget.onThemeChanged,
        ),
      ),
    );
  }
}
