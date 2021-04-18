class ProductModel {
  String docid;
  String imageURL;
  String title;
  String desc;

  ProductModel({this.docid, this.imageURL, this.title, this.desc});

  toMap() {
    Map<String, dynamic> map = Map();

    map['docid'] = docid;
    map['imageURL'] = imageURL;
    map['title'] = title;
    map['desc'] = desc;

    return map;
  }
}
