

import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

String stripePublishableKey="pk_test_51PiX2vEhzmTBkP6BV9DzK7dXm7qEJnlM3TkrgxyktkaVCTDX01OlZDuVvvtLWFyEhci6B33Ub8WvJ41xkD7nochc007rU1AIHA";
String stripeSecretKey="sk_test_51PiX2vEhzmTBkP6Bn7FQM30piMtEe3vqzO6J26u2wojUhonBD02aqi3Cuz7a7xQsTPNfsOzA1O3ZNyI0WTBPSLno005CZ9WLwQ";

class stripePaymentViewModel{

  stripePaymentViewModel._();

  static final stripePaymentViewModel paymentInstance=stripePaymentViewModel._();

  Future<void>makePayment()async {
    try{
      String? res=await createPaymentIntent(10, "usd");

    }catch(e){
      print("Error ${e}");
    }
  }


  Future createPaymentIntent(double amount,String currency)async{
    try{
      final Dio dio=Dio();
      Map<String,dynamic>data={
        "amount":(amount * 100).toInt().toString(),
        "currency":currency
      };
      var responce = await dio.post("https://api.stripe.com/v1/payment_intents",
          data: data,
          options: Options(contentType: Headers.formUrlEncodedContentType,headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded',
      },)
      );
      if(responce.data!=null){
        var r=responce.data["client_secret"];
        await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: r,
          merchantDisplayName: "Test"
        ));
        await Stripe.instance.presentPaymentSheet();
        return r;
      }
      else{
        return null;
      }


    }catch(e){
      print("Error ${e}");
    }
    return null;
  }


}