import 'package:flutter_test/flutter_test.dart';
import 'package:getoutfitbrowser/datasource/network_api.dart';
import 'package:getoutfitbrowser/domain/entity/search_params.dart';
import 'package:getoutfitbrowser/domain/entity/search_query.dart';
import 'package:getoutfitbrowser/domain/error_status.dart';

void main() {
  group('Api', (){
    final GetOutfitApi api = GetOutfitApi(url: 'http://server.getoutfit.ru');
    test('Get categories', () async{
      final response = await api.getCategories();
      expect(response is ErrorStatus, false);
    });
    test('Get offers', () async{
      final result = await api.getOffers(487);
      expect(result is ErrorStatus, false);
    });
    test('Search with options', () async{
      final option = SearchParams()
        ..sales = true
        ..priceRange = PriceRange(above: 100, below: 10000);
      final result = await api.search(SearchQuery('кросовки', option: option));
      expect(result is ErrorStatus, false);
    });
    test('Search without options', () async{
      final result = await api.search(SearchQuery('кросовки'));
      expect(result is ErrorStatus, false);
    });
    test('Prices', () async{
      final result = await api.getPriceRange();
      expect(result is ErrorStatus, false);
    });
  });
  group('Other', (){
    test('Search options', (){
      final option = SearchParams()
        ..sales = true
        ..priceRange = PriceRange(above: 100, below: 10000);
      expect(option.toString(), 'sales_notes=скидки&price_above=100&price_below=10000');
    });
  });
}
