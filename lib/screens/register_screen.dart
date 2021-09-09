import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/ui/inputs_decoration.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(SingleChildScrollView(
            child: Column(children: [
      SizedBox(height: 200),
      CardContainer(Column(children: [
        SizedBox(height: 10),
        Text('Crear Cuenta', style: Theme.of(context).textTheme.headline4),
        SizedBox(height: 10),
        ChangeNotifierProvider(
            create: (_) => LoginFormProvider(), child: _RegisterForm())
      ])),
      SizedBox(height: 50),
      TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'login');
          },
          style: ButtonStyle(
              overlayColor:
                  MaterialStateProperty.all(Colors.indigo.withOpacity(.1)),
              shape: MaterialStateProperty.all(StadiumBorder())),
          child: Text('Ya tienes una cuenta?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
    ]))));
  }
}

class _RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<LoginFormProvider>(context);

    return Container(
        child: Form(
            key: loginFormProvider.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(children: [

              // email

              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputsDecoration.authInputDecoration(
                    'john.doe@gmail.com', 'Correo Electrónico', Icons.email),
                onChanged: (value) => loginFormProvider.email = value,
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = new RegExp(pattern);
                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'Ingrese un email válido';
                },
              ),

              SizedBox(height: 10),

              // password

              TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: InputsDecoration.authInputDecoration(
                      '', 'Contraseña', Icons.password),
                  onChanged: (value) => loginFormProvider.password = value,
                  validator: (value) {
                    if (value != null && value.length >= 6) return null;
                    return 'El password debe contener al menos 6 caracteres';
                  }),

              SizedBox(height: 10),

              // login

              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.deepPurple,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                        loginFormProvider.isLoading ? 'Espere...' : 'Ingresar',
                        style: TextStyle(color: Colors.white))),
                onPressed: loginFormProvider.isLoading
                    ? null
                    : () async {
                        if (!loginFormProvider.isValidForm()) return;

                        loginFormProvider.isLoading = true;
                        FocusScope.of(context).unfocus();

                        final authService =
                            Provider.of<AuthService>(context, listen: false);

                        final String? errorMsg = await authService.createUser(
                            loginFormProvider.email,
                            loginFormProvider.password);

                        if (errorMsg == null) {
                          Navigator.pushReplacementNamed(context, 'home');
                        } else {
                          AlertService.showSnackbar(errorMsg);
                          print(errorMsg);
                        }
                        loginFormProvider.isLoading = false;
                      },
              )
            ])));
  }
}
