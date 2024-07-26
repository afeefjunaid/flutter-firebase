import 'package:flutter/material.dart';
import 'package:productcatalogue/src/Connectivity/viewModel/connectivityViewModel.dart';
import 'package:productcatalogue/src/Selected%20Category/view/selectedCategoryView.dart';
import 'package:productcatalogue/src/home/view/homeScreenView.dart';
import 'package:productcatalogue/src/home/viewModel/homeViewModel.dart';
import 'package:productcatalogue/src/login/view/loginView.dart';
import 'package:productcatalogue/src/login/viewModel/loginViewModel.dart';
import 'package:productcatalogue/src/product/Model/productModel.dart';
import 'package:productcatalogue/src/productDetail/view/productDetailView.dart';
import 'package:productcatalogue/src/splashScreen/view/splashScreenView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>connectivityViewModel()),
        ChangeNotifierProvider(create: (_)=>loginViewModel()),
        ChangeNotifierProvider(create: (_)=>homeViewModel()),
      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/loginView': (context) => loginView(),
          '/homeScreenView': (context) => homeScreenView(),
          '/selectedCategoryView': (context) => selectedCategoryView(),
          //'/productDetailsView': (context)=>productDetailView(),
        },
      home:  Scaffold(
        body:  splashScreenView(),
      )
    );
  }
}

