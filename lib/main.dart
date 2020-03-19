import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getoutfitbrowser/datasource/network_api.dart';
import 'package:getoutfitbrowser/presentation/bloc/general_bloc_bloc.dart';
import 'package:getoutfitbrowser/presentation/route_generator.dart';
import 'package:getoutfitbrowser/presentation/screens/home_screen.dart';
/// Author: Dashkevich Andrey
/// Data: 15.03.2020
/// Прототип мобильного приложения интернет-магазина

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    return MaterialApp(
      title: 'Catalog',
      theme: ThemeData(
        primaryColor: Colors.white
      ),
      initialRoute: HomeScreen.main,
      onGenerateRoute: RouteGenerator.onGenerateRoute,
      builder: (context, widget){
        return BlocProvider(
          create: (context) => GeneralBlocBloc(api: GetOutfitApi(url: 'http://server.getoutfit.ru')),
          child: widget,
        );
      },
    );
  }
}