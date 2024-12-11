import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'user_profile_screen.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  ApiService apiService = ApiService();
  late Future<List<User>> futureUsers;
  @override
  void initState() {
    super.initState();

    futureUsers = apiService.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios'),
      ),
      body: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<User> users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index].name),
                  subtitle: Text('@${users[index].username}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UserProfileScreen(user: users[index])),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error:${snapshot.error}'));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
