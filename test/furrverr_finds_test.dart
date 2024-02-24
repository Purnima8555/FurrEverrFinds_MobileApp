import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furreverr_finds/models/product_model.dart';
import 'package:furreverr_finds/repositories/product_repository.dart';
import 'package:furreverr_finds/services/firebase_service.dart';

void main() {
  FirebaseService.db = FakeFirebaseFirestore();
  ProductRepository repo = ProductRepository();

  // add products
  test(
    "add product",
        () async {
      var data = ProductModel(
        userId: "1",
        imageUrl: "",
        imagePath: "",
        id: "2",
        productName: "test product",
        categoryId: "3",
        productDescription: "test description",
        productPrice: 100,
      );

      final res = await repo.addProducts(product: data);
      expect(res, true);
      print("Test Successful");
    },
  );
}
