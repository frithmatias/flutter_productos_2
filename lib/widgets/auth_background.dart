import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground(this.child);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(children: [_PurpleBox(), _LoginIcon(), this.child]));
  }
}

class _LoginIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 30),
          child: Icon(Icons.person_pin, color: Colors.white, size: 100)),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        width: double.infinity,
        height: size.height * .4,
        decoration: _purpleBoxBackground(),
        child: Stack(children: [
          Positioned(child: _Bubble(), top: 90, left: 50),
          Positioned(child: _Bubble(), top: -40, left: -30),
          Positioned(child: _Bubble(), top: 150, left: -20),
          Positioned(child: _Bubble(), bottom: -30, right: 10),
          Positioned(child: _Bubble(), bottom: 50, right: 30),
          Positioned(child: _Bubble(), bottom: 120, right: 50),
        ]));
  }

  BoxDecoration _purpleBoxBackground() => BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1),
      ]));
}

class _Bubble extends StatelessWidget {
  const _Bubble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );
  }
}
