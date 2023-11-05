import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../authScreens/auth_screen.dart';
import '../brandsScreens/home_screen.dart';


class MySplashScreen extends StatefulWidget {

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen>
{

  splashScreenTimer() {
    Timer(const Duration(seconds: 1), () async
    {
      // seller is already logged-in
      if (FirebaseAuth.instance.currentUser != null) {
       Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
      }
      else //seller is not already logged-in
          {

         Navigator.push(context, MaterialPageRoute(builder: (c) => AuthScreen()));
      }
    });
  }
    @override
    void initState() //called automatically when user comes here to this splash screen
    {
      super.initState();

      splashScreenTimer();
    }
    Widget build(BuildContext context) {
      return Material(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blueAccent,
                  Colors.blueGrey,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                      "images/r.jpg",

                  ),
                ),
                const SizedBox(height: 10.0,),

                const Text(
                  "Valley Craft",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 30,
                    letterSpacing: 3,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
