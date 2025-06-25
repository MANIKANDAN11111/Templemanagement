class ArchanaItem {
  final String title;
  final String tamilTitle;
  final String imagePath;
  final double price;
  int quantity;
  bool isSelected;

  ArchanaItem(this.title, this.tamilTitle, this.imagePath, this.price,
      {this.quantity = 0, this.isSelected = false});
}