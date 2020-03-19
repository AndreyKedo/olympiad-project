import 'package:flutter/material.dart';

/// Author: Dashkevich Andrey
/// Data: 16.03.2020

class PictureScreen extends StatelessWidget {
  static const String picture = '/home/offer/picture';
  @override
  Widget build(BuildContext context) {
    final PictureScreenArgs args = ModalRoute.of(context).settings.arguments;
    return Hero(tag: args.name, child: Material(
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Image.network(args.url,),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(icon: Icon(Icons.close), onPressed: (){
                Navigator.pop(context);
              }),
            )
          ],
        ),
      ),
    ));
  }
}

class PictureScreenArgs{
  const PictureScreenArgs({this.url, this.name});
  final String url;
  final String name;
}
