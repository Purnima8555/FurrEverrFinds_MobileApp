import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:furreverr_finds/screens/authorization/forgetpassword_screen.dart';
import 'package:furreverr_finds/screens/authorization/login_screen.dart';
import 'package:furreverr_finds/screens/authorization/register_screen.dart';
import 'package:furreverr_finds/screens/category/categoryview_screen.dart';
import 'package:furreverr_finds/screens/dashboard/dashboard.dart';
import 'package:furreverr_finds/screens/product/addproduct_screen.dart';
import 'package:furreverr_finds/screens/product/editproduct_screen.dart';
import 'package:furreverr_finds/screens/product/myproductlist_screen.dart';
import 'package:furreverr_finds/screens/product/productview_screen.dart';
import 'package:furreverr_finds/screens/splash_screen.dart';

import 'package:furreverr_finds/services/notification_service.dart';
import 'package:furreverr_finds/viewmodels/authorization_viewmodel.dart';
import 'package:furreverr_finds/viewmodels/category_viewmodel.dart';
import 'package:furreverr_finds/viewmodels/global_ui_viewmodel.dart';
import 'package:furreverr_finds/viewmodels/product_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_kit/overlay_kit.dart';

import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalUIViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
      ],
      child: OverlayKit(
        child: Consumer<GlobalUIViewModel>(builder: (context, loader, child) {
          if (loader.isLoading) {
            OverlayLoadingProgress.start();
          } else {
            OverlayLoadingProgress.stop();
          }
          return MaterialApp(
            title: 'FurrEverrFinds',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: "Poppins",
              primarySwatch: Colors.brown,
              textTheme: GoogleFonts.aBeeZeeTextTheme(),
            ),
            initialRoute: "/splash",
            routes: {
              "/login": (BuildContext context) => LoginScreen(),
              "/splash": (BuildContext context) => SplashScreen(),
              "/register": (BuildContext context) => RegisterScreen(),
              "/forget-password": (BuildContext context) =>
                  ForgetPasswordScreen(),
              "/dashboard": (BuildContext context) => DashboardScreen(),
              "/add-product": (BuildContext context) => AddProductScreen(),
              "/edit-product": (BuildContext context) => EditProductScreen(),
              "/single-product": (BuildContext context) =>
                  SingleProductScreen(),
              "/single-category": (BuildContext context) =>
                  SingleCategoryScreen(),
              "/my-products": (BuildContext context) => MyProductScreen(),
            },
          );
        }),
      ),
    );
  }
}

