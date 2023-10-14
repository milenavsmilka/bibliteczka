import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(
          'Biblioteczka',
          style: Theme.of(context).textTheme.headline2,
        ),
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
              style: Theme.of(context).textTheme.headline1,
            ),
            Row(children: [
              Spacer(
                flex: 2,
              ),
              Text(
                "Nazwa użytkownika",
                style: Theme.of(context).textTheme.headline5,
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
            Row(children: [
              Spacer(
                flex: 2,
              ),
              Text(
                "Hasło",
                style: Theme.of(context).textTheme.headline5,
              ),
              Spacer(
                flex: 9,
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
        Flexible(
          flex: 2,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(

            ),
            child: Text(
              "Zaloguj",
              style: Theme.of(context).textTheme.headline4,
            ),
            onPressed: () {},
          ),
        ),
          ],
        ),
      ));
}
