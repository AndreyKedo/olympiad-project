import 'package:flutter/material.dart';
import 'package:getoutfitbrowser/domain/error_status.dart';

/// Author: Dashkevich Andrey
/// Data: 16.03.2020

class ErrorPage extends StatelessWidget {
  ErrorPage({Key key, @required this.error, @required this.retryHandler}) : assert(error != null && retryHandler != null), super(key: key);
  final Function retryHandler;
  final ErrorStatus error;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(error == ErrorStatus.NETWORK_NOT_AVAILABLE
              ? 'Нет подключения к сети'
              : error == ErrorStatus.SERVER_NOT_AVAILABLE ? 'Сервер недоступен' : 'Попробуйте снова'
          , style: Theme.of(context).textTheme.headline,),
          FlatButton(onPressed: this.retryHandler, child: Text('Повторить'))
        ],
      ),
    );
  }
}
