import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatRoom extends StatefulWidget {
  late String chatRoomId;
  late Map<String, dynamic> userMap;
  ChatRoom({super.key, required this.chatRoomId, required this.userMap});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController _message = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late ScrollController _scrollController = ScrollController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  late Map<String, dynamic> own;
  @override
  void initState() {
    super.initState();
    // _scrollDown();
    loads();
    // WidgetsBinding.instance.addPostFrameCallback((_) {

    // });
  }

  @override
  void dispose() {
    _scrollController
        .dispose(); // Don't forget to dispose the controller when done.
    super.dispose();
  }

  loads() async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("profile")
        .doc(_auth.currentUser!.phoneNumber);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    own = documentSnapshot.data() as Map<String, dynamic>;
    print(own);
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500), // Adjust the duration as needed
      curve: Curves.easeOut,
    );
  }

  Future<bool> check() async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("personal")
        .doc(widget.userMap['phone no'])
        .collection("chats")
        .doc(_auth.currentUser!.phoneNumber);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    return documentSnapshot.exists;
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.phoneNumber,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(messages);
      // _scrollDown();
      await FirebaseFirestore.instance
          .collection("personal")
          .doc(_auth.currentUser!.phoneNumber)
          .collection("chats")
          .doc(widget.userMap['phone no'])
          .update({
        'chat': _message.text,
        "time": FieldValue.serverTimestamp(),
      });

      await (check())
          ? await FirebaseFirestore.instance
              .collection("personal")
              .doc(widget.userMap['phone no'])
              .collection("chats")
              .doc(_auth.currentUser!.phoneNumber)
              .update({
              'chat': _message.text,
              "time": FieldValue.serverTimestamp(),
            })
          : await FirebaseFirestore.instance
              .collection("personal")
              .doc(widget.userMap['phone no'])
              .collection("chats")
              .doc(_auth.currentUser!.phoneNumber)
              .set({
              "image": own["image"],
              "name": own["name"],
              "phone no": own["phone no"],
              "status": own["status"],
              'chat': _message.text,
              "time": FieldValue.serverTimestamp(),
            });

      print(_message.text);
    } else {
      print("Enter Some Text");
    }
  }

  Future<void> del(String id) async {
    print(id);
    await FirebaseFirestore.instance
        .collection("chatroom")
        .doc(widget.chatRoomId)
        .collection("chat")
        .doc(id)
        .delete();
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
        // controller: _scrollController,
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
                          backgroundImage:
                              NetworkImage(widget.userMap['image']),
                        ),
                        title: Text(widget.userMap['name']),
                        subtitle: Text(widget.userMap['status']),
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
                                  .collection('chatroom')
                                  .doc(widget.chatRoomId)
                                  .collection('chats')
                                  .orderBy("time", descending: false)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.data != null) {
                                  return ListView.builder(
                                    controller: _scrollController,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> map =
                                          snapshot.data!.docs[index].data()
                                              as Map<String, dynamic>;
                                      String id = snapshot.data!.docs[index].id;
                                      if (map['time'] == null) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                      return Dismissible(
                                          key: Key(
                                              snapshot.data!.docs[index].id),
                                          onDismissed: (direction) {
                                            print(id);
                                            FirebaseFirestore.instance
                                                .collection("chatroom")
                                                .doc(widget.chatRoomId)
                                                .collection("chat")
                                                .doc(id)
                                                .delete()
                                                .then((_) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text('Item deleted'),
                                                ),
                                              );
                                            }).catchError((error) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Error deleting item: $error'),
                                                ),
                                              );
                                            });
                                          },
                                          background: Container(
                                            color: Colors.red,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                            alignment: Alignment.centerRight,
                                            padding:
                                                EdgeInsets.only(right: 20.0),
                                          ),
                                          child: messages(width, map, context));
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
