import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers_app/brandsScreens/home_screen.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/splashScreen/my_splash_screen.dart';
import 'package:sellers_app/widgets/progress_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;


class UploadBrandsScreen extends StatefulWidget
{
  @override
  State<UploadBrandsScreen> createState() => _UploadBrandsScreenState();
}




class _UploadBrandsScreenState extends State<UploadBrandsScreen>
{
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();

  TextEditingController brandInfoTextEditingController = TextEditingController();
  TextEditingController brandTitleTextEditingController = TextEditingController();

  bool uploading = false;
  String downloadUrlImage = "";
  String brandUniqueId = DateTime.now().millisecondsSinceEpoch.toString();


  saveBrandInfo()
  {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("brands")
        .doc(brandUniqueId)
        .set(
        {
          "brandID": brandUniqueId,
          "sellerUID": sharedPreferences!.getString("uid"),
          "brandInfo": brandInfoTextEditingController.text.trim(),
          "brandTitle": brandTitleTextEditingController.text.trim(),
          "publishedDate": DateTime.now(),
          "status": "available",
          "thumbnailUrl": downloadUrlImage,
        });

    setState(() {
      uploading = false;
      brandUniqueId = DateTime.now().millisecondsSinceEpoch.toString();
    });

    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
  }

  validateUploadForm() async
  {
    if(imgXFile != null)
    {
      if(brandInfoTextEditingController.text.isNotEmpty
          && brandTitleTextEditingController.text.isNotEmpty)
      {
        setState(() {
          uploading = true;
        });

        //1. upload image to storage - get downloadUrl
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
            .ref()
            .child("sellersBrandsImages").child(fileName);

        fStorage.UploadTask uploadImageTask = storageRef.putFile(File(imgXFile!.path));

        fStorage.TaskSnapshot taskSnapshot = await uploadImageTask.whenComplete(() {});

        await taskSnapshot.ref.getDownloadURL().then((urlImage)
        {
          downloadUrlImage = urlImage;
        });

        //2. save brand info to firestore database
        saveBrandInfo();
      }
      else
      {
        Fluttertoast.showToast(msg: "Please write brand info and brand title.");
      }
    }
    else
    {
      Fluttertoast.showToast(msg: "Please choose image.");
    }
  }

  uploadFormScreen()
  {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
          onPressed: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              onPressed: ()
              {
                //validate upload form
                uploading == true ? null : validateUploadForm();
              },
              icon: const Icon(
                Icons.cloud_upload,
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
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
        ),
        title: const Text(
            "Upload New Brand",
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [

          uploading == true
              ? linearProgressBar()
              : Container(),

          //image
          SizedBox(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                        File(
                          imgXFile!.path,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const Divider(
            color: Colors.blueAccent,
            thickness: 1,
          ),

          //brand info
          ListTile(
            leading: const Icon(
              Icons.perm_device_information,
              color: Colors.deepPurple,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                controller: brandInfoTextEditingController,
                decoration: const InputDecoration(
                  hintText: "brand info",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.blueAccent,
            thickness: 1,
          ),

          //brand title
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.deepPurple,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                controller: brandTitleTextEditingController,
                decoration: const InputDecoration(
                  hintText: "brand title",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.blueAccent,
            thickness: 1,
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return imgXFile == null ? defaultScreen() : uploadFormScreen();
  }

  defaultScreen()
  {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
        ),
        title: const Text(
            "Add New Brand",
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),

        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors:
              [
                Colors.blueAccent,
                Colors.black54,
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

              const Icon(
                Icons.add_photo_alternate_outlined,
                color: Colors.white,
                size: 200,
              ),

              ElevatedButton(
                  onPressed: ()
                  {
                    obtainImageDialogBox();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Add New Brand",
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }

  obtainImageDialogBox()
  {
    return showDialog(
        context: context,
        builder: (context)
        {
          return SimpleDialog(
            title: const Text(
              "Brand Image",
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: ()
                {
                  captureImagewithPhoneCamera();
                },
                child: const Text(
                  "Capture image with Camera",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: ()
                {
                  getImageFromGallery();
                },
                child: const Text(
                  "Select image from Gallery",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: ()
                {

                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        }
    );
  }

  getImageFromGallery() async
  {
    Navigator.pop(context);

    imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imgXFile;
    });
  }

  captureImagewithPhoneCamera() async
  {
    Navigator.pop(context);

    imgXFile = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imgXFile;
    });
  }
}