import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../Tools/functions.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}
class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  bool passVisible = false;
  bool passRepVisible = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(titleOfApp),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_sharp),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.only(
                top: MediaQuery.of(context).size.height * 0.3,
                start: MediaQuery.of(context).size.width * 0.1,
                end: MediaQuery.of(context).size.width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(children: [
                  Flexible(
                    child: TextFormField(
                      autocorrect: false,
                      controller: currentPasswordController,
                      obscureText: !passVisible,
                      validator: PasswordMustContainValidator(validatePasswordError,currentPasswordController.text).call,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          labelText: 'Podaj obecne hasło',
                          errorMaxLines: 3,
                          prefixIcon: const Icon(Icons.lock),
                          suffix: InkWell(
                            onTap: () {
                              setState(() {
                                passVisible = !passVisible;
                              });
                            },
                            child: Icon(
                              passVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                          )),
                    ),
                  ),
                ]),
                const SizedBox(height: 20),
                Row(children: [
                  Flexible(
                    child: TextFormField(
                      autocorrect: false,
                      controller: newPasswordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: !passRepVisible,
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Pole nie może być puste'),
                        DifferentPasswordValidator(
                            'Hasła nie mogą być takie same', currentPasswordController.text),
                        PasswordMustContainValidator(validatePasswordError, newPasswordController.text)
                      ]).call,
                      decoration: InputDecoration(
                          labelText: 'Podaj nowe hasło',
                          prefixIcon: const Icon(Icons.lock),
                          errorMaxLines: 3,
                          suffix: InkWell(
                            onTap: () {
                              setState(() {
                                passRepVisible = !passRepVisible;
                              });
                            },
                            child: Icon(
                              passRepVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                          )),
                    ),
                  ),
                ]),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    child: Text('Zmień hasło'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        changeSthInMyAccount(
                            context,
                            apiURLChangePassword,
                            Map.of({
                              'current_password': currentPasswordController.text,
                              'new_password': newPasswordController.text
                            }));
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class PasswordMustContainValidator extends TextFieldValidator {
  PasswordMustContainValidator(super.errorText, this.password);
  final String password;

  RegExp passReg = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&_-])[A-Za-z\d@$!%*?&_-]{10,50}$');

  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String? value) {
    return passReg.hasMatch(value ?? '');
  }
}
class DifferentPasswordValidator extends TextFieldValidator {
  DifferentPasswordValidator(super.errorText, this.textToCompare);

  final String textToCompare;

  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String? value) {
    return value != textToCompare;
  }
}
