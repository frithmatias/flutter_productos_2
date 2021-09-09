import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool state) {
    _isLoading = state;

    notifyListeners();
  }

  bool isValidForm() {
    print('Formulario es valido?: ${formKey.currentState?.validate()}');
    print('email: $email password: $password');

    return this.formKey.currentState?.validate() ?? false;
  }
}
