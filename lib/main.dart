import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:productcatalogue/src/Cart/viewModel/cartViewModel.dart';
import 'package:productcatalogue/src/Connectivity/viewModel/connectivityViewModel.dart';
import 'package:productcatalogue/src/My%20Orders/View%20Model/My%20Orders%20View%20Model.dart';
import 'package:productcatalogue/src/Selected%20Category/view/selectedCategoryView.dart';
import 'package:productcatalogue/src/Stripe%20Payment/viewModel/stripePaymentViewModel.dart';
import 'package:productcatalogue/src/hive/hive.dart';
import 'package:productcatalogue/src/home/view/homeScreenView.dart';
import 'package:productcatalogue/src/home/viewModel/homeViewModel.dart';
import 'package:productcatalogue/src/login/view/loginView.dart';
import 'package:productcatalogue/src/login/viewModel/loginViewModel.dart';
import 'package:productcatalogue/src/splashScreen/view/splashScreenView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var directory= await getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);
  Hive.registerAdapter(myOrdersAdapter());
  Stripe.publishableKey=stripePublishableKey;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.openBox('myOrdersBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>connectivityViewModel()),
        ChangeNotifierProvider(create: (_)=>loginViewModel()),
        ChangeNotifierProvider(create: (_)=>homeViewModel()),
        ChangeNotifierProvider(create: (_)=>cartViewModel()),
        ChangeNotifierProvider(create: (_)=>myOrdersViewModel()),

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
        },
      home: splashScreenView(),
    );
  }
}

