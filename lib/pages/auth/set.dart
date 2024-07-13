import 'package:chit_chat/pages/database/data.dart';
import 'package:chit_chat/pages/main%20pages/mainpage.dart';
import 'package:chit_chat/pages/auth/phone.dart';
import 'package:chit_chat/pages/wrapper.dart';
import 'package:flutter/material.dart';
class settouse extends StatelessWidget {
   settouse({super.key});
  DatabaseService a=DatabaseService();
  String image="https://img.freepik.com/free-vector/isolated-young-handsome-man-different-poses-white-background-illustration_632498-859.jpg?w=740&t=st=1686723546~exp=1686724146~hmac=3f16252a2466a8aaecd2c4d870845c1b706290dfb817b1c4aaa16e9c87f2dcef";
  static String ans="name";
  @override
  Widget build(BuildContext context) {
     double height=MediaQuery.sizeOf(context).height;
    double width=MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
        padding: const EdgeInsets.only(left: 110),
        child: Text("Ready To Use"),
      ),elevation: 0.0,backgroundColor: Color(0xff769CFF),),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xff769CFF),
          child: Column(
            children: [
              Container(
                height: height/7,
      
              ),
              Container(
                
                width: width,
                decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(height/15),topRight: Radius.circular(height/15)),color: Colors.white,),
                child: Column(children: [
                  SizedBox(height: height/8,),
                  Text("Congratulations",style: TextStyle(color: Colors.black87,fontSize: 25,fontWeight: FontWeight.w600),),
                  SizedBox(height: height/60,),
                  Text("You are ready to use ChitChat App",style: TextStyle(fontSize: 16),),
                  SizedBox(height: height/20,),
                  Container(
                    width: width/1.3,
                    child: TextFormField(
                      onChanged: (value) {
                          ans=value;
                        },
                        cursorWidth: 4,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15),gapPadding: 5,borderSide: const BorderSide(width: 10)),
                          prefixIcon: Icon(Icons.data_usage_rounded),
                          labelText: "Name",
                          hintText: "Enter your name",
                          contentPadding: EdgeInsets.all(20),
                        ),
                    ),
                  ),
                  
                    Container(
                      margin: EdgeInsets.only(top: height/3.5),
                      child: InkWell(onTap: () {
                        a.addUser(phone.ans);
                        a.updateprofile(image, ans, "Status",phone.ans);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>wrapper()));
                        
                      },  
                      child: Container( 
                        
                        width: width/1.3, decoration: BoxDecoration(color: Color(0xff769CFF),borderRadius: BorderRadius.circular(height/30)),child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Center(child: Text("Get Started",style: TextStyle(color: Colors.white,fontSize: 16),)),
                      ),)),
                    )
                  
      
                ]),
              
              )
            ],
          ),
        ),
      ),
    );
  }
}