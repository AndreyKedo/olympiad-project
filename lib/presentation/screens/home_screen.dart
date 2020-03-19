import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getoutfitbrowser/domain/entity/search_params.dart';
import 'package:getoutfitbrowser/presentation/bloc/bloc.dart';
import 'package:getoutfitbrowser/presentation/pages/pages.dart';
import 'package:getoutfitbrowser/presentation/screens/screens.dart';
import 'package:getoutfitbrowser/presentation/screens/search_screen.dart';
import 'package:getoutfitbrowser/presentation/widgets/navigation_rail.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Author: Dashkevich Andrey
/// Data: 15.03.2020


class HomeScreen extends StatefulWidget {
  static const String main = '/';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool appBarVisible = false;

  @override
  void initState() {
    BlocProvider.of<GeneralBlocBloc>(context).add(InitEvent());
    super.initState();
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    BlocProvider.of<GeneralBlocBloc>(context).add(InitEvent());
    super.didUpdateWidget(oldWidget);
  }

  openSearch() async {
    final instance = await SharedPreferences.getInstance();
    final json =  instance.getString('prices');
    Navigator.pushNamed(context, SearchScreen.search, arguments: PriceRange.fromJson(json));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarVisible ? AppBar(
        title: Text('GetOutfit'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){
            openSearch();
          })
        ]
      ) : null,
      body: BlocConsumer<GeneralBlocBloc, GeneralBlocState>(
        listenWhen: (previous, current){
          return current is InitializationState || current is ExceptionState;
        },
        buildWhen: (previous, current){
          return current is InitializationState || current is ExceptionState;
        },
        listener: (context, state){
          if(state is ExceptionState){
            setState(() {
              appBarVisible = false;
            });
            return;
          }
          setState(() {
            appBarVisible = true;
          });
        },
        builder: (context, state){
          if(state is InitializationState){
            final category = state.category;
            final listChild = category.childs.take(3).toList();
            return NavigationRail.destinations(
                onTap: (id){
                  BlocProvider.of<GeneralBlocBloc>(context).add(GetCategories(id: listChild[id].id));
                },
                onChange: (BuildContext context, int index){
                  return BlocConsumer<GeneralBlocBloc, GeneralBlocState>(
                    key: ValueKey<int>(index),
                    listener: (context, state){
                      if(state is NextCategories){
                        final category = state.category;
                        Navigator.pushNamed(context, OffersScreen.offers, arguments: OffersScreenArgs(categoryName: category.name, idCategory: category.id));
                        BlocProvider.of<GeneralBlocBloc>(context).requestOffer = state.category.id;
                      }
                    },
                    listenWhen: (previous, current){
                      bool isEmpty = false;
                      if(current is NextCategories)
                        isEmpty = current.category.childs.isEmpty;
                      return current is NextCategories && isEmpty;
                    },

                    buildWhen: (previous, current){
                      bool isNotEmpty = true;
                      if(current is NextCategories){
                        isNotEmpty = current.category.childs.isNotEmpty;
                      }
                      return current is NextCategories && isNotEmpty;
                    },
                    builder: (context, state){
                      if(state is NextCategories){
                        final category  = state.category;
                        return CatalogPage(title: category.name, list: category.childs,);
                      }
                      return CircularProgressIndicator();
                    },
                  );
                },
                destinations: listChild.map<RailDestination>((item) => RailDestination(
                  icon: Icons.local_mall,
                  caption: item.name,)
                ).toList());
          }
          if(state is ExceptionState){
            return Center(
              child: ErrorPage(error: state.error, retryHandler: (){
                BlocProvider.of<GeneralBlocBloc>(context).add(InitEvent());
              }),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}