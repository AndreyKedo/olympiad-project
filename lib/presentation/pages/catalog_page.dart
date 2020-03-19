import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getoutfitbrowser/domain/entity/category.dart';
import 'package:getoutfitbrowser/presentation/bloc/bloc.dart';

/// Author: Dashkevich Andrey
/// Data: 16.03.2020

class CatalogPage extends StatelessWidget {
  CatalogPage({Key key, @required this.title, @required this.list}) : assert(title != null && list != null), super(key: key);
  final List<Category> list;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(title, maxLines: 1, style: Theme.of(context).textTheme.headline,),
        ),
        Flexible(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index){
              return ListTile(
                title: Text(list[index].name),
                onTap: (){
                  BlocProvider.of<GeneralBlocBloc>(context).add(GetCategories(id: list[index].id));
                },
                trailing: Icon(Icons.arrow_forward),
              );
            },
          ),
        )
      ],
    );
  }
}

