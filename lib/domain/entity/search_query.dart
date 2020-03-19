import 'package:getoutfitbrowser/domain/entity/search_params.dart';

class SearchQuery{
  const SearchQuery(this.query, {this.option});
  final SearchParams option;
  final String query;
}