import 'package:flutter/material.dart';
import 'package:getoutfitbrowser/domain/entity/search_params.dart';

class SearchParamsNotification extends Notification{
  const SearchParamsNotification(this.params);
  final SearchParams params;
}

// ignore: must_be_immutable
class ModalSideSheet extends StatelessWidget {
  ModalSideSheet({Key key, @required this.title, @required this.prices}) : super(key: key);
  final String title;
  final PriceRange prices;
  RangeValues _range;
  bool sales = false;
  @override
  Widget build(BuildContext context) {
    _range = RangeValues(prices.above.toDouble(), prices.below.toDouble());
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 16),
                child: Text(title, style: TextStyle(
                    fontSize: 20
                ),),
              ),
              Text('Цена'),
              StatefulBuilder(builder: (context, setState){
                return  Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('От ${_range.start.toInt().toString()}'),
                        Text('До ${_range.end.toInt().toString()}'),
                      ],
                    ),
                    RangeSlider(
                        values: _range,
                        min: prices.above.toDouble(),
                        max: prices.below.toDouble(),
                        onChanged: (RangeValues value){
                          setState(() {
                            _range = value;
                          });
                          var params = SearchParams()
                            ..sales = sales
                            ..priceRange = PriceRange(above: _range.start.toInt(), below: _range.end.toInt());
                          SearchParamsNotification(params).dispatch(context);
                        }
                    )
                  ],
                );
              }),
              Row(
                children: <Widget>[
                  StatefulBuilder(
                    builder: (context, setState){
                      return Checkbox(value: sales, onChanged: (value){
                        setState((){
                          sales = value;
                        });
                      });
                    },
                  ), 
                  Text('Скидки')
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
