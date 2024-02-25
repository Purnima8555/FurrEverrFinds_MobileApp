import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../viewmodels/authorization_viewmodel.dart';
import '../../viewmodels/category_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productPriceController = TextEditingController();
  TextEditingController _productDescriptionController = TextEditingController();
  TextEditingController _imageUrlController = TextEditingController();

  String productCategory = "";

  void saveProduct() async {
    _ui.loadState(true);
    try {
      final ProductModel data = ProductModel(

        imageUrl: _imageUrlController.text,
        categoryId: selectedCategory,
        productDescription: _productDescriptionController.text,
        productName: _productNameController.text,
        productPrice: num.parse(_productPriceController.text.toString()),
        userId: _authViewModel.loggedInUser!.userId,
      );
      await _authViewModel.addMyProduct(data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Success")));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error")));
    }
    _ui.loadState(false);
  }

  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  late CategoryViewModel _categoryViewModel;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _categoryViewModel = Provider.of<CategoryViewModel>(context, listen: false);
      getInit();
    });
    super.initState();
  }

  getInit() async {
    _ui.loadState(true);
    try {
      await _categoryViewModel.getCategories();
    } catch (e) {
      print(e);
    }
    _ui.loadState(false);
  }

  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text("Add product:"),
      ),
      body: Consumer<CategoryViewModel>(
        builder: (context, categoryVM, child) {
          return SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: _productNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        border: InputBorder.none,
                        labelText: "Product Name",
                        hintText: 'Enter product name',
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: _productPriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        border: InputBorder.none,
                        labelText: "Product Price",
                        hintText: 'Enter product price',
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: _productDescriptionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        border: InputBorder.none,
                        labelText: "Description",
                        hintText: 'Enter product description',
                      ),
                    ),
                    SizedBox(height: 15,),
                    Text("Select Product Category: ", textAlign: TextAlign.start,),
                    SizedBox(height: 5,),
                    DropdownButtonFormField(
                      borderRadius: BorderRadius.circular(10),
                      isExpanded: true,
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                      ),
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      items: categoryVM.categories.map((pt) {
                        return DropdownMenuItem(
                          value: pt.id.toString(),
                          child: Text(
                            pt.categoryName.toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          selectedCategory = newVal.toString();
                        });
                      },
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: _imageUrlController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        border: InputBorder.none,
                        labelText: "Image URL",
                        hintText: 'Enter image URL',
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        key: Key('addProduct'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.brown),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.brown),
                            ),
                          ),
                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 10)),
                        ),
                        onPressed: () {
                          saveProduct();
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.brown),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.brown),
                            ),
                          ),
                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 10)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Back",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
