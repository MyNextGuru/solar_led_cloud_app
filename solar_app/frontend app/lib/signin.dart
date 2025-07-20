import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class signin extends StatefulWidget
{
  @override
  State<signin> createState() => _signin();
}
class _signin extends State<signin>
{
  var email=TextEditingController();
  var pass=TextEditingController();

  String role = '';
  bool isManufacturer = false;
  bool isUser = false;

  void updateRole(String selectedRole) {
    setState(() {
      role = selectedRole;
      isManufacturer = selectedRole == 'manufacturer';
      isUser = selectedRole == 'user';
    });
  }



  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Center(child: Text('SolarApp')),
      ),

      body: SingleChildScrollView(child: Center(
        child: Column(
          children: [
             Container(
            height: 70,
            width: 120,
            child: RichText(text: TextSpan(
              style: TextStyle(color: Colors.amber,fontWeight: FontWeight.bold,fontSize: 30),
              children:<TextSpan> [
                TextSpan(text: 'Sign'),
                TextSpan(text: 'In', style: TextStyle(color: Colors.black)),
              ]
            ),
            ),

            ),
            Container(
              height: 70,
              width: 300,
              child: TextField(
                controller: email,
                decoration: InputDecoration(
                  hintText: 'Enter your emailId',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.green,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                ),
              ),
            ),
            
            Container(
              height: 70,
              width: 300,
              child: TextField(
                controller: pass,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.green,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                ),
              ),
            ),

            Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(10),
      ),
      child:Column(
        children: [
          CheckboxListTile(
            title: Text('Manufacturer'),
            value: isManufacturer,
            onChanged: (_) => updateRole('manufacturer'),
          ),
          CheckboxListTile(
            title: Text('User'),
            value: isUser,
            onChanged: (_) => updateRole('user'),
          ),
          SizedBox(height: 10),
          Text(
            'Selected Role: $role',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),

         Container(
            height: 70,
            width: 100,
            child: ElevatedButton(onPressed: ()async{
              Map<String, dynamic> data = {
              "email": email.text,
              "password": pass.text,
              "role": role,
            };

            String jsonData = jsonEncode(data);

            Map<String, dynamic> data3 = {
              "email": email.text,
              "password": pass.text,
            };

            String jsonData1 = jsonEncode(data3);

              final url1 = Uri.parse('http://127.0.0.1:5000/auth-only-register');
              final response2 = await http.post(
                url1,
                headers: {
                            "Content-Type": "application/json",
                          },
                body: jsonData1
                  );
              final url = Uri.parse('http://127.0.0.1:5000/register'); // Replace with your actual IP or server URL

            final response = await http.post(
                url,
                headers: {
                            "Content-Type": "application/json",
                          },
                body: jsonData
                  );

                  if(response.statusCode==200 && response2.statusCode==200)
                  {
                        ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('login successfull'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ));
                  }
                  else
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Wrong Input!! Please check'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                  ));
                  }

                  final data1=jsonDecode(response.body);
                  print("status: ${data["message"]}");
             
            },
            child: Text('submit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            ),
          ),
          ],
        ),
      ),
      ),
    );
  }
}