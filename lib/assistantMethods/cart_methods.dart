import '../global/global.dart';


class CartMethods
{
  //2367121:5 ==> 2367121
  separateItemIDsFromUserCartList()
  {
    //2367121:5
    List<String>? userCartList = sharedPreferences!.getStringList("userCart");

    List<String> itemsIDsList = [];
    for(int i=1; i<userCartList!.length; i++)
    {
      //2367121:5
      String item = userCartList[i].toString();
      var lastCharacterPositionOfItemBeforeColon = item.lastIndexOf(":");

      //2367121
      String getItemID = item.substring(0, lastCharacterPositionOfItemBeforeColon);
      itemsIDsList.add(getItemID);
    }

    return itemsIDsList;
  }

  //2367121:5 ==> 5
  separateItemQuantitiesFromUserCartList()
  {
    //2367121:5
    List<String>? userCartList = sharedPreferences!.getStringList("userCart");
    print("userCartList = ");
    print(userCartList);

    List<int> itemsQuantitiesList = [];
    for(int i=1; i<userCartList!.length; i++)
    {
      //2367121:5
      String item = userCartList[i].toString();

      // 0=[:] 1=[5]
      var colonAndAfterCharactersList = item.split(":").toList(); // 0=[:] 1=[5]

      //5
      var quantityNumber = int.parse(colonAndAfterCharactersList[1].toString());

      itemsQuantitiesList.add(quantityNumber);
    }

    print("itemsQuantitiesList = ");
    print(itemsQuantitiesList);
    return itemsQuantitiesList;
  }


  separateOrderItemIDs(productIDs)
  {
    //2367121:5
    List<String>? userCartList = List<String>.from(productIDs);

    List<String> itemsIDsList = [];
    for(int i=1; i<userCartList.length; i++)
    {
      //2367121:5
      String item = userCartList[i].toString();
      var lastCharacterPositionOfItemBeforeColon = item.lastIndexOf(":");

      //2367121
      String getItemID = item.substring(0, lastCharacterPositionOfItemBeforeColon);
      itemsIDsList.add(getItemID);
    }

    return itemsIDsList;
  }

  separateOrderItemsQuantities(productIDs)
  {
    //2367121:5
    List<String>? userCartList = List<String>.from(productIDs);
    print("userCartList = ");
    print(userCartList);

    List<String> itemsQuantitiesList = [];
    for(int i=1; i<userCartList.length; i++)
    {
      //2367121:5
      String item = userCartList[i].toString();

      // 0=[:] 1=[5]
      var colonAndAfterCharactersList = item.split(":").toList(); // 0=[:] 1=[5]

      //'5'
      var quantityNumber = int.parse(colonAndAfterCharactersList[1].toString());

      itemsQuantitiesList.add(quantityNumber.toString());
    }

    print("itemsQuantitiesList = ");
    print(itemsQuantitiesList);
    return itemsQuantitiesList;
  }
}