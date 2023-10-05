import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_loginpage/screens/login-page.dart';
import 'package:flutter_loginpage/screens/spetial.dart';
import 'package:flutter_loginpage/screens/wrapper.dart';
import 'package:flutter_loginpage/shared/helperfunction.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '/main.dart';
import 'Newuser.dart';
import 'Olduser.dart';
import 'RealGame.dart';


class FirstLoading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FirstLoadingState();
  }
}
class FirstLoadingState extends State<FirstLoading> {
   @override
  bool testgame = false;
  double duration;
  String duration1='';
  String Roomname= '';
  Map<String, dynamic> TimeMap;
  double hour;
  double day;
  int nowhour;
  int nowday;
  int inthour;
  int intday;
  var currDt;
  bool varisend;
  bool exist;
  int realduration;
  bool testlog;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String myUsername;

  Future<void> isend() async {

    testgame=await HelperFunctions.getgameSharedPreference();
    testlog=await HelperFunctions.getUserLoggedInSharedPreference();

    Roomname=await HelperFunctions.getRoomSharedPreference();
    myUsername=await HelperFunctions.getUserNameSharedPreference();
    try {
      await FirebaseFirestore.instance.doc(Roomname+"/Time").get().then((doc) {
        exist = doc.exists;
      });
    } catch (e) {
      // If any error
      exist=false;
    }
    print(exist);
    print(exist);
    print("raszeb");
      duration1=await HelperFunctions.gettimeSharedPreference();
      duration=double.parse(duration1);
      realduration=duration.toInt();
      if(exist==true){
        await FirebaseFirestore.instance
            .collection(Roomname)
            .where("identifier", isEqualTo: "Time")
            .get()
            .then((value) {
            if (value != null) {
              TimeMap = value.docs[0].data();
              hour =  double.parse(TimeMap["hour"]);
              day =double.parse(TimeMap["day"]);


            }

        });
      print("&&&&&&&&&&&&&");
      print("&&&&&&&&&&&&&");
      print("&&&&&&&&&&&&&");
      currDt = DateTime.now();
      nowday =(currDt.day).toInt();
      nowhour =(currDt.hour).toInt();
    print("aaaaaaaaaaaa");
      inthour=hour.toInt();
      intday=day.toInt();
    print("bbbbbbbbbbbb");
    print(duration);
      if((duration+intday)%30<=nowday){
        if((duration+intday)%30==nowday && nowhour>=hour){varisend=true;}
        if((duration+intday)%30<nowday){varisend=true;}

        varisend=true;
      }
      else{varisend=false;}
    print("ccccccccccccc");
      print(varisend);
      print(inthour);
      print(intday);
      print(nowhour);
      print(nowday);}

      print("taw");
      print(exist);
      print(testgame);
      print(varisend);
    print("taw");
    print("taw");
      print(testlog);



  }




  void initState() {
    isend();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 4);
    return new Timer(duration, route);
  }
  route() async {
    if(testgame==true && testlog==true){
      if(exist==true){
        if(varisend==false){print(varisend);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => Olduser()
        )
        );}
        else{FirebaseFirestore.instance.collection(Roomname).where("RoomID", isNotEqualTo : "absolutRoom").get().then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs){
            ds.reference.delete();
          }});

        await FirebaseFirestore.instance.collection("users").doc(myUsername).update({
          "Roomname" : ""

        }).catchError((e) {
          print(e.toString());
        });



        await HelperFunctions.savegameSharedPreference(false);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => spetial()
        )
        );}
      }
      else{await HelperFunctions.savegameSharedPreference(false);
      await FirebaseFirestore.instance.collection("users").doc(myUsername).update({
        "Roomname" : ""

      }).catchError((e) {
        print(e.toString());
      });
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => spetial()
      )
      );}
    }
    else{if(testlog==true && testgame==false){

      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Newuser()
      )
      );}

    else{print('zboub');
    {Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => LoginPage()
    )
    );}

    }}

  }




  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage1(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body:  SafeArea( child :
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 220),
                  child: Center(
                      child: Image.asset(
                        'assets/images/Loading.png',
                        width: 350,
                        height: 200,
                      )


                  ),
                ),
              ],
            ),
            ),),
      ],
    );
  }
}