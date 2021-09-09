import 'package:flutter/material.dart';
import 'package:productos_app/screens/check_auth_screen.dart';
import 'package:productos_app/screens/home_screen.dart';
import 'package:productos_app/screens/login_screen.dart';
import 'package:productos_app/screens/product_screen.dart';
import 'package:productos_app/screens/register_screen.dart';
import 'package:productos_app/services/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ProductsService()),
      ChangeNotifierProvider(create: (_) => AuthService())
    ], child: MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'checkauth',
        routes: {
          'login': (_) => LoginScreen(),
          'register': (_) => RegisterScreen(),
          'home': (_) => HomeScreen(),
          'product': (_) => ProductScreen(),
          'checkauth': (_) => CheckAuthScreen(),
        },
        scaffoldMessengerKey: AlertService.messengerKey,
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.grey.shade300,
            appBarTheme: AppBarTheme(
              elevation: 0,
              color: Colors.indigo,
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              elevation: 0,
              backgroundColor: Colors.indigo,
            )));
  }
}
