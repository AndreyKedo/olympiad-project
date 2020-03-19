import 'dart:convert';

import 'package:flutter/foundation.dart';

/// Author: Dashkevich Andrey
/// Data: 18.03.2020


///[SearchParams] реализует простой каструктор параметров поиска для запроса.
///[sales] включать товары со скидкой.
///[priceRange] диапазон цены
class SearchParams{
  final StringBuffer _query = StringBuffer();

  set sales(bool value){
    if(value)
      _query.write('&sales_notes=скидки');
  }

  set priceRange(PriceRange range) => _query.write('&price_above=${range.above}&price_below=${range.below}');

  @override
  String toString() {
    if(_query.isEmpty)
      return '';
    return _query.toString().replaceRange(0, 1, '');
  }
}

///[PriceRange] диапазон цены для [SearchParams]
class PriceRange{
  const PriceRange({@required this.above, @required this.below});
  final int above;
  final int below;

  factory PriceRange.fromMap(Map<String, dynamic> json){
    return PriceRange(above: json['price_min'], below: json['price_max']);
  }

  factory PriceRange.fromJson(String json){
    final Map<String, dynamic> map = jsonDecode(json);
    return PriceRange(above: map['price_min'], below: map['price_max']);
  }

  String toJson() => jsonEncode({
    'price_min': above,
    'price_max': below
  });
}