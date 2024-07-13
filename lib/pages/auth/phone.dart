import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

import 'opt.dart';
class phone extends StatelessWidget {
  phone({super.key});
  static String curs="";
  static String ans="";
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.sizeOf(context).height;
    double width=MediaQuery.sizeOf(context).width;
    
    return Scaffold(
      appBar: AppBar(title: Padding(
        padding: const EdgeInsets.only(left: 110),
        child: Text("login"),
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
                  SizedBox(height: height/15,),
                  Text("Enter Your Phone Number",style: TextStyle(color: Colors.black87,fontSize: 25,fontWeight: FontWeight.w600),),
                  SizedBox(height: height/60,),
                  Text("We well send you the verification code",style: TextStyle(fontSize: 16),),
                  SizedBox(height: height/20,),
                  Container(
                    width: width/1.3,
                    child: TextFormField(
                      onChanged: (value) {
                        ans=value;
                      },
                      cursorWidth: 4,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15),gapPadding: 5,borderSide: const BorderSide(width: 10)),
                        prefix: Text(" +91 | "),
                        labelText: "Phone Number",
                        hintText: "Phone number",
                        contentPadding: EdgeInsets.all(20),
                      ),
                    ),
                  ),  
                    Container(
                      margin: EdgeInsets.only(top: height/3),
                      child: InkWell(onTap: () async{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>otp()));
                        ans="+91"+ans;
                        
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          
                        phoneNumber: ans,
                        verificationCompleted: (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>otp()));
                          curs=verificationId;
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                       );
                      },  
                      child: Container( 
                        
                        width: width/1.3, decoration: BoxDecoration(color: Color(0xff769CFF),borderRadius: BorderRadius.circular(height/30)),child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Center(child: Text("Generate OTP",style: TextStyle(color: Colors.white,fontSize: 16),)),
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