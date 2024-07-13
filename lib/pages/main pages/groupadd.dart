import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class groupadd extends StatefulWidget {
  String name="";
  groupadd({super.key,required this.name});

  @override
  State<groupadd> createState() => _groupaddState();
}

class _groupaddState extends State<groupadd> {
  List<Map<String,dynamic>> contact = [];
  Map<String, dynamic> userMap = {};
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  void createGroup() async {
    final uuid = Uuid();
    String uid = uuid.v4();
    for (int i = 0; i < contact.length; i++) {
      firestore
          .collection("group")
          .doc(contact[i]["phone no"])
          .collection("groupchat")
          .add({
        "uid": uid,
        "time": FieldValue.serverTimestamp(),
        "admin": _auth.currentUser!.phoneNumber,
        "name":widget.name,
      });
    }
    firestore.collection("Groupchat").doc(uid).collection("chatscreen").add({
      "name":widget.name,
      "sendby": _auth.currentUser!.phoneNumber,
      "message": "This group is created!",
      "type": "text",
      "time": FieldValue.serverTimestamp(),
    });
  }
  
  void addm() {
    for(int i=0;i<contact.length;i++)
    {
      if(contact[i]["phone no"]==userMap["phone no"])
      return;
    }
    contact.add(userMap);
    //  print(contact);
    
  }

  void onSearch(String ans) async {
    String a = "";

    setState(() {});
    a = "+91" + ans;
    await firestore.collection('profile').doc(a).get().then((value) {
      userMap = value.data()!;
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets devicep = MediaQuery.of(context).padding;
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Create Group"),
          backgroundColor: Color(0xff769CFF),
          elevation: 0.0,
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          if(contact.length>=1)
          {
            createGroup();
            Navigator.pop(context);
          }
        },
        child: Icon(Icons.done),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: Color(0xff769CFF)),
            child: Column(
              children: [
                Container(
                  height: screenSize.height * 5 / 100,
                ),
                Container(
                  height: 86 / 100 * screenSize.height - devicep.top,
                  
                  width: screenSize.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(screenSize.height / 15),
                          topRight: Radius.circular(screenSize.height / 15))),
                  child: Container(
                    margin: EdgeInsets.only(top: screenSize.height/14),
                    
                    child: Column(
                      children: [
                        
                        Container(
                          width: screenSize.width*90/100,
                          child: TextFormField(
                                            decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            prefixText: "  +91  ",
                            suffixIcon: Icon(Icons.search),
                            hintText: "Enter the phone number"),
                                            onChanged: (value) {
                          setState(() {
                            onSearch(value);
                            
                          });
                                            },
                                          ),
                        ),
                        (contact.length!=0)?Text("added members"):Text(""),
                        (contact.length != 0)
                        ? Container(
                          height: screenSize.height*30/100,
                          width: screenSize.width*90/100,
                            child: ListView.builder(
                            itemCount: contact.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(contact[index]["image"]),
                                ),
                                 title: Text(contact[index]["name"]),
                                subtitle: Text(contact[index]["status"]),
                                trailing: (contact[index]["Online"])?Icon(Icons.toggle_on_outlined,color: Colors.green,):Icon(Icons.toggle_off_outlined,color: Colors.red,),
                              );
                            },
                          ))
                        : Container(),
                        (userMap.length != 0)?Text("Result"):Text(""),
                    (userMap.length != 0)
                        ? InkWell(
                          onTap: (){
                            setState(() {
                              addm();
                            });
                            
                          },
                            child: Container(
                              width: screenSize.width*90/100,
                              height: 50,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(userMap['image']),
                                ),
                                title: Text(userMap["name"]),
                                subtitle: Text(userMap['status']),
                                trailing: Icon(Icons.messenger_outline),
                              ),
                            ),
                          )
                        : Container()
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
