
class homeScreenModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;
  final double? rating;
  final String category;

  homeScreenModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
    this.rating
  });

  factory homeScreenModel.fromJson(Map<String, dynamic> json) {
    return homeScreenModel(
        id: json['id'],
        title: json['title'],
        price: json['price'].toDouble(),
        description: json['description'],
        image: json['image'],
        rating: (json['rating']['rate'] as num).toDouble(),
        category: json['category']
    );
  }
}