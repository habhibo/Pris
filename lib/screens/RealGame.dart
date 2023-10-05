import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loginpage/models/locationmodel.dart';
import 'package:flutter_loginpage/screens/spetial.dart';
import 'package:flutter_loginpage/shared/helperfunction.dart';
import 'package:flutter_loginpage/widgets/BackgroundImage1.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'Olduser.dart';


class RealGame extends StatefulWidget {
  @override
  _RealGameState createState() => _RealGameState();



}

class _RealGameState extends State<RealGame> with WidgetsBindingObserver {





  Map<String, dynamic> userMap;
  get userData => null;
  String myUsername;
  Position _currentPosition=null;

  int size = 0;
  List nameTab = new List();
  List distanceTab = new List();
  String myLocationlat ='';
  String myLocationlon ='';
  String minName ='';
  double minDistance;
  double minDistanceabsolute=1000;
  List otherDistanceTab = new List();
  String kind = '';
  int i = 0;
  String friendAtRisk = '';
  String State = '';
  String color ='Green';
  List statsTab = new List();
  int points = 0;
  int R=48;
  int G=183;
  int B =66;
  int time = 0;
  int oldpoints =0;
  String lat = '0';
  String long = '0';
  String text ='';
  String romname;
  String RoomName ="";

  Position position=null;
  int reloadduration ;
  double distancetime;
  bool newtest=true;
  String gamepointsstring;
  int a=0;
  int b=0;
  int c=0;
  int d=0;
  int e=0;
  int f=0;
  int counter=0;

  int gamepoints;


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
  List ResultList = new List();
  int resultCounter;




