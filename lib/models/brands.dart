import 'package:cloud_firestore/cloud_firestore.dart';

class Brands
{
  String? brandID;
  String? brandInfo;
  String? brandTitle;
  Timestamp? publishedDate;
  String? sellerUID;
  String? status;
  String? thumbnailUrl;

  Brands({
    this.brandID,
    this.brandInfo,
    this.brandTitle,
    this.publishedDate,
    this.sellerUID,
    this.status,
    this.thumbnailUrl,
  });

  Brands.fromJson(Map<String, dynamic> json)
  {
    brandID = json["brandID"];
    brandInfo = json["brandInfo"];
    brandTitle = json["brandTitle"];
    publishedDate = json["publishedDate"];
    sellerUID = json["sellerUID"];
    status = json["status"];
    thumbnailUrl = json["thumbnailUrl"];
  }
}