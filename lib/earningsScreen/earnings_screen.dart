import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';
import '../splashScreen/my_splash_screen.dart';


class EarningsScreen extends StatefulWidget
{
  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}



class _EarningsScreenState extends State<EarningsScreen>
{
  String totalSellerEarnings = "";

  readTotalEarnings() async
  {
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap)
    {
      setState(() {
        totalSellerEarnings = snap.data()!["earnings"].toString();
      });
    });
  }

  @override
  void initState()
  {
    super.initState();

    readTotalEarnings();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                "₹ " + totalSellerEarnings,
                style: const TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                "Total Earnings",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.white,
                  thickness: 1.5,
                ),
              ),

              const SizedBox(height: 40.0,),

              Card(
                color: Colors.white54,
                margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 140),
                child: ListTile(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>  MySplashScreen()));
                  },
                  leading: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Go Back",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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