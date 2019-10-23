import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';

class SplashPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashPageState();
  }

}

class _SplashPageState extends State<SplashPage>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Center(
          child: Icon(Icons.book),
        ),
    );
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), (){
      Navigator.pushReplacementNamed(context, Routes.home);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
