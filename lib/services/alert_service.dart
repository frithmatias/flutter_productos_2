import 'package:flutter/material.dart';

class AlertService {

  static GlobalKey<ScaffoldMessengerState> messengerKey = new GlobalKey<ScaffoldMessengerState>();
  static showSnackbar( String message) {
    final snackBar = new SnackBar(  
      content: Text( message, style: TextStyle( color: Colors.white, fontSize: 16)),
    );
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
