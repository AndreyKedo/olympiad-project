/// Author: Dashkevich Andrey
/// Data: 17.03.2020

class Offer{
  const Offer({this.name, this.description, this.url, this.price, this.pictures, this.model, this.params, this.currency});
  final String name;
  final String description;
  final String url;
  final int price;
  final List<String> pictures;
  final String model;
  final String currency;
  final Map<String, String> params;

  static Offer fromJson(Map<String, dynamic> json){
    final List<dynamic> pictures = json['pictures'];
    final List<dynamic> params = json['params'];
    return Offer(
        name: json['name'],
        description: json['description'],
        url: json['url'],
        price: json['price'],
        pictures: pictures.map<String>((item) => item as String).toList(),
        model: json['model'],
        params: Map.fromEntries(params.map<MapEntry<String,String>>((item) => MapEntry(item['name'], item['value']))),
        currency: json['currencyId']
    );
  }
}