
import 'package:asia_project/models/group_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupService{
  final FirebaseFirestore firestore;
  
  GroupService({
    required this.firestore
  });
  
  Future<List<GroupModel>> getAllGroup()async{
    List<GroupModel> groupModel = [];
    CollectionReference collectionReferenceGroupModel = firestore.collection("groups");
    QuerySnapshot querySnapshot = await collectionReferenceGroupModel.get();
    print("query $querySnapshot");
    querySnapshot.docs.forEach((document){
      var data = GroupModel.fromMap(document.data() as Map<String,dynamic>,document.id);
      groupModel.add(data);
    });
    return groupModel;
  }
}