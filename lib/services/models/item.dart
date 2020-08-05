class Item {
  String title;
  String imageKey;
  String description;

  Item({this.title, this.imageKey, this.description});

  factory Item.fromMap(Map data) {
    return Item(
      title: data['title'] ?? '',
      imageKey: data['imageKey'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title ?? '',
      'imageKey': imageKey ?? '',
      'description': description ?? '',
    };
  }
}
