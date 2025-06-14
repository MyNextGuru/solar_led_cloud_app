import 'package:flutter/material.dart';
import 'package:login_page/Homepage.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';    
import 'package:http/http.dart' as http;                                                                                                                                                                                                                                                                                                             


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
              final response=await http.get(Uri.parse('https://yeiis27b83.execute-api.eu-north-1.amazonaws.com/Fire/verify'),
              headers: {'Authorization': 'Bearer $check'}
              );
              if(response.statusCode==200)
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('login successfull'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ));
                Navigator.push(context, MaterialPageRoute(builder: (context)=> MyHomepage()));
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
            child: Text('Sign In'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            ),
          ),
        ],
      ),),
    );
  }
}
