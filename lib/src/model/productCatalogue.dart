import 'package:cloud_firestore/cloud_firestore.dart';
productCatalogue productCatalogueObject=productCatalogue();
class productCatalogue {

  final inst=FirebaseFirestore.instance.collection("Product Catalogue");

  late String name;
  late String description;
  late double price;

  productCatalogue({
    this.name = "",
    this.description = "",
    this.price = 0.0,
  });


  static fromDocument(DocumentSnapshot doc){
    Map<String,dynamic>data=doc.data() as Map<String,dynamic>;
    return productCatalogue(
      name: data["name"],
      price: data["price"],
      description: data["description"]
    );
  }

  Future<void> addProduct(String Cname,double pri,String desc,String id)async {
    inst.add({
      'name':Cname,
      'price':pri,
      'description':desc,
      'uid':id
    });
  }



}
