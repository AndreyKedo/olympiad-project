import 'package:flutter/material.dart';
import 'package:getoutfitbrowser/presentation/screens/screens.dart';
import 'package:getoutfitbrowser/presentation/screens/search_screen.dart';

/// Author: Dashkevich Andrey
/// Data: 15.03.2020


///[RouteGenerator] инкапсулирует логику генерации маршрутов.
///[onGenerateRoute] статический метод для генерации маршрута на основе [RouteSettings].
class RouteGenerator{
  static Route<dynamic> onGenerateRoute(RouteSettings settings){
    switch(settings.name){
      case HomeScreen.main:
        return MaterialPageRoute(
          settings: settings,
          builder: (context){
            return HomeScreen();
          }
        );
      case OffersScreen.offers:
        return MaterialPageRoute(
          settings: settings,
          builder: (context){
            return OffersScreen();
          }
        );
      case PictureScreen.picture:
        return MaterialPageRoute(
          settings: settings,
          builder: (context){
            return PictureScreen();
          }
        );
      case SearchScreen.search:
        return MaterialPageRoute(
          settings: settings,
          builder: (context){
            return SearchScreen();
          }
        );
    }

    return MaterialPageRoute(
      settings: settings,
      builder: (context){
        return Container();
      }
    );
  }

}