import 'dart:convert';

class Product {
  Product(
      {required this.available,
      this.picture,
      required this.name,
      required this.description,
      required this.price,
      this.id});

  bool available;
  String? picture;
  String name;
  String description;
  double price;
  String? id;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        available: json["available"],
        picture: json["picture"],
        name: json["name"],
        description: json["description"],
        price: json["price"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "available": available,
        "picture": picture,
        "name": name,
        "description": description,
        "price": price,
      };

  Product copy() => Product(
        available: this.available,
        picture: this.picture,
        name: this.name,
        description: this.description,
        price: this.price,
        id: this.id,
      );
}
