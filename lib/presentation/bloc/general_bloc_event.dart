import 'package:meta/meta.dart';

@immutable
abstract class GeneralBlocEvent {}

class InitEvent extends GeneralBlocEvent {}

class GetCategories extends GeneralBlocEvent{
  GetCategories({this.id});
  final int id;
}

class ErrorEvent extends GeneralBlocEvent{
  ErrorEvent({this.error});
  final Object error;
}
