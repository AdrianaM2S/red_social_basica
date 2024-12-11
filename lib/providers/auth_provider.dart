import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  ThemeMode _themeMode = ThemeMode.system;
  ApiService _apiService = ApiService();
  User? get user => _user;
  ThemeMode get themeMode => _themeMode;
  void loadUserFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    if (userId != null) {
      String? userName = prefs.getString('userName');
      String? userEmail = prefs.getString('userEmail');
      String? userUsername = prefs.getString('userUsername');
      _user = User(
        id: userId,
        name: userName ?? '',
        email: userEmail ?? '',
        username: userUsername ?? '',
      );
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    List<User> users = await _apiService.getUsers();
    User? user = users.firstWhere(
      (user) =>
          user.email.toLowerCase() == email.toLowerCase() &&
          user.username == password,
      orElse: () => null,
    );
    if (user != null) {
      _user = user;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', user.id);
      await prefs.setString('userName', user.name);
      await prefs.setString('userEmail', user.email);
      await prefs.setString('userUsername', user.username);
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() async {
    _user = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userUsername');
    notifyListeners();
  }

  void loadThemeFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? themeIndex = prefs.getInt('themeMode');
    _themeMode = ThemeMode.values[themeIndex ?? 0];
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    notifyListeners();
  }
}
