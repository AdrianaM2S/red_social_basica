import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProfileScreen extends StatelessWidget {
  final User user;
  UserProfileScreen({required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            child: Text(user.name.substring(0, 1)),
          ),
          SizedBox(height: 20),
          Text(
            user.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('@${user.username}'),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(user.email),
          ),
// Puedes añadir más información como dirección, teléfono, etc.
        ],
      ),
    );
  }
}
