import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getoutfitbrowser/domain/entity/offer.dart';
import 'package:getoutfitbrowser/presentation/bloc/bloc.dart';
import 'package:getoutfitbrowser/presentation/screens/screens.dart';
import 'package:url_launcher/url_launcher.dart';

/// Author: Dashkevich Andrey
/// Data: 16.03.2020

class OffersScreenArgs {
  const OffersScreenArgs({@required this.categoryName, @required this.idCategory});
  final String categoryName;
  final int idCategory;
}

class OffersScreen extends StatefulWidget {
  OffersScreen({Key key}) : super(key: key);
  static const String offers = '/home/offers';

  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final PageController _controller = PageController();
  final PageController _controllerPic = PageController();
  StreamSubscription<List<Offer>> _subscription;
  final List<Offer> list = [];
  bool loading = true;

  @override
  void initState() {
    _subscription = BlocProvider.of<GeneralBlocBloc>(context).offers.listen((offers){
      setState(() {
        list.addAll(offers);
        loading = false;
      },);
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _controllerPic.dispose();
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _buildOfferParams(Map<String, String> params){
    return params.entries.map<Widget>((MapEntry<String, String> entry) => Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(entry.key),
          Text(entry.value)
        ],
      ),
    )).toList();
  }

  Widget _buildOfferDetail(List<Offer> dataOffers, int index){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10,
              horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AutoSizeText(
                '${dataOffers[index].name}', style: Theme
                  .of(context)
                  .textTheme
                  .headline, maxLines: 1,),
              Text(
                'Модель: ${dataOffers[index].model}', style: Theme
                  .of(context)
                  .textTheme
                  .caption,)
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.grey[200],
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: PageView.builder(
                    controller: _controllerPic,
                    itemCount: dataOffers[index].pictures.length,
                    itemBuilder: (context, indexPic) {
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){
                          Navigator.pushNamed(context, PictureScreen.picture, arguments: PictureScreenArgs(url: dataOffers[index].pictures[indexPic], name: dataOffers[index].name));
                        },
                        child: Stack(
                          fit: StackFit.passthrough,
                          children: <Widget>[
                            Image.network(dataOffers[index].pictures[indexPic]),
                            Icon(Icons.zoom_in, size: 50, color: Colors.grey,)
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  child: RawMaterialButton(
                    onPressed: () {
                      final page = _controllerPic.page.toInt() != 0 ? _controllerPic.page.toInt() - 1 : _controllerPic.page.toInt();
                      _controllerPic.animateToPage(page, duration: Duration(
                          milliseconds: 300
                      ), curve: Curves.easeInOutCirc);
                    },
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(child: Icon(Icons.arrow_back_ios))
                        ],
                      ),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Align(
                  child: RawMaterialButton(
                    onPressed: () {
                      final page = _controllerPic.page.toInt() != dataOffers.length ? _controllerPic.page.toInt() + 1 : _controllerPic.page.toInt();
                      _controllerPic.animateToPage(page, duration: Duration(
                          milliseconds: 300
                      ), curve: Curves.easeInOutCirc);
                    },
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(child: Icon(Icons.arrow_forward_ios))
                        ],
                      ),
                    ),
                  ),
                  alignment: Alignment.centerRight,
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: 10,
                  children: <Widget>[
                    Text('Цена: ${dataOffers[index].price} ${dataOffers[index].currency}', style: Theme.of(context).textTheme.body2,),
                    Text('О товаре', style: Theme.of(context).textTheme.title,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: AutoSizeText('${dataOffers[index].description}', wrapWords: true, softWrap: true,),
                    ),
                  ],
                ),
              ),
              Column(
                children: _buildOfferParams(dataOffers[index].params),
              )
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: RawMaterialButton(onPressed: (){
                launchLink(dataOffers[index].url);
              }, child: Text('Купить', style: Theme.of(context).textTheme.headline,)),
            )
          ],
        )
      ],
    );
  }

  Future launchLink(String url) async {
    if(await canLaunch(url)){
      launch(url, forceWebView: true, forceSafariVC: true, enableJavaScript: true, enableDomStorage: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final OffersScreenArgs categoryOffers = ModalRoute.of(context).settings.arguments as OffersScreenArgs;
    return Scaffold(
      appBar: AppBar(
        title: Text('${categoryOffers.categoryName} (${list.length})'),
      ),
      body: BlocBuilder<GeneralBlocBloc, GeneralBlocState>(
        builder: (context, state){
          return Container(
            width: MediaQuery.of(context).size.width,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              switchInCurve: Curves.elasticIn,
              switchOutCurve: Curves.elasticOut,
              transitionBuilder: (widget, animation){
                return ScaleTransition(
                  scale: animation,
                  child: widget,
                );
              },
              child: loading ? Center(
                child: CircularProgressIndicator(),
              ) : list.isEmpty ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Товара нет в наличие')
                ],
              ) :  PageView.builder(
                controller: _controller,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return _buildOfferDetail(list, index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
