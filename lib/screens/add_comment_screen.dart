// lib/screens/add_comment_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/comment.dart';

class AddCommentScreen extends StatefulWidget {
  final int postId;
  AddCommentScreen({required this.postId});
  @override
  _AddCommentScreenState createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  final _formKey = GlobalKey<FormState>();
  String _commentBody = '';
  bool _isLoading = false;
  ApiService apiService = ApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Comentario'),
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
                      decoration: InputDecoration(labelText: 'Comentario'),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un comentario';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _commentBody = value!.trim();
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addComment,
                      child: Text('Enviar'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _addComment() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
// Obtener información del usuario autenticado
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userName = prefs.getString('userName');
        String? userEmail =
            prefs.getString('userEmail'); //Debemos almacenar esto previamente
        if (userName == null || userEmail == null) {
          _showError('Error al obtener información del usuario');
          setState(() {
            _isLoading = false;
          });
          return;
        }
        Comment newComment = await apiService.addComment(
          widget.postId,
          userName,
          userEmail,
          _commentBody,
        );
        Navigator.pop(context, newComment);
      } catch (e) {
        _showError('Error al enviar el comentario. Inténtalo de nuevo.');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
