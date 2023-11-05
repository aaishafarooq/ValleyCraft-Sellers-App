import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';




import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import '../global/global.dart';
import '../splashScreen/my_splash_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_dialog.dart';



class RegistrationTabPage extends StatefulWidget
{
  @override
  State<RegistrationTabPage> createState() => _RegistrationTabPageState();
}



class _RegistrationTabPageState extends State<RegistrationTabPage>
{
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String downloadUrlImage ="";

  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();




  getImageFromGallery() async
  {
    imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imgXFile;
    });
  }

  formValidation() async
  {
    if(imgXFile == null) //image is not selected
        {
      Fluttertoast.showToast(msg: "Please select an image.");
    }
    else //image is already selected
        {
      //password is equal to confirm password
      if(passwordTextEditingController.text == confirmPasswordTextEditingController.text)
      {
        //check email, pass, confirm password & name text fields
        if(nameTextEditingController.text.isNotEmpty
            && emailTextEditingController.text.isNotEmpty
            && passwordTextEditingController.text.isNotEmpty
            && confirmPasswordTextEditingController.text.isNotEmpty
        && phoneTextEditingController.text.isNotEmpty
        && locationTextEditingController.text.isNotEmpty)
        {
        showDialog(
            context: context,
            builder: (c)
        {
          return
            LoadingDialogWidget(
              message: "Registering your account",
            );
        }
        );
          //1.upload image to storage

          String finalName = DateTime.now().millisecondsSinceEpoch.toString();
          fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
              .ref()
              .child("sellersImages").child(finalName);


          fStorage.UploadTask uploadImageTask = storageRef.putFile(File(imgXFile!.path));


          fStorage.TaskSnapshot taskSnapshot = await uploadImageTask.whenComplete(() {});

        await  taskSnapshot.ref.getDownloadURL().then((urlImage)
          {
            downloadUrlImage =urlImage;
          });

          //2. save the user info to firestore database

          saveInformationToDatabase();
        }
        else
        {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Please complete the form. Do not leave any text field empty.");
        }
      }
      else //password is NOT equal to confirm password
          {
        Fluttertoast.showToast(msg: "Password and Confirm Password do not match.");
      }
    }
  }
  saveInformationToDatabase() async
  {
    //authenticate the user first
    User ? currentUser;

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
    ).then((auth)
    {
      currentUser = auth.user;
    }).catchError((errorMessage)
    {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occurred: \n $errorMessage");
    });
    if(currentUser!= null)
      {
        //save info  to database and save locally
        saveInfoToFirestoreAndLocally(currentUser!);
      }
  }
saveInfoToFirestoreAndLocally(User currentUser) async
{
  
  //save to firestore
  FirebaseFirestore
      .instance.collection("sellers")
      .doc(currentUser.uid)
      .set(
      {
        "uid": currentUser.uid,
        "email": currentUser.email,
        "name": nameTextEditingController.text.trim(),
        "photoUrl" : downloadUrlImage,
        "phone": phoneTextEditingController.text.trim(),
        "address":locationTextEditingController.text.trim(),
        "status": "approved",
        "earnings": 0.0,
      });
  
  //save locally
 sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences !.setString("uid", currentUser.uid);
  await sharedPreferences !.setString("email", currentUser.email!);
  await sharedPreferences !.setString("name", nameTextEditingController.text.trim(),);
  await sharedPreferences !.setString("photoUrl", downloadUrlImage);



  Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));
}




  @override
  Widget build(BuildContext context)
  {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [

            const SizedBox(height: 12,),

            //get-capture image
            GestureDetector(
              onTap: ()
              {
                getImageFromGallery();
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundColor: Colors.white,
                backgroundImage: imgXFile == null
                    ? null
                    : FileImage(
                    File(imgXFile!.path)
                ),
                child: imgXFile == null
                    ? Icon(
                  Icons.add_photo_alternate,
                  color: Colors.grey,
                  size: MediaQuery.of(context).size.width * 0.20,
                ) : null,
              ),
            ),

            const SizedBox(height: 12,),

            //inputs form fields
            Form(
              key: formKey,
              child: Column(
                children: [

                  //name
                  CustomTextField(
                    textEditingController: nameTextEditingController,
                    iconData: Icons.person,
                    hintText: "Name",
                    isObsecre: false,
                    enabled: true,
                  ),

                  //email
                  CustomTextField(
                    textEditingController: emailTextEditingController,
                    iconData: Icons.email,
                    hintText: "Email",
                    isObsecre: false,
                    enabled: true,
                  ),

                  //pass
                  CustomTextField(
                    textEditingController: passwordTextEditingController,
                    iconData: Icons.lock,
                    hintText: "Password",
                    isObsecre: true,
                    enabled: true,
                  ),

                  //confirm pass
                  CustomTextField(
                    textEditingController: confirmPasswordTextEditingController,
                    iconData: Icons.lock,
                    hintText: "Confirm Password",
                    isObsecre: true,
                    enabled: true,
                  ),
                  //phone
                  CustomTextField(
                    textEditingController: phoneTextEditingController,
                    iconData: Icons.lock,
                    hintText: "Phone",
                    isObsecre: false,
                    enabled: true,
                  ),
                  //location
                  CustomTextField(
                    textEditingController: locationTextEditingController,
                    iconData: Icons.lock,
                    hintText: "Address",
                    isObsecre: false,
                    enabled: true,
                  ),

                  const SizedBox(height: 20,),

                ],
              ),
            ),

            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                onPressed: ()
                {
                  formValidation();
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
            ),

            const SizedBox(height: 30,),

          ],
        ),
      ),
    );
  }
}