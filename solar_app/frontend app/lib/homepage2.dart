import 'package:flutter/material.dart';

class MyHomepage22 extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Center(child: Text('SolarApp')),
      ),

      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 80,
            child: Text("user",style: TextStyle(fontSize: 20,color: Colors.red)),
          )
        ],
      ),),
    );
  }
}