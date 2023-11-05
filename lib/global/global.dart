import 'package:sellers_app/assistantMethods/cart_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';



SharedPreferences? sharedPreferences;
CartMethods cartMethods = CartMethods();
String previousEarning = "";

String fcmServerToken ="key=AAAABN3vqc8:APA91bGybXGHZEhR8lmrIhUmv36B920v7Q1Zy7pb_f6nX_nQPodK7VVERmv-hTikOjMmB8Il_Ld_HyPWTeXBhqfR4g68pYhL-iJu2woMQdAKFrCrR7-UEuMExBaOCiD3mTTsiiL2SrHn";