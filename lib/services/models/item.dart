class Item {
  String title;
  String fileKey;

  Item({this.title, this.fileKey});

  factory Item.fromMap(Map data) {
    return Item(
      title: data['title'] ?? '',
      fileKey: data['fileKey'] ?? '',
    );
  }
}
