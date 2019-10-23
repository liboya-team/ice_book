import 'package:flutter/cupertino.dart';
import 'package:ice_book/ui/search/search_page.dart';

import 'ui/home/home_page.dart';
import 'ui/reader/reader_page.dart';
import 'ui/splash/splash_page.dart';

class Routes{
  static String splash = "/";
  static String login = "/login";
  static String home = "/home";
  static String search = "/search";
  static String reader = "/read";

  static Map getRouteMap(BuildContext context){
    var routeMap = {
      Routes.splash: (context) => SplashPage(),
      Routes.home: (context) => HomePage(),
      Routes.search: (context) => SearchPage(),
      Routes.reader: (context) => ReaderPage(),
    };
    return routeMap;
  }
}