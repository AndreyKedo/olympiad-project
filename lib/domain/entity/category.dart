/// Author: Dashkevich Andrey
/// Data: 17.03.2020

class GeneralCategory{
  const GeneralCategory({this.id, this.name, this.childs});
  final int id;
  final String name;
  final List<Category> childs;
}

class Category{
  const Category(this.id, this.name);
  final int id;
  final String name;

  static Category fromJSON(Map<String, dynamic> json){
    return Category(json['id'], json['name']);
  }
}