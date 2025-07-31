import 'package:flutter/material.dart';
import 'seller.dart';

class Seller_switch extends StatelessWidget
{
  const Seller_switch({Key? key}): super(key: key);

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
              Navigator.push(context, MaterialPageRoute(builder: (context)=> sellersetuppage()));
            }, 
            child: Text("Adjust Brightness"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white
            ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}