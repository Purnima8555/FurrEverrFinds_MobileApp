import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../viewmodels/authorization_viewmodel.dart';
import '../../viewmodels/category_viewmodel.dart';
import '../../viewmodels/product_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AuthViewModel _authViewModel;
  late CategoryViewModel _categoryViewModel;
  late ProductViewModel _productViewModel;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _categoryViewModel = Provider.of<CategoryViewModel>(context, listen: false);
      _productViewModel = Provider.of<ProductViewModel>(context, listen: false);
      refresh();
    });
    super.initState();
  }

  Future<void> refresh() async {
    _categoryViewModel.getCategories();
    _productViewModel.getProducts();
    _authViewModel.getMyProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<CategoryViewModel, AuthViewModel, ProductViewModel>(
      builder: (context, categoryVM, authVM, productVM, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.brown,
            title: Text(
              "FurrEverrFinds",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.only(top: 0),
                  child: RefreshIndicator(
                    onRefresh: refresh,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Image.asset(
                                "assets/images/homepage_banner.jpg",
                                height: 270,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                              Container(
                                height: 270,
                                width: double.infinity,
                                color: Colors.black.withOpacity(0.3),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Paws and Play :",
                                      style: GoogleFonts.dancingScript(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "FurreverFinds the Way!",
                                      style: GoogleFonts.dancingScript(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          WelcomeText(authVM),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [...categoryVM.categories.map((e) => CategoryCard(e))],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Explore Products:",
                              style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: GridView.count(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.7,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              children: [
                                ...productVM.products.map((e) => ProductCard(e))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget WelcomeText(AuthViewModel authVM) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Welcome,",
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            authVM.loggedInUser != null ? authVM.loggedInUser!.name.toString() : "Guest",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget CategoryCard(CategoryModel e) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/single-category", arguments: e.id.toString());
      },
      child: Container(
        width: 390,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Card(
          elevation: 5,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  e.imageUrl.toString(),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.brown),
                    child: Text(
                      e.categoryName.toString() + "\n",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ProductCard(ProductModel e) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/single-product", arguments: e.id);
      },
      child: Container(
        width: 250,
        child: Card(
          elevation: 5,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  e.imageUrl.toString(),
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Image.asset(
                      'assets/images/logo.png',
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.8)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          e.productName.toString(),
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                        Text(
                          "Rs. " + e.productPrice.toString(),
                          style: TextStyle(fontSize: 15, color: Colors.brown),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
