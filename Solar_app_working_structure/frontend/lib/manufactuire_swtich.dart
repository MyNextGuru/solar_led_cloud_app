import 'package:flutter/material.dart';
import 'manufacture.dart';

class Manufacture_switch extends StatelessWidget
{
  final String pass;
  const Manufacture_switch({Key?key, required this.pass}): super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Center(child: Text("SolarApp"),),
        centerTitle: true,
      ),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 200,
            child: ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ManufacturerSetupPage(UniqueUserId: pass)));
            }, 
            child: Text("Device Configuration"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}