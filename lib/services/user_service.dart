
import 'package:asia_project/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService{
  final FirebaseFirestore firestore;
  
  UserService({
    required this.firestore,
  });
  
  Future<List<UserModel>> getAllUsers()async{
    List<UserModel> users = [];
    CollectionReference collectionReferenceUsers = firestore.collection("users");
    QuerySnapshot querySnapshot = await collectionReferenceUsers.get();
    querySnapshot.docs.forEach((document){
      var data = UserModel.fromMap(document.data() as Map<String,dynamic>);
      users.add(data);
    });
    return users;
  }
  
  Future<List<UserModel>> getByProperty(String property, String valueProperty)async{
    List<UserModel> users = [];
    CollectionReference collectionReferenceUser = firestore.collection("users");
    try{
      QuerySnapshot querySnapshot = await collectionReferenceUser.where(property,isEqualTo: valueProperty).get();
      if(querySnapshot.docs.isEmpty){
        print("No documents found $property");
      }
      querySnapshot.docs.forEach((document){
        var userModel = UserModel.fromMap(document.data() as Map<String,dynamic>);
        users.add(userModel);
      });

    }catch(error){
      print("Error with the method getByNameUser Error: $error");
    }
    return users;
  }
}