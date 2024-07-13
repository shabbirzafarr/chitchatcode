// import 'package:chit_chat/pages/auth/phone.dart';
// import 'package:chit_chat/pages/database/data.dart';
import 'package:chit_chat/pages/main%20pages/chatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import '';
import 'package:flutter/material.dart';

class chat extends StatefulWidget {
  const chat({super.key});

  @override
  State<chat> createState() => _chatState();
}

class _chatState extends State<chat> with WidgetsBindingObserver {
  String c = "";
  Map<String, dynamic> userMap = {};
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus(true);
  }

  void setStatus(bool status) async {
    await _firestore
        .collection("profile")
        .doc(_auth.currentUser!.phoneNumber)
        .update({'Online': status});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setStatus(true);
    } else {
      setStatus(false);
    }
  }

  void onSend() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("personal")
        .doc(_auth.currentUser!.phoneNumber)
        .collection("chats")
        .doc(userMap['phone no'])
        .get();
    final Data = snapshot.exists;
    if (Data == false) {
      await FirebaseFirestore.instance
          .collection("personal")
          .doc(_auth.currentUser!.phoneNumber)
          .collection("chats")
          .doc(userMap['phone no'])
          .set({
        'name': userMap['name'],
        'phone no': userMap['phone no'],
        'image': userMap['image'],
        'status': userMap['status'],
        'chat': "",
        "time": FieldValue.serverTimestamp(),
      });
    } else {
      print("Data failed to enter");
    }
  }

  void onSearch(String ans) async {
    String a = "";

    setState(() {});
    a = "+91" + ans;
    await _firestore.collection('profile').doc(a).get().then((value) {
      setState(() {
        userMap = value.data()!;
        print(userMap);
      });
    });
  }

  String chatRoomId(String user1, String user2) {
    if (user1.compareTo(user2) > 0) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return SingleChildScrollView(
      child: Container(
        color: Color(0xff769CFF),
        child: Column(
          children: [
            Container(
              height: height * 10 / 100,
            ),
            Container(
              width: width,
              height: height * 67 / 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(height / 15),
                    topRight: Radius.circular(height / 15)),
                color: Colors.white,
              ),
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: height / 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: width / 20),
                      height: height * 9 / 100,
                      child: Container(
                          height: height * 9 / 100,
                          width: width / 1.2,
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(height / 20)),
                                prefixText: "  +91  ",
                                suffixIcon: Icon(Icons.search),
                                hintText: "Enter the phone number"),
                            onChanged: (value) {
                              onSearch(value);
                            },
                          )),
                    ),
                    SizedBox(
                      height: height * 1 / 100,
                    ),
                    (userMap.length != 0)
                        ? Container(
                            margin: EdgeInsets.all(5),
                            child: InkWell(
                              onTap: () async {
                                onSend();
                                String roomId = chatRoomId(
                                    _auth.currentUser!.phoneNumber!,
                                    userMap!['phone no']);
                                c = roomId;
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ChatRoom(
                                      chatRoomId: roomId,
                                      userMap: userMap,
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(userMap['image']),
                                ),
                                title: Text(userMap["name"]),
                                subtitle: Text(userMap['status']),
                                trailing: Icon(Icons.messenger_outline),
                              ),
                            ),
                          )
                        : Container(
                            child: Center(
                              child: Text(""),
                            ),
                          ),
                    Container(
                        child: Column(
                      children: [
                        Text(
                          "Recent Chats",
                          style: TextStyle(color: Colors.black54),
                        ),
                        Container(
                          height: height * 35 / 100,
                          width: width * 95 / 100,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection('personal')
                                .doc(_auth.currentUser!.phoneNumber)
                                .collection('chats')
                                .orderBy("time", descending: true)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.data != null) {
                                return ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> map =
                                        snapshot.data!.docs[index].data()
                                            as Map<String, dynamic>;

                                    return InkWell(
                                      onTap: () {
                                        String roomId = chatRoomId(
                                            _auth.currentUser!.phoneNumber!,
                                            map['phone no']);
                                        c = roomId;
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => ChatRoom(
                                              chatRoomId: roomId,
                                              userMap: map,
                                            ),
                                          ),
                                        );
                                      },
                                      child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(map["image"]),
                                          ),
                                          title: Text(map["name"]),
                                          subtitle: Text(map['chat']),
                                          trailing: Icon(
                                              Icons.trip_origin_outlined,
                                              color: Colors.green)),
                                    );
                                  },
                                );
                              } else {
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
                      ],
                    ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
