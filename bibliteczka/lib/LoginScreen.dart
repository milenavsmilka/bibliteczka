import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Login screnn'),
      centerTitle: true,
    ),
    body: Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(20),
        ),
        child: Text('LAst creen'),
        onPressed: (){

        },
      ),
    )
  );
}