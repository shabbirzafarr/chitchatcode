
// import 'dart:io';

import 'dart:io';

import 'package:chit_chat/pages/database/data.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  
  late DocumentSnapshot<Map<String,dynamic>> documentSnapshot;
  late DatabaseService a=DatabaseService();
  FirebaseAuth _auth=FirebaseAuth.instance;
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  // Map<String,dynamic> Data={'hey':"hey"};
  @override
  void initState() {
    super.initState(); 
    // LoadData(); 
  }
  // Future<void> LoadData()async{
  //   String phoneNumber="";
  //   phoneNumber=FirebaseAuth.instance.currentUser!.phoneNumber!;
  //   a=DatabaseService(phoneNumber: phoneNumber);
  //   print(phoneNumber);
  //   //  print(Data);
  //   documentSnapshot =
  //      await FirebaseFirestore.instance
  //       .collection("profile")
  //       .doc(phoneNumber).get();
  //       Data=documentSnapshot.data()!;
  //       print(Data);
  //       setState(() {
          
  //       });
   
    
  // }
   File? image;
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.sizeOf(context).height;
    double width=MediaQuery.sizeOf(context).width;
    EdgeInsets padding=MediaQuery.of(context).padding;
    return SingleChildScrollView(
      child: Container(
        height: height-padding.top,
        width: width,
        margin: EdgeInsets.only(top: padding.top),
        child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('profile')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return (map["phone no"]==_auth.currentUser!.phoneNumber)?pro(height,width, map, context):Center(child: SizedBox(),);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
      )
    );
  }
  Widget pro(double height,double width,Map<String,dynamic> Data,BuildContext context){
    return Container(
        decoration: BoxDecoration(color: Color(0xff769CFF)),
        child: Column(children: [
          Container(
                  height: height/30,
        
                ),
          (Data['name']==null)? Center(child: CircularProgressIndicator()): 
          Container(
            width: width,
            decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(height/15),topRight: Radius.circular(height/15)),color: Colors.white,),
            child: Column(children: [
              SizedBox(height: height/40,),
              Container(
                height: height/5,
                width: width/2.2,
                decoration: BoxDecoration(image: DecorationImage(
                  image:NetworkImage(Data['image']),
                fit: BoxFit.fill,),
                shape: BoxShape.circle,),
                child: InkWell(
                  onTap: ()async{
                    final Image=await ImagePicker().pickImage(source: ImageSource.gallery);
                    if(Image==null)
                    {
                      return;
                    }
                    final imagetemp=File(Image.path);
                    this.image=imagetemp;
                    Reference reference=FirebaseStorage.instance.ref();
                    Reference referenceImage=reference.child("Images").child(Data['phone no']);
                    try{
                      referenceImage.putFile(File(image!.path));
                      String ans=await referenceImage.getDownloadURL();
                      a.updateimage(ans);
                      Data['image']=ans;
                      
                    }
                    catch(e)
                    {
                      print(e.toString());
                    }
                    
                    
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(shape:BoxShape.circle,),
                    margin: EdgeInsets.only(right: height/18,bottom: height/36),
                    alignment: Alignment.bottomRight,
                    child: Container(decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.red[100]), child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(Icons.edit,color: Colors.red,),
                    )),
                  ),
                ),
              ),
              SizedBox(height: height/40,),
              InkWell(
                onTap: (){
                  String na=Data['name'];
                  showDialog(context: context, builder: (BuildContext context){
                    return Expanded(
                      child: AlertDialog(
                        title: Text('Update'),
                        content: TextField(
                          onChanged: (value){na=value;},
                          decoration: InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            
                            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
                            onPressed: () {Navigator.pop(context); },
                            child: Text('CANCEL',style: TextStyle(color: Colors.black),),
                          ),
                          ElevatedButton(
                            
                            onPressed: () {
                              a.updatename(na);
                              Navigator.pop(context);
                              
                            },
                            child: Text(' Submit '),
                          ),
                     ],
                ),
                    );
                  });
                },
                child: content(1,Data['name']),
              ),
              InkWell(
                onTap: (){
                  String status=Data['status'];
                  showDialog(context: context, builder: (BuildContext context){
                    return Expanded(
                      child: AlertDialog(
                        title: Text('Update'),
                        content: TextField(
                          onChanged: (value){status=value;},
                          decoration: InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            
                            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
                            onPressed: () {Navigator.pop(context); },
                            child: Text('CANCEL',style: TextStyle(color: Colors.black),),
                          ),
                          ElevatedButton(
                            
                            onPressed: () {
                              a.updatestatus(status);
                              Navigator.pop(context);
                              
                            },
                            child: Text(' Submit '),
                          ),
                     ],
                ),
                    );
                  });
                },
                child: content(2,Data['status']),
              ),
              InkWell(
                onTap: ()async{FirebaseAuth.instance.signOut();},
                child: content(0,Data['phone no']),
              )
            ],),
          )
        ],),
      );
  }
  Widget content(int i,String sub)
  {
    List<IconData> icon=[Icons.logout,Icons.person,Icons.info];
    List<String> cont=["Log -out","Name","Status"];
    return Container(
      margin: EdgeInsets.all(6),
      decoration: BoxDecoration(color: Colors.white10,borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon[i]),
        title: Text(cont[i]),
        subtitle: Text(sub),
        trailing: Icon(Icons.edit,color: (i==0)?Colors.white:Colors.black54,),
      ),
    );
  }
}