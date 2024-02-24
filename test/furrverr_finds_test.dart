import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furreverr_finds/counter_class.dart';
import 'package:furreverr_finds/models/product_model.dart';
import 'package:furreverr_finds/repositories/product_repository.dart';
import 'package:furreverr_finds/services/firebase_service.dart';

void main() {
  FirebaseService.db = FakeFirebaseFirestore();
  ProductRepository repo = ProductRepository();

  // given when then
  test(
    "value increase",
        () {
      CounterClass ins = CounterClass();
      int initialValue = ins.a;

      ins.addValue();
      expect(ins.a, initialValue + 1);
      print("Test Successful");
    },
  );

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
