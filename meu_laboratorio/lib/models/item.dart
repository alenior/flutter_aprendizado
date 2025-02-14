class Item {
  int? id;
  String name;
  String description;
  double value;
  int quantity;
  String imagePath;

  Item({
    this.id,
    required this.name,
    required this.description,
    required this.value,
    required this.quantity,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'value': value,
      'quantity': quantity,
      'imagePath': imagePath,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      value: map['value'],
      quantity: map['quantity'],
      imagePath: map['imagePath'],
    );
  }
}