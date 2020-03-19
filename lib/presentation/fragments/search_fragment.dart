import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getoutfitbrowser/domain/entity/offer.dart';
import 'package:getoutfitbrowser/presentation/bloc/bloc.dart';
import 'package:getoutfitbrowser/presentation/screens/picture_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';

/// Author: Dashkevich Andrey
/// Data: 17.03.2020

class SearchFragment extends StatefulWidget {
  SearchFragment({Key key}) : super(key: key);
  @override
  _SearchFragmentState createState() => _SearchFragmentState();
}

class _SearchFragmentState extends State<SearchFragment> {
  StreamSubscription _searchResultSubscription;
  final List<Offer> searchResult = [];

  @override
  void initState() {
    _searchResultSubscription = BlocProvider.of<GeneralBlocBloc>(context).searchResult.listen((data){
      setState(() {
        searchResult.clear();
        searchResult.addAll(data);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchResultSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      key: ValueKey<String>('search'),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: searchResult.isNotEmpty ? ListView.separated(
            itemCount: searchResult.length,
            itemBuilder: (context, index){
              return ListTile(
                leading: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, PictureScreen.picture, arguments: PictureScreenArgs(url: searchResult[index].pictures[0], name: searchResult[index].name));
                  },
                  child: Stack(
                    children: <Widget>[
                      Image.network(searchResult[index].pictures[0]),
                      Icon(Icons.zoom_in)
                    ],
                  ),
                ),
                title: Text(searchResult[index].name),
                subtitle: Text(searchResult[index].model),
                onTap: () async {
                  if(await canLaunch(searchResult[index].url))
                    await launch(searchResult[index].url,
                        forceWebView: true,
                        enableDomStorage: true,
                        enableJavaScript: true,
                        forceSafariVC: true
                    );
                },
              );
            },
            separatorBuilder: (context, index){
              return Divider(
                height: 4,
              );
            }
        ) : Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.local_mall),
              Text('Поиск', style: Theme.of(context).textTheme.headline,),
            ],
          ),
        ),
      ),
    );
  }
}
