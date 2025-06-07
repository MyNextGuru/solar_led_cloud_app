import 'package:flutter/material.dart';
import 'package:solar_application/Homepage.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';                                                                                                                                                                                                                                                                                                                 


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
  bool tp=true;
  var check=true;
  Future<bool> LoginFormat(String email,String password)async{
    try {
      final userCredintial= await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      print("Logged in: ${userCredintial}");
      final idToken = await userCredintial.user?.getIdToken();
      print("token id: $idToken");
      return true;
    }on FirebaseException catch (e) {
      print("Error: ${e.message}");
      return false;
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
              style: TextStyle(color: Colors.amber,fontWeight: FontWeight.bold),
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
              obscureText: tp,
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

                suffixIcon: IconButton(onPressed: (){
                  if(tp==true)
                  {
                    tp=false;
                  }
                  else
                  {
                    tp=true;
                  }
                }, icon: Icon(Icons.remove_red_eye))
              ),
            ),
          ),

          Container(
            height: 70,
            width: 100,
            child: ElevatedButton(onPressed: ()async{
               check= await LoginFormat(email.text, pass.text);
              if(check==true)
              {
                Navigator.push(context, MaterialPageRoute(builder:(context) => MyHomePage(),));
              }
            }, child: Text('Sign In'),
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
