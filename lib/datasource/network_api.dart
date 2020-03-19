import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:getoutfitbrowser/domain/entity/category.dart';
import 'package:getoutfitbrowser/domain/entity/offer.dart';
import 'package:getoutfitbrowser/domain/entity/search_params.dart';
import 'package:getoutfitbrowser/domain/entity/search_query.dart';
import 'package:getoutfitbrowser/domain/error_status.dart';
import 'package:http/http.dart';

/// Author: Dashkevich Andrey
/// Data: 16.03.2020


//Исправляет кодировку
extension _BodyResponseFix on String{
  String fixCharset(){
    return utf8.decode(this.codeUnits);
  }
}

class GetOutfitApi{
  static final GetOutfitApi _instance = null;
  final String _url;

  GetOutfitApi._init(this._url);

  factory GetOutfitApi({@required String url}) => _instance ?? GetOutfitApi._init(url);

  ///Запрос категорий по [id].
  ///В случае если [id] не передан возвращается корневая категория в соответствие с API.
  Future<GeneralCategory> getCategories([int id]) async {
    try{

      final responseCategory = await get('$_url/categories?id=${id ?? 2}');
      if(responseCategory.statusCode == HttpStatus.ok){
        final List<dynamic> categoryResult = jsonDecode(responseCategory.body.fixCharset());
        final Map<String, dynamic> category = categoryResult.last;

        final response = await get('$_url/categories?parentId=${category['id']}');
        if(response.statusCode == HttpStatus.ok){
          List<dynamic> list = jsonDecode(response.body.fixCharset());
          List<Category> result = list.map<Category>((item) => Category.fromJSON(item)).toList();
          return GeneralCategory(id: category['id'], name: category['name'], childs: result);
        }
      }
      return Future<GeneralCategory>.error(ErrorStatus.UNKNOWN_EXCEPTION);
    } on SocketException catch(_){
      return Future<GeneralCategory>.error(ErrorStatus.NETWORK_NOT_AVAILABLE);
    } on TimeoutException catch(_){
      return Future<GeneralCategory>.error(ErrorStatus.SERVER_NOT_AVAILABLE);
    }
  }

  ///Запрос предложений по [id].
  ///Параметр является обязательным.
  Future<List<Offer>> getOffers(int id) async{
    try{
      final response = await get('$_url/offers?categoryId=$id');
      if(response.statusCode == HttpStatus.ok){
        List<dynamic> list = jsonDecode(response.body.fixCharset());
        List<Offer> result = list.map<Offer>((item) => Offer.fromJson(item)).toList();
        return result;
      }
      return Future<List<Offer>>.error(ErrorStatus.UNKNOWN_EXCEPTION);
    } on SocketException catch(_){
      return Future<List<Offer>>.error(ErrorStatus.NETWORK_NOT_AVAILABLE);
    } on TimeoutException catch(_){
      return Future<List<Offer>>.error(ErrorStatus.SERVER_NOT_AVAILABLE);
    }
  }

  ///Поиск товара в сооствествии с [options].
  ///[query] обязательный параметр запроса.
  ///Параметр является не обязательным.
  Future<List<Offer>> search(SearchQuery entity) async {
    try{
      final response = await get('$_url/offers?&name=${entity.query}&${ entity.query.isNotEmpty ? entity.option?.toString() : ''}');
      if(response.statusCode == HttpStatus.ok){
        List<dynamic> list = jsonDecode(response.body.fixCharset());
        List<Offer> result = list.map<Offer>((item) => Offer.fromJson(item)).toList();
        return result;
      }
      return Future<List<Offer>>.error(ErrorStatus.UNKNOWN_EXCEPTION);
    } on SocketException catch(_){
      return Future<List<Offer>>.error(ErrorStatus.NETWORK_NOT_AVAILABLE);
    } on TimeoutException catch(_){
      return Future<List<Offer>>.error(ErrorStatus.SERVER_NOT_AVAILABLE);
    }
  }

  ///Получает диапазон цен
  Future<PriceRange> getPriceRange() async {
    try{
      final response = await get('$_url/prices');
      if(response.statusCode == HttpStatus.ok){
        Map<String, dynamic> data = jsonDecode(response.body);
        return PriceRange.fromMap(data);
      }
      return Future<PriceRange>.error(ErrorStatus.UNKNOWN_EXCEPTION);
    } on SocketException catch(_){
      return Future<PriceRange>.error(ErrorStatus.NETWORK_NOT_AVAILABLE);
    } on TimeoutException catch(_){
      return Future<PriceRange>.error(ErrorStatus.SERVER_NOT_AVAILABLE);
    }
  }
}