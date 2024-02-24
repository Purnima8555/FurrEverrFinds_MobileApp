import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';
import '../services/firebase_service.dart';

class CategoryRepository {
  CollectionReference<CategoryModel> categoryRef =
      FirebaseService.db.collection("categories").withConverter<CategoryModel>(
            fromFirestore: (snapshot, _) {
              return CategoryModel.fromFirebaseSnapshot(snapshot);
            },
            toFirestore: (model, _) => model.toJson(),
          );
  Future<List<QueryDocumentSnapshot<CategoryModel>>> getCategories() async {
    try {
      var data = await categoryRef.get();
      bool hasData = data.docs.isNotEmpty;
      if (!hasData) {
        makeCategory().forEach((element) async {
          await categoryRef.add(element);
        });
      }
      final response = await categoryRef.get();
      var category = response.docs;
      return category;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<CategoryModel>> getCategory(String categoryId) async {
    try {
      print(categoryId);
      final response = await categoryRef.doc(categoryId).get();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  List<CategoryModel> makeCategory() {
    return [
      CategoryModel(
          categoryName: "Food & Treats",
          status: "active",
          imageUrl:
              "https://i.pinimg.com/236x/73/0d/38/730d389a40fa866a49613505f2552d77.jpg"),
      CategoryModel(
          categoryName: "Toys & Accessories",
          status: "active",
          imageUrl:
              "https://i.pinimg.com/474x/f6/9d/7f/f69d7f73af796422a9b0af1f79f60d8e.jpg"),
      CategoryModel(
          categoryName: "Clothing",
          status: "active",
          imageUrl:
              "https://i.pinimg.com/564x/db/5a/cb/db5acb9ec4c41b0b17cd5753d9ce36d5.jpg"),
      CategoryModel(
          categoryName: "Grooming & Hygiene",
          status: "active",
          imageUrl:
          "https://i.pinimg.com/564x/ec/7c/e3/ec7ce3ec67389843a5c1fe642db2a951.jpg"),
    ];
  }
}
