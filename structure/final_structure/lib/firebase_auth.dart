import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Import your screen widgets
import 'manufacture.dart';
import 'seller.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginAndNavigate({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Authenticate with Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve JWT token
      String? token = await userCredential.user!.getIdToken();

      // Send token to Flask backend
      final response = await http.post(
        Uri.parse('https://your-flask-app.com/validate_token'), // Replace with your Flask endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'token': token}),
      );

      // Dismiss loading indicator
      Navigator.pop(context);

      if (response.statusCode == 200) {
        // Parse role from response
        final data = json.decode(response.body);
        String role = data['role'];

        // Navigate based on role
        if (role == 'manufacturer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ManufacturerSetupPage()),
          );
        } else if (role == 'seller') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DeviceReportPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unknown role returned')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backend error: ${response.body}')),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Dismiss loading indicator
      Navigator.pop(context);

      // Handle authentication errors
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password provided.';
          break;
        case 'invalid-email':
          message = 'The email address is invalid.';
          break;
        default:
          message = 'Authentication failed. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      // Dismiss loading indicator
      Navigator.pop(context);

      // Handle unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred.')),
      );
    }
  }
}

// Example usage in your input panel widget
/*
class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: emailController),
          TextField(controller: passwordController, obscureText: true),
          ElevatedButton(
            onPressed: () {
              authService.loginAndNavigate(
                email: emailController.text,
                password: passwordController.text,
                context: context,
              );
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
*/