  Future<void> isend() async {
    testgame=await HelperFunctions.getgameSharedPreference();
    testlog=await HelperFunctions.getUserLoggedInSharedPreference();

    Roomname=await HelperFunctions.getRoomSharedPreference();
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
  startTime() async {
    var duration = new Duration(seconds: 4);
    return new Timer(duration, route);
  }
  route() async {
    if(testgame==true && testlog==true){
      if(exist==true){
        if(varisend==true){FirebaseFirestore.instance.collection(Roomname).where("RoomID", isNotEqualTo : "absolutRoom").get().then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs){
            ds.reference.delete();
          }});



        await HelperFunctions.savegameSharedPreference(false);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => spetial()
        )
        );}
      }
      else{await HelperFunctions.savegameSharedPreference(false);
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => spetial()
      )
      );}
    }


  }










  initState() {

    //Roomget();
    isend();
    startTime();
    mybigfunction();
  }
  Future<void> location() async {


      position = await _getCurrentLocation();

    setState(()  {

      lat =  position.latitude.toString();
    });

    setState(()  {

      long = position.longitude.toString();
    });


  }

  /*Future<void> Roomget() async {
    RoomName=await HelperFunctions.getRoomSharedPreference();
    print("ghghghghgh");
    print(RoomName);
  }*/




  Future<void> mybigfunction()  async {
    RoomName=await HelperFunctions.getRoomSharedPreference();
    myUsername= await HelperFunctions.getUserNameSharedPreference();
    print(myUsername);
    print(RoomName);
    await FirebaseFirestore.instance
        .collection(RoomName)
        .where("userName", isEqualTo: myUsername)
        .get()
        .then((value) async {
      if (value != null) {
        userMap = value.docs[0].data();
        kind = userMap["kind"];
        if(kind=='out'){
        showDialog(context: context, builder: (context){

          return AlertDialog(title:Text('Phone Alert'),content: Text("You Lost ! ,Tag others to earn more points" ),actions: [FlatButton(onPressed: () async {
            await FirebaseFirestore.instance.collection(RoomName).doc(myUsername).update({
              "kind": 'Tagger',
              "Result" :'Lost',

            }).catchError((e) {
              print(e.toString());
            });

            }, child: Text('Continue'))],);
        });}


      }
    });
    print("kkkkkkkkkkkkkkkkk");
    if(kind=="Tagger"){setState(() { text = 'Tag'; });
    }
    else{setState(() { text = 'Run'; });}

    if(kind=='Runner'){
      {setState(() {R=G=B=0; });}

      await FirebaseFirestore.instance
          .collection(RoomName)
          .where("userName", isEqualTo: myUsername)
          .get()
          .then((value) {
        setState(() {
          if (value != null) {
            userMap = value.docs[0].data();
            friendAtRisk = userMap['risk'];

          }
        });
      });}
    await FirebaseFirestore.instance
        .collection(RoomName).where("identifier", isEqualTo : "Player")
        .get()
        .then((value) {
      setState(() {
        if (value != null) {
          size = value.size;
          for(int index = 0 ; index < size; index++){
            ResultList.add(value.docs[index].data()["Result"]);

          }
        }
      });
    });
    for(int index = 0 ; index < size; index++)
      {
        if(ResultList[index]=="Lost")
        {resultCounter++;}
      }
    if(resultCounter==size-1){
      if(kind=="Lost"){
        await FirebaseFirestore.instance.collection("users").doc(myUsername).update({
          "Roomname" : ""

        }).catchError((e) {
          print(e.toString());
        });


      }
      else{
        await FirebaseFirestore.instance.collection("users").doc(myUsername).update({
          "Roomname" : ""

        }).catchError((e) {
          print(e.toString());
        });

      }



    }


    await location();
    //romname= await HelperFunctions.getRoomSharedPreference();
    print('laaaaaaaaaafaaaaaaaaaafa');
    //print(romname+"h               hhhhhhhhhhhhhh");






    //RoomName="karezet_room";
    //await HelperFunctions.getRoomSharedPreference();
    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

    print("------------------------");


    await FirebaseFirestore.instance.collection(RoomName).doc(myUsername).update({
      "Locationlat": lat,
      "Locationlon" : long,
    }).catchError((e) {
      print(e.toString());
    });
    ("aaaaaaaaaaaaaaaaaa");
    await FirebaseFirestore.instance
        .collection(RoomName).where("identifier", isEqualTo : "Player")
        .get()
        .then((value) {
      setState(() {
        if (value != null) {
          size = value.size;
          print(size = value.size);
          for(int index = 0 ; index < size; index++){
            nameTab.add(value.docs[index].data()["userName"]);
            distanceTab.add(Geolocator.distanceBetween(double.parse(value.docs[index].data()["Locationlat"]), double.parse(value.docs[index].data()["Locationlon"]),double.parse(lat),double.parse(long)));

          }
        }
      });
    });

    print("bbbbbbbbbbbbbbbbb");

    print(text);

    otherDistanceTab=distanceTab;
    distanceTab.sort();
    minDistance =distanceTab[0];
    minName=nameTab[otherDistanceTab.indexOf(minDistance)];
    print("cccccccccccccc");
    if(minDistanceabsolute>minDistance){minDistanceabsolute=minDistance;}


    if(minDistance>20){newtest==true;}
    print(kind);

    if(kind=='Runner' && minDistance<15) {
        await FirebaseFirestore.instance
            .collection('users')
            .get()
            .then((value)  async {
            if (value != null) {
              for (i = 0; i < size; i++){
              userMap = value.docs[i].data();
             if(userMap[kind]=='Runner'){
               await FirebaseFirestore.instance.collection(RoomName).doc(userMap['userName']).update({

                 "risk" :myUsername



               }).catchError((e) {
                 print(e.toString());
               });

             }

            }
          }});



    }

    print("dddddddddddddd");
    print(kind+"thisisit");

    if(friendAtRisk!='' && newtest==true){
      newtest=false;
      showDialog(context: context, builder: (context){

        return AlertDialog(title:Text('Phone Alert'),content: Text('Your Friend '+friendAtRisk +'is about to get tagged' ),actions: [FlatButton(onPressed: (){Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RealGame()),);}, child: Text('Continue'))],);


      });
    }
    if(minDistanceabsolute>15 && minDistance>30 && kind=="Runner"){oldpoints=oldpoints+10;
    await FirebaseFirestore.instance.collection('users').doc(myUsername).update({
      "points":oldpoints,
    }).catchError((e) {
      print(e.toString());
    });}
    print("fffffffffff");
    await FirebaseFirestore.instance.collection('users')
        .where("userName", isEqualTo: myUsername)
        .get()
        .then((value) async {
        if (value != null) {
          oldpoints= int.parse(value.docs[0].data()["points"]);

        }
      });

    if(minDistance<10)
    {distancetime=15;}
    else{distancetime=minDistance/8+10;}

    reloadduration = distancetime.toInt();





      var duration = new Duration(seconds: reloadduration);
      return new Timer(duration,  mybigfunction);


  }







  @override
  @override
  Widget build(BuildContext context) {


    return Center(
      child: Stack(
          children: [
            BackgroundImage1(),
            Center(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Color.fromARGB(255, 153, 0, 0),
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Olduser()),)),
                  actions: [

                  ],

                  title: Text("Game On"),

                ),
                body: Form(

                  child:  SafeArea(
                      child: Column(
                          children: [
                            SizedBox(
                              //height: 250,
                              height: 200,

                            ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, R, G, B)),

                                onPressed: () async {

                                  if(kind=='Tagger' && minDistance<5 &&State!='blocked'){

                                    await FirebaseFirestore.instance.collection(RoomName)
                                        .where("identifier", isEqualTo: "GameStats")
                                        .get()
                                        .then((value) async {
                                        if (value != null) {
                                          statsTab = value.docs[0].data()["statsTab"];
                                          statsTab.add(myUsername+" has tagged"+minName );
                                          await FirebaseFirestore.instance.collection(RoomName).doc("GameStats").update({
                                            "statsTab":statsTab,
                                          }).catchError((e) {
                                            print(e.toString());
                                          });

                                        }

                                    });


                                          oldpoints=oldpoints+10;
                                          await FirebaseFirestore.instance.collection('users').doc(myUsername).update({
                                            "points":oldpoints,
                                          }).catchError((e) {
                                            print(e.toString());
                                          });


                                    gamepointsstring=await HelperFunctions.getpointsSharedPreference().toString();
                                    gamepoints=int.parse(gamepointsstring);
                                    gamepoints=gamepoints+10;
                                    await HelperFunctions.savepointsSharedPreference(gamepoints.toString());



                                  }
                                  if(kind=='Tagger' && minDistance>15 ){
                                    State='blocked';
                                    setState(() {R=174;G=0;B=0;});





                                  }






                                },


                                child: Text(text, style: TextStyle(color: Colors
                                    .white, fontSize: 25, fontWeight: FontWeight.w700
                                  ,),),


                              ),



                            ),




                            SizedBox(
                              height: 0
                              ,
                            ),


                            





                          ]
                      ),
                    ),
                  ),
                ),
              ),
            ]
      ),
    );
  }
  _getCurrentLocation() async {
    await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
    return _currentPosition;
}
}