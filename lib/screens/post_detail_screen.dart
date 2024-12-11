import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../services/api_service.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  PostDetailScreen({required this.post});
  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  ApiService apiService = ApiService();
  late Future<List<Comment>> futureComments;
  @override
  void initState() {
    super.initState();
    futureComments = apiService.getComments(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publicación'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Información de la publicación
            ListTile(
              leading: CircleAvatar(
                child: Text(widget.post.userId.toString()),
              ),
              title: Text(
                widget.post.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Autor ID: ${widget.post.userId}'),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(widget.post.body),
            ),
            Divider(),
            // Comentarios
            Padding(
              padding: EdgeInsets.all(16),
              child: Text('Comentarios', style: TextStyle(fontSize: 18)),
            ),
            _buildCommentsSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla para añadir un comentario
        },
        child: Icon(Icons.add_comment),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return FutureBuilder<List<Comment>>(
      future: futureComments,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Comment> comments = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.comment),
                title: Text(comments[index].name),
                subtitle: Text(comments[index].body),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error:${snapshot.error}'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
