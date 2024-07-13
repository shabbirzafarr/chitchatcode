import 'package:chit_chat/pages/auth/phone.dart';
import 'package:flutter/material.dart';
class lending extends StatelessWidget {
  const lending({super.key});

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.sizeOf(context).width;
    double height=MediaQuery.sizeOf(context).height;
    // bool con=false;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: Color(0xff769CFF)),
        child: Column(
          children: [
            Container(height: height/4,width: width, child: Padding(
              padding: const EdgeInsets.only(left: 150,top: 50),
              child: Text("Get Started",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),),
            Container(height: 3*height/4,width: width,decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(height/15),topRight: Radius.circular(height/15)),color: Colors.white), child: Column(
              children: [
                Container(height: height/5,width: 75, child: Center(child: Image.network('https://cdn-icons-png.flaticon.com/512/92/92036.png?w=740&t=st=1686651596~exp=1686652196~hmac=31ce3e121d684dc2477d77360db7b35ab3e151cb7fb4811ae6f43332cafe657b',color: Colors.amber,))),
                SizedBox(height: height/35,),
                Text("Hello!",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                SizedBox(height: height/50,),
                Text("You need to create an account",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
                SizedBox(height: height/3.3,),
                InkWell(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>phone()));
                
                },  child: Container(height: height/13,width: width/1.8, decoration: BoxDecoration(color: Color(0xff769CFF),borderRadius: BorderRadius.circular(height/30)),child: Center(child: Text("Create an account",style: TextStyle(color: Colors.white),)),))
              ],
            ))
          ],
        ),
      ),
    );
  }
}