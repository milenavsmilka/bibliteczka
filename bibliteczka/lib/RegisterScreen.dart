import 'package:biblioteczka/LoginScreen.dart';
import 'package:biblioteczka/MainPanelScreen.dart';
import 'package:biblioteczka/styles/LightTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Biblioteczka'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_sharp),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(
              bottom: MediaQuery.of(context).size.height * 0.04,
              top: MediaQuery.of(context).size.height * 0.09,
              start: MediaQuery.of(context).size.width * 0.1,
              end: MediaQuery.of(context).size.width * 0.1),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 1.4,
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
                // const SizedBox(height: 8),
                Row(children: [
                  Flexible(
                    child: TextFormField(
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Enter email address"),
                        EmailValidator(
                            errorText: "Please correct email filled"),
                      ]),
                      decoration: InputDecoration(
                        labelText: "Wpisz nazwę użytkownika",
                      ),
                    ),
                  ),
                ]),
                // const SizedBox(height: 8),
                Row(children: [
                  Text(
                    "Email",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ]),
                // const SizedBox(height: 8),
                Row(children: [
                  Flexible(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Wpisz email",
                      ),
                    ),
                  ),
                ]),
                // const SizedBox(height: 8),
                Row(children: [
                  Text(
                    "Hasło",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ]),
                // const SizedBox(height: 8),
                Row(children: [
                  Flexible(
                    child: TextFormField(
                        obscureText: true,
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Enter email address"),
                          EmailValidator(
                              errorText: "Please correct email filled"),
                        ]),
                        decoration: InputDecoration(
                          labelText: "Podaj hasło",
                        )),
                  ),
                ]),
                // const SizedBox(height: 8),
                Row(children: [
                  Text(
                    "Powtórz hasło",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ]),
                // const SizedBox(height: 8),
                Row(children: [
                  Flexible(
                    child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Powtórz hasło",
                        )),
                  ),
                ]),
                // const SizedBox(height: 12),
                Center(
                  child: ElevatedButton(
                    child: Text("Zarejestruj się"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                ),
                Center(
                    child: Row(
                  children: [
                    Text("Masz już konto? Zaloguj się ",
                        style: Theme.of(context).textTheme.headline6),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text("tutaj"))
                  ],
                  mainAxisSize: MainAxisSize.min,
                ))
              ],
            ),
          ),
        ),
      );
}
