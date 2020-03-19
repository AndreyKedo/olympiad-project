import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:getoutfitbrowser/datasource/network_api.dart';
import 'package:getoutfitbrowser/domain/entity/offer.dart';
import 'package:getoutfitbrowser/domain/entity/search_query.dart';
import 'package:getoutfitbrowser/domain/error_status.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc.dart';

class GeneralBlocBloc extends Bloc<GeneralBlocEvent, GeneralBlocState> {
  GeneralBlocBloc({@required this.api});

  final BehaviorSubject<int> _subject = BehaviorSubject<int>();
  final BehaviorSubject<SearchQuery> _searchQuery = BehaviorSubject<SearchQuery>();

  final GetOutfitApi api;
  @override
  GeneralBlocState get initialState => InitialGeneralBlocState();

  set requestOffer(int id){
    _subject.add(id);
  }

  set searchQuery(SearchQuery query) => _searchQuery.add(query);
  
  Stream<List<Offer>> get searchResult => _searchQuery.debounceTime(Duration(milliseconds: 500)).asyncMap<List<Offer>>((SearchQuery query) async {
    final data = await api.search(query);
    return data;
  });

  Stream<List<Offer>> get offers => _subject.asyncMap<List<Offer>>((id) async {
    final data = await api.getOffers(id);
    return data;
  });


  @override
  Stream<GeneralBlocState> mapEventToState(
    GeneralBlocEvent event,
  ) async* {
    if(event is ErrorEvent){
      if(event.error is ErrorStatus){
        yield ExceptionState(error: event.error);
      }
      else{
        yield ExceptionState(error: ErrorStatus.UNKNOWN_EXCEPTION);
      }
    }
    if(event is InitEvent){
      final response = await api.getCategories();
      yield InitializationState(category: response);
      final subCategory = await api.getCategories(response.childs.first.id);
      yield NextCategories(category: subCategory);

      final prices = await api.getPriceRange();
      final instance = await SharedPreferences.getInstance();
      instance.setString('prices', prices.toJson());
    }

    if(event is GetCategories){
      final response = await api.getCategories(event.id);
      yield NextCategories(category: response);
    }
  }

  @override
  Future<void> close() async {
    await _searchQuery.close();
    await _subject.close();
    return super.close();
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    add(ErrorEvent(error: error));
    super.onError(error, stacktrace);
  }
}
