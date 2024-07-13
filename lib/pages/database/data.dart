// import 'dart:js_interop';

// import 'package:chit_chat/pages/auth/phone.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_core/firebase_core.dart';


class DatabaseService{
  String? phoneNumber=FirebaseAuth.instance.currentUser!.phoneNumber;
  DatabaseService();
  final CollectionReference profile=FirebaseFirestore.instance.collection('profile');
  final DatabaseReference user=FirebaseDatabase.instance.ref("user");
  Future updateprofile(String image,String name,String status,String phoneNumber) async{
   await FirebaseFirestore.instance
        .collection("profile")
        .doc(phoneNumber)
        .set({'name':name,
        'image':image,
        'status':status,
        'phone no' :phoneNumber,
        'Online':true
        });
  }
  Future updatename(String name) async{
   await FirebaseFirestore.instance
        .collection("profile")
        .doc(phoneNumber)
        .update({'name':name,
        'phone no' :phoneNumber
        });
  }
  Future updatestatus(String status) async{
   await FirebaseFirestore.instance
        .collection("profile")
        .doc(phoneNumber)
        .update({'status':status,
        'phone no' :phoneNumber
        });
  }
  Future updateimage(String image) async{
   await FirebaseFirestore.instance
        .collection("profile")
        .doc(phoneNumber)
        .update({'image':image,
        'phone no' :phoneNumber
        });
  }
  Future getData() async{
    // dynamic Data=[];
    final datasnapshot=await FirebaseFirestore.instance.collection("profile");
    final data= datasnapshot.get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        print(doc.data);
      });
    });  
  }
  Future addUser(String p) async{
    user.child(p).set({"phoneno":p});
  }
  Future<bool> getUser(String p) async{
    final snapshot=await FirebaseFirestore.instance.collection("profile").doc(p).get();
    final Data=snapshot.exists;
    // print(Data);
    if(Data==true)
    {
      print(p);
    }
    return Data;
    // snapshot.toJS;
    
  }
}