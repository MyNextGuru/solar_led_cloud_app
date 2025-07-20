import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:login_page/Homepage.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';    
import 'package:http/http.dart' as http;    
import 'signin.dart';                 
import 'homepage2.dart';                                                                                                                                                                                                                                                                                        


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({Key ? key}) : super(key : key);

  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: LoginPage()
      );
  }
}

class LoginPage extends StatelessWidget
{
  var email=TextEditingController();
  var pass=TextEditingController();
  
  Future<String?> LoginFormat(String email,String password)async{
    try {
      final userCredintial= await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      //print("Logged in: ${userCredintial}");
      final idToken = await userCredintial.user?.getIdToken();
      //print("token id: $idToken");
      return idToken;
    }on FirebaseException catch (e) {
      
    }
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Center(child: Text('Solar App'),),
      ),

      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 70,
            width: 120,
            child: RichText(text: TextSpan(
              style: TextStyle(color: Colors.amber,fontWeight: FontWeight.bold,fontSize: 30),
              children:<TextSpan> [
                TextSpan(text: 'Log'),
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
              obscureText: true,
              obscuringCharacter: '*',
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
            height: 70,
            width: 100,
            child: ElevatedButton(onPressed: ()async{
              String? check= await LoginFormat(email.text, pass.text);
              final response=await http.get(Uri.parse('http://127.0.0.1:5000/verify'),
              headers: {'Authorization': 'Bearer $check'}
              );
              if(response.statusCode==200)
              {
                final jsonData = jsonDecode(response.body);
                String role = jsonData['role'];
                if (role == 'manufacturer') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomepage()));
                } else if (role == 'user') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomepage22()));
                } 
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Successful'),
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
            },
            child: Text('Log In'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            ),
          ),
          Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("do not have an account?",style: TextStyle(color: Colors.amber),),

              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> signin()));
                },
                child: Text("sign in",style: TextStyle(color: Colors.blue),),
              ),
            ],
          ),
          ),
        ],
      ),),
    );
  }
}
