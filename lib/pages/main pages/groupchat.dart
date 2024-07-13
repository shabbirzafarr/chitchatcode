import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Groupchat extends StatefulWidget {
  String uid = "", gname = "", admin = "";
  Groupchat(
      {super.key, required this.uid, required this.gname, required this.admin});

  @override
  State<Groupchat> createState() => _GroupchatState();
}

class _GroupchatState extends State<Groupchat> {
  TextEditingController _message = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      print(_message.text);
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.phoneNumber,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      await _firestore
          .collection('Groupchat')
          .doc(widget.uid)
          .collection('chatscreen')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          onSendMessage();
        },
        child: Icon(Icons.send),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Color(0xff769CFF),
          ),
          child: Column(
            children: [
              Container(
                height: height * 20 / 100,
              ),
              Container(
                width: width,
                height: height * 80 / 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(height / 15),
                      topRight: Radius.circular(height / 15)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      height: height * 10 / 100,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage("assets/icon.png"),
                        ),
                        title: Text(widget.gname),
                        subtitle: Row(
                          children: [Text("Created by:"), Text(widget.admin)],
                        ),
                      ),
                    ),
                    Container(
                      height: height * 60 / 100,
                      child: Column(
                        children: [
                          Text(
                            "Chat",
                            style: TextStyle(
                                fontSize: height * 3 / 100,
                                color: Colors.black45),
                          ),
                          Container(
                            height: height * 55 / 100,
                            width: width,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: _firestore
                                  .collection('Groupchat')
                                  .doc(widget.uid)
                                  .collection('chatscreen')
                                  .orderBy("time", descending: false)
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
                                      if (map['time'] == null) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                      return messages(width, map, context);
                                    },
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: height * 8 / 100,
                      margin: EdgeInsets.only(right: width / 4),
                      alignment: Alignment.bottomLeft,
                      width: width / 1.5,
                      child: TextFormField(
                        controller: _message,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(height * 5 / 100))),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget messages(
      double width, Map<String, dynamic> map, BuildContext context) {
    Timestamp ti = map["time"];
    DateTime time = ti.toDate();

    String a = "am";
    if ((time.hour / 12) % 2 != 0) {
      a = "pm";
    }
    int hour = time.hour % 12;
    return Container(
      width: width,
      alignment: map['sendby'] == _auth.currentUser!.phoneNumber
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.blue,
          ),
          child: Column(
            children: [
              Text(
                map['message'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                "${time.day}-${time.month} ${hour.toString()} ${time.minute}${a}",
                style: TextStyle(fontSize: 12),
              )
            ],
          )),
    );
  }
}
