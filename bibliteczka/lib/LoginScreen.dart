import 'package:bibliteczka/styles/LightTheme.dart';
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
        body: SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(
              bottom: MediaQuery.of(context).size.height * 0.1,
              top: MediaQuery.of(context).size.height * 0.2,
              start: MediaQuery.of(context).size.width * 0.1,
              end: MediaQuery.of(context).size.width * 0.1),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 2,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Text(
                    "Nazwa użytkownika",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ]),
                Row(children: [
                  Flexible(
                    child: TextFormField(
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Enter email address"),
                        EmailValidator(
                            errorText: "Please correct email filled"),
                      ]),
                      decoration: InputDecoration(
                        labelStyle: Theme.of(context).textTheme.headline6,
                        labelText: "Wpisz nazwę użytkownika",
                        errorStyle:
                            TextStyle(fontSize: 18.0, color: Colors.red),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: categoryButtonCyanColor, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: categoryButtonCyanColor),
                        ),
                      ),
                    ),
                  ),
                ]),
                Row(children: [
                  Text(
                    "Hasło",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ]),
                Row(children: [
                  Flexible(
                    child: TextFormField(
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Enter email address"),
                          EmailValidator(
                              errorText: "Please correct email filled"),
                        ]),
                        decoration: InputDecoration(
                          labelStyle: Theme.of(context).textTheme.headline6,
                          labelText: "Podaj hasło",
                          errorStyle: TextStyle(fontSize: 18.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: categoryButtonCyanColor, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: categoryButtonCyanColor),
                          ),
                        )),
                  ),
                ]),
                const SizedBox(height: 2),
                Center(
                  child: ElevatedButton(
                    child: Text("Zaloguj"),
                    onPressed: () {},
                  ),
                ),
                Center(
                    child: Row(
                  children: [
                    Text("Lub zarejestruj się ",
                        style: Theme.of(context).textTheme.headline6),
                    TextButton(onPressed: () {}, child: Text("tutaj"))
                  ],
                  mainAxisSize: MainAxisSize.min,
                ))
              ],
            ),
          ),
        ),
      );
}
