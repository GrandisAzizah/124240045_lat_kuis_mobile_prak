import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../data_user.dart';
import './library_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _EmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  // ==== LOGIKA LOGI =====
  void _handleLogin() {
    // Cek dulu form kosong apa engga
    if (!_formKey.currentState!.validate()) return;

    String email = _EmailController.text.trim();
    String password = _passwordController.text.trim();

    // Cari inputan di data_user.dart
    final foundUser = users.firstWhere(
      (u) => u.email == email,
      orElse: () => User(email: '', password: ''),
    );

    // Hasil cek di data_user.dart
    if (foundUser.email.isEmpty) {
      // Email ga ada
      _showSnackBar('Email salah! Coba lagi.');
    } else if (foundUser.password != password) {
      // Password salah
      _showSnackBar('Password salah! Silakan coba lagi.');
    } else {
      // Login berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LibraryPage()),
      );
    }
  }

  // ===== HELPER SNACKBAR =====
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(message, overflow: TextOverflow.ellipsis),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.primary,
        body: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: AppTheme.white,
                    margin: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacingLarge,
                      horizontal: AppTheme.spacingMedium,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingMedium),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            Icons.person,
                            size: 80,
                            color: AppTheme.primary,
                          ),
                          const SizedBox(height: AppTheme.spacingLarge),
                          _formWidget(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formWidget() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // ===== EMAIL =====
          const Text(
            'Email',
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              fontWeight: FontWeight.bold,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSmall),
          TextFormField(
            controller: _EmailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              hintText: 'Masukkan Email',
              hintStyle: TextStyle(color: AppTheme.grey),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email masih kosong, silakan diisi';
              }

              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return 'Format Email tidak valid';
              }
              return null;
            },
          ),
          const SizedBox(height: AppTheme.spacingMedium),

          // ===== PASSWORD =====
          const Text(
            'Password',
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              fontWeight: FontWeight.bold,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSmall),
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              hintText: 'Masukkan password',
              hintStyle: const TextStyle(color: AppTheme.grey),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password masih kosong, silakan diisi';
              }
              return null;
            },
          ),
          const SizedBox(height: AppTheme.spacingLarge),

          // ===== TOMBOL LOGIN =====
          ElevatedButton(
            onPressed: _handleLogin,
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: AppTheme.fontSizeBody,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
