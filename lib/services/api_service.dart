// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/post.dart';
import '../models/comment.dart';

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/';

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Error al cargar usuarios: ${response.reasonPhrase}');
    }
  }

// Obtener publicaciones
  Future<List<Post>> getPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Error al cargar publicaciones');
    }
  }

// Obtener comentarios de una publicación
  Future<List<Comment>> getComments(int postId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/posts/$postId/comments'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((comment) => Comment.fromJson(comment)).toList();
    } else {
      throw Exception('Error al cargar comentarios');
    }
  }

// Añadir comentario a una publicación
  Future<Comment> addComment(
      int postId, String name, String email, String body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/comments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'postId': postId,
        'name': name,
        'email': email,
        'body': body,
      }),
    );
    if (response.statusCode == 201) {
      return Comment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al añadir comentario');
    }
  }
}
