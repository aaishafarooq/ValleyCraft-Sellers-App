import 'package:flutter/material.dart';

import '../brandsScreens/home_screen.dart';


class StatusBanner extends StatelessWidget
{
  bool? status;
  String? orderStatus;

  StatusBanner({this.status, this.orderStatus,});



  @override
  Widget build(BuildContext context)
  {
    String? message;
    IconData? iconData;

    status! ? iconData = Icons.done : iconData = Icons.cancel;
    status! ? message = "Successful" : message = "UnSuccessful";

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors:
            [
              Colors.greenAccent,
              Colors.blueAccent,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )
      ),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          GestureDetector(
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),

          const SizedBox(width: 30,),

          Text(
            orderStatus == "ended"
                ? "Parcel Delivered $message"
                : orderStatus == "shifted"
                ? "Parcel Shifted $message"
                : orderStatus == "normal"
                ? "Order Placed $message"
                : "",
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),

          const SizedBox(width: 6,),

          CircleAvatar(
            radius: 10,
            backgroundColor: Colors.black,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),

        ],
      ),
    );
  }
}