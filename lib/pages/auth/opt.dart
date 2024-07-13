import 'package:chit_chat/pages/auth/phone.dart';
import 'package:chit_chat/pages/auth/set.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
class otp extends StatelessWidget {
  otp({super.key});
  final FirebaseAuth _auth=FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.sizeOf(context).height;
    double width=MediaQuery.sizeOf(context).width;
    String currentText="";
    return Scaffold(
      appBar: AppBar(title: Padding(
        padding: const EdgeInsets.only(left: 110),
        child: Text("Verification"),
      ),elevation: 0.0,backgroundColor: Color(0xff769CFF),),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xff769CFF),
          child: Column(children: [
            Container(
              height: height/7,
              width: width,
              child: SizedBox(),
            ),
            Container(
              width: width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(height/15),topRight: Radius.circular(height/15)),color: Colors.white,),
              child: Column(
                children: [
                  SizedBox(height: height/15,),
                  Text("Verification Code",style: TextStyle(color: Colors.black87,fontSize: 25,fontWeight: FontWeight.w600),),
                  SizedBox(height: height/60,),
                  Text("We have send the verification Code to",style: TextStyle(fontSize: 16),),
                  SizedBox(height: height/60,),
                  Text(phone.ans.substring(phone.ans.length-13),style: TextStyle(fontSize: 16),),
                  SizedBox(height: height/50,),
                  Container(
                    width: width/1.5,
                    height: height/6,
                    child: PinCodeTextField(
                      keyboardType: TextInputType.number,
                       pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(height/7),
                          selectedColor: Colors.lightBlue,
      
                          inactiveColor: Colors.black12
                        ),
                        pastedTextStyle: TextStyle(
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                        boxShadows: const [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black12,
                            blurRadius: 10,
                          )
                        ],
                      blinkDuration: Duration(milliseconds: 5),
                      appContext: context, length: 6, onChanged: (value) {
                            debugPrint(value);
                            currentText = value;
                            
                          },),
                  ),
                  Container(
                        margin: EdgeInsets.only(top: height/4),
                        child: InkWell(onTap: () async{
                          try{
                            PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: phone.curs, smsCode: currentText);
                          await _auth.signInWithCredential(credential);
                          
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>settouse()));
                          
                          }
                          catch(e)
                          {
                            print(e.toString());
                          }
                        
                        },  
                        child: Container( 
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.only(top: 10),
                          width: width/1.3, decoration: BoxDecoration(color: Color(0xff769CFF),borderRadius: BorderRadius.circular(height/30)),child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Center(child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 16),)),
                        ),)),
                      ),
                      SizedBox(height: height/60,),
                ],
              ),
            )
      
          ],
          ),
        ),
      ),
    );
  }
}