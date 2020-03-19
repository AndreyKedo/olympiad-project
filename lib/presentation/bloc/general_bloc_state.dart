import 'package:getoutfitbrowser/domain/entity/category.dart';
import 'package:getoutfitbrowser/domain/error_status.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GeneralBlocState {}

class InitialGeneralBlocState extends GeneralBlocState {}

class ExceptionState extends GeneralBlocState{
  ExceptionState({this.error});
  final ErrorStatus error;
}

class InitializationState extends GeneralBlocState{
  InitializationState({this.category});
  final GeneralCategory category;
}

class NextCategories extends GeneralBlocState{
  NextCategories({this.category});
  final GeneralCategory category;
}