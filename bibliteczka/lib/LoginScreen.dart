import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Color.fromRGBO(253, 249, 240, 1),
      appBar: AppBar(
        title: Text(
          'Biblioteczka',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'LobsterTwo',
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              fontSize: 35),
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Color.fromRGBO(242, 224, 157, 1),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_sharp),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Logowanie",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'LobsterTwo',
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                fontSize: 50,
              ),
            ),
            Row(children: [
              Spacer(
                flex: 2,
              ),
              Text(
                "Nazwa użytkownika",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'LobsterTwo',
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                ),
              ),
              Spacer(
                flex: 6,
              ),
            ]),
            Row(children: [
              Spacer(
                flex: 2,
              ),
              Flexible(
                child: TextFormField(
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Enter email address"),
                    EmailValidator(errorText: "Please correct email filled"),
                  ]),
                  decoration: InputDecoration(
                    hintText: "Email",
                    labelText: "Email",
                    errorStyle: TextStyle(fontSize: 18.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(9.0))),
                  ),
                ),
                flex: 9,
              ),
              Spacer(
                flex: 2,
              )
            ]),
          ],
        ),
      ));
}
