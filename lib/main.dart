import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:ice_book/routes.dart';

void main() async {
  await FlutterStatusbarcolor.setStatusBarColor(Color(0x00000000));
  FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
  runApp(MyApp());
  SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      builder: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeData>(
        builder: (context, theme) {
          return MaterialApp(
            title: '小冰阅读',
            theme: theme,
            initialRoute: Routes.splash,
            routes: Routes.getRouteMap(context),
          );
        },
      ),
    );
  }
}

enum ThemeEvent { toggle }

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  @override
  ThemeData get initialState => getDark();

  @override
  Stream<ThemeData> mapEventToState(ThemeEvent event) async* {
    switch (event) {
      case ThemeEvent.toggle:
        yield currentState == getDark() ? getLight() : getDark();
        break;
    }
  }
}

ThemeData getLight() {
  ThemeData themeData = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      selectedRowColor: Colors.black87);

  print(themeData);
  return themeData;
}

ThemeData getDark() {
  ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
  );
  print(dark);
  return dark;
}

