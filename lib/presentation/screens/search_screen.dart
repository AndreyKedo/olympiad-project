import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getoutfitbrowser/domain/entity/search_params.dart';
import 'package:getoutfitbrowser/domain/entity/search_query.dart';
import 'package:getoutfitbrowser/presentation/bloc/bloc.dart';
import 'package:getoutfitbrowser/presentation/fragments/fragments.dart';
import 'package:getoutfitbrowser/presentation/widgets/modal_side_sheet.dart';

class SearchScreen extends StatefulWidget {
  static const String search = '/home/search';
  SearchScreen({Key key}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GlobalKey<ScaffoldState> _keyScaffold = GlobalKey();
  final TextEditingController _controller = TextEditingController();
  SearchParams params;
  PriceRange prices;

  @override
  void initState() {
    _controller.addListener(submit);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(submit);
    _controller.dispose();
    super.dispose();
  }

  void submit(){
    BlocProvider.of<GeneralBlocBloc>(context).searchQuery = SearchQuery(_controller.text, option: params);
  }

  @override
  Widget build(BuildContext context) {
    prices = ModalRoute.of(context).settings.arguments as PriceRange;
    return Scaffold(
      key: _keyScaffold,
      appBar: AppBar(
        title: TextField(
          controller: _controller,
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.filter_list), onPressed: (){
            _keyScaffold.currentState.openEndDrawer();
          })
        ],
      ),
      endDrawer: NotificationListener<SearchParamsNotification>(
        onNotification: (notification){
          params = notification.params;
          BlocProvider.of<GeneralBlocBloc>(context).searchQuery = SearchQuery(_controller.text, option: params);
          return true;
        },
        child: ModalSideSheet(
          title: 'Параметры поиска',
          prices: prices,
        ),
      ),
      body: SearchFragment(),
    );
  }
}
