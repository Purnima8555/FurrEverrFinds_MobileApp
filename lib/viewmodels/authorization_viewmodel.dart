import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/favorite_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../repositories/authorization_repository.dart';
import '../repositories/favorite_repository.dart';
import '../repositories/product_repository.dart';
import '../screens/helper/authorization_helper.dart';
import '../services/firebase_service.dart';

class AuthViewModel with ChangeNotifier {
  int _a = 1;
  int get a => _a;

  addValue() {
    _a++;
  }

  User? _user = FirebaseService.firebaseAuth.currentUser;
  User? get user => _user;

  UserModel? _loggedInUser;
  UserModel? get loggedInUser => _loggedInUser;

  Future<UserCredential> login(String email, String password) async {
    try {
      // Sign in the user with email and password
      UserCredential userCredential = await FirebaseService.firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      // Get the UID of the logged-in user
      String uid = userCredential.user!.uid;

      // Retrieve the user data from Firestore using the UID
      UserModel loggedInUser = await AuthRepository().getUserDetail(uid, null);

      // Set the loggedInUser with retrieved user data
      _loggedInUser = loggedInUser;

      // Update _user with the current user
      _user = userCredential.user;

      // Notify listeners of the changes
      notifyListeners();

      // Return the user credential
      return userCredential;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await AuthRepository().resetPassword(email);
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> register(UserModel user) async {
    try {
      var response = await AuthRepository().register(user);
      _user = response!.user;
      _loggedInUser = UserModel(
        userId: _user?.uid,
        email: _user?.email ?? '',
        password: '',
      );
      notifyListeners();
    } catch (err) {
      AuthRepository().logout();
      rethrow;
    }
  }

  String? _token;
  String? get token => _token;
  Future<void> checkLogin(String? token) async {
    try {
      _loggedInUser = await AuthRepository().getUserDetail(_user!.uid, token);
      _token = token;
      notifyListeners();
    } catch (err) {
      _user = null;
      AuthRepository().logout();
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await AuthRepository().logout();
      _user = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  FavoriteRepository _favoriteRepository = FavoriteRepository();
  List<FavoriteModel> _favorites = [];
  List<FavoriteModel> get favorites => _favorites;

  List<ProductModel>? _favoriteProduct;
  List<ProductModel>? get favoriteProduct => _favoriteProduct;

  Future<void> getFavoritesUser() async {
    try {
      var response =
          await _favoriteRepository.getFavoritesUser(loggedInUser!.userId!);
      _favorites = [];
      for (var element in response) {
        _favorites.add(element.data());
      }
      _favoriteProduct = [];
      if (_favorites.isNotEmpty) {
        var productResponse = await ProductRepository()
            .getProductFromList(_favorites.map((e) => e.productId).toList());
        for (var element in productResponse) {
          _favoriteProduct!.add(element.data());
        }
      }

      notifyListeners();
    } catch (e) {
      print(e);
      _favorites = [];
      _favoriteProduct = null;
      notifyListeners();
    }
  }

  Future<void> favoriteAction(
      FavoriteModel? isFavorite, String productId) async {
    try {
      await _favoriteRepository.favorite(
          isFavorite, productId, loggedInUser!.userId!);
      await getFavoritesUser();
      notifyListeners();
    } catch (e) {
      _favorites = [];
      notifyListeners();
    }
  }

  List<ProductModel>? _myProduct;
  List<ProductModel>? get myProduct => _myProduct;

  Future<void> getMyProducts() async {
    try {
      var productResponse =
          await ProductRepository().getMyProducts(loggedInUser!.userId!);
      _myProduct = [];
      for (var element in productResponse) {
        _myProduct!.add(element.data());
      }
      notifyListeners();
    } catch (e) {
      print(e);
      _myProduct = null;
      notifyListeners();
    }
  }

  Future<void> addMyProduct(ProductModel product) async {
    try {
      await ProductRepository().addProducts(product: product);

      await getMyProducts();
      notifyListeners();
    } catch (e) {}
  }

  Future<void> editMyProduct(ProductModel product, String productId) async {
    try {
      await ProductRepository()
          .editProduct(product: product, productId: productId);
      await getMyProducts();
      notifyListeners();
    } catch (e) {}
  }

  Future<void> deleteMyProduct(String productId) async {
    try {
      await ProductRepository().removeProduct(productId, loggedInUser!.userId!);
      await getMyProducts();
      notifyListeners();
    } catch (e) {
      print(e);
      _myProduct = null;
      notifyListeners();
    }
  }
}
