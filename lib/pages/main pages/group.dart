import 'package:chit_chat/pages/main%20pages/groupadd.dart';
import 'package:chit_chat/pages/main%20pages/groupchat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Group extends StatefulWidget {
  const Group({super.key});

  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _name = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    EdgeInsets devicep = MediaQuery.of(context).padding;
    Size screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(color: Color(0xff769CFF)),
        child: Column(
          children: [
            Container(
              height: screenSize.height * 5 / 100,
            ),
            Container(
              width: screenSize.width,
              height: screenSize.height * 85 / 100 - devicep.top - 129,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(screenSize.height / 15),
                      topRight: Radius.circular(screenSize.height / 15))),
              child: Column(
                children: [
                  Container(
                    height:
                        screenSize.height * 87 / 100 - devicep.top - 129 - 70,
                    width: screenSize.width * 90 / 100,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('group')
                          .doc(_auth.currentUser!.phoneNumber)
                          .collection('groupchat')
                          .orderBy("time", descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data != null) {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              print(index);
                              Map<String, dynamic> map =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;
                              print(map);
                              return InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Groupchat(uid: map["uid"], gname:map["name"], admin: map["admin"])));
                                },
                                child: ListTile(
                                  leading: CircleAvatar(backgroundImage: AssetImage("assets/icon.png"),),
                                  title: Text(map["name"]),
                                  subtitle: Row(
                                    children: [
                                      Text("Created by:"),
                                      Text(map["admin"])
                                    ],
                                  ),
                                  trailing: Icon(Icons.send),
                                ),
                              );
                            },
                          );
                        } else {
                          print("not fount");
                          return Container(
                            child: Text(
                              "fuck off",
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _createGroup(context);
                      
                    },
                    child: Container(
                      alignment: Alignment.bottomRight,
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(0xff769CFF)),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createGroup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Group Name'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _name,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Create Group'),
              onPressed: () {
                if (_name.text.length != 0)
                Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => groupadd(name: _name.text)));
                          
              },
            ),
          ],
        );
      },
    );
  }
}
