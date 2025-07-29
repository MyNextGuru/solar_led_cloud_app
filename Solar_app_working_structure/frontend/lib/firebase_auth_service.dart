import 'package:final_structure/seller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'manufactuire_swtich.dart';
import 'seller_switch.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginAndNavigate({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Step 1: Sign in with Firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 2: Get Firebase ID token
      String? idToken = await userCredential.user?.getIdToken();

      if (idToken == null) {
        throw Exception("Could not retrieve Firebase token.");
      }

      // Step 3: Call Flask endpoint with Bearer token
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/verify'), // ✅ Replace with your actual endpoint
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
      );

      // Step 4: Parse response
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String role = data['role'];
        final String uid=data['uid'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login successful as $role"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
          ),
        );

        // Step 5: Navigate based on role
        if (role == 'manufacturer') {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> Manufacture_switch(pass: uid)));
        } else if (role == 'seller') {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> Seller_switch()));
        } else {
          throw Exception("Unknown role: $role");
        }
      } else {
        final error = jsonDecode(response.body);
        throw Exception("Backend error: ${error['error'] ?? response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ Login failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.toString()}"),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        ),
      );
    }
  }
}
