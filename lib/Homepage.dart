import 'package:flutter/material.dart';


class MyHomePage extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title:  Center(child: Text('SolarApp'),),
        ),

        body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
          width: 300,
          height: 100,

          color: Colors.red,
        ),

        SizedBox(
          height: 20,

        ),

        Container(
          width: 300,
          height: 100,

          color: Colors.red,
        ),

          ],
        ),
        ),
      );
  }
}