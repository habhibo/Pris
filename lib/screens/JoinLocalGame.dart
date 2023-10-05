import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loginpage/models/locationmodel.dart';
import 'package:flutter_loginpage/shared/helperfunction.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';


class JoinLocalGame extends StatefulWidget {
  @override
  _JoinLocalGameState createState() => _JoinLocalGameState();

}

class _JoinLocalGameState extends State<JoinLocalGame> with WidgetsBindingObserver {
  Map<String, dynamic> userMap;
  bool isLoading = false;
  String error ='';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var myfriends = new List();
  String myUsername='';
  String RoomName ='';
  int i = 0;
  var localRoomsList = new List();
  int size =0;
  int size1 =0;
  var ListofRooms = new List();
  Position _currentPosition=null;
  String kind ='Tagger';
  String testkind ='';
  String lat = '0';
  String long = '0';
  String test = "1";
  Position position=null;
  List nameTab = new List();
  List distanceTab = new List();
  var currDt;
  List RealRealtab = new List();
  String Route = '';
  bool found;





  Future<void> location() async {
    position =await _getCurrentLocation();
    lat = position.latitude.toString();
    long =position.longitude.toString();

  }









  @override


  void initState() {

    listMaking();
  }


  Future<void>listMaking() async {
    print("aaaaaaaaaaaaaaaaa");
    location();
    myUsername = await HelperFunctions.getUserNameSharedPreference();
    await _firestore
        .collection("Local_Game_Rooms").where("identifier", isEqualTo : "Room")
        .get()
        .then((value) {
      setState(() {
        if (value != null) {
          size = value.size;
          for(int index = 0 ; index < size; index++){
            localRoomsList.add(value.docs[index].data()["RoomID"]);

          }
        }
      });
    });
    if(size==1){
      await FirebaseFirestore.instance.collection("Local_Game_Rooms").doc("Local_Room_1").set({
        "RoomID": "Local_Room_1",
        "identifier" : "Room",
      }).catchError((e) {
        print(e.toString());
      });

      await FirebaseFirestore.instance
          .collection('users')
          .where("userName", isEqualTo: myUsername)
          .get()
          .then((value) {

        if (value != null) {
          userMap = value.docs[0].data();}
      }
      );





      await FirebaseFirestore.instance.collection("Local_Room_1").doc(myUsername.toString()).set({
        "userName": userMap["userName"],
        "Locationlat": lat,
        "Locationlon" : long,
        "kind" : "Runner",
        "identifier" : "Player",
        "risk" :'',
        "Result" :'',
      }).catchError((e) {
        print(e.toString());
      });
      print("aaaaaaaaaaaaaaaaaaaaa");
      await FirebaseFirestore.instance.collection("Local_Room_1").doc("GameStats").set({
        "identifier" : "GameStats",
        "statsTab" : [],
      }).catchError((e) {
        print(e.toString());
      });
      currDt = DateTime.now();
      await HelperFunctions.savedaySharedPreference(currDt.day.toString());
      await HelperFunctions.savehourSharedPreference(currDt.hour.toString());
      await HelperFunctions.savemonthSharedPreference(currDt.month.toString());
      await FirebaseFirestore.instance.collection("Local_Room_1").doc("Time").set({
        "identifier" : "Time",
        "day" : currDt.day.toString(),
        "hour" : currDt.hour.toString(),
      }).catchError((e) {
        print(e.toString());
      });

      localRoomsList[0]="Local_Room_1";

      setState(()  {

        RealRealtab=localRoomsList;
      });


      Route = '1';
      print(RealRealtab);
      print(RealRealtab.length);

      print("bbbbbbbbbbbb");

    }
    else{ for(int index = 0 ; index < size; index++){
      if(localRoomsList[index]!="absolutRoom"){


        await FirebaseFirestore.instance
            .collection(localRoomsList[index]).where("identifier", isEqualTo : "Player")
            .get()
            .then((value) {
          setState(() {
            if (value != null) {
              nameTab.add(localRoomsList[index]);
              distanceTab.add(Geolocator.distanceBetween(double.parse(value.docs[0].data()["Locationlat"]), double.parse(value.docs[0].data()["Locationlon"]),double.parse(lat),double.parse(long)));



            }});
        });


      }

    }
    print("xxxxxxxxxxxxxxxxxxxxxxxx");
    for(int index = 0 ; index < size-1; index++){
      if(distanceTab[index]<5000){

        RealRealtab.add(nameTab[index]);
      }


    }
    if(RealRealtab.length==0){
      await FirebaseFirestore.instance.collection("Local_Game_Rooms").doc("Local_Room_1").set({
        "RoomID": "Local_Room_1",
        "identifier" : "Room",
      }).catchError((e) {
        print(e.toString());
      });

      await FirebaseFirestore.instance
          .collection('users')
          .where("userName", isEqualTo: myUsername)
          .get()
          .then((value) {

        if (value != null) {
          userMap = value.docs[0].data();}
      }
      );





      await FirebaseFirestore.instance.collection("Local_Room_"+((size).toString())).doc(myUsername.toString()).set({
        "userName": userMap["userName"],
        "Locationlat": lat,
        "Locationlon" : long,
        "kind" : "Runner",
        "identifier" : "Player",
        "risk" :'',
        "Result" :'',
      }).catchError((e) {
        print(e.toString());
      });
      print("yyyyyyyyyyyyyyyyyyy");
      await FirebaseFirestore.instance.collection("Local_Room_"+((size).toString())).doc("GameStats").set({
        "identifier" : "GameStats",
        "statsTab" : [],
      }).catchError((e) {
        print(e.toString());
      });
      currDt = DateTime.now();
      await HelperFunctions.savedaySharedPreference(currDt.day.toString());
      await HelperFunctions.savehourSharedPreference(currDt.hour.toString());
      await HelperFunctions.savemonthSharedPreference(currDt.month.toString());
      await FirebaseFirestore.instance.collection("Local_Room_"+((size).toString())).doc("Time").set({
        "identifier" : "Time",
        "day" : currDt.day.toString(),
        "hour" : currDt.hour.toString(),
      }).catchError((e) {
        print(e.toString());
      });

      localRoomsList[0]="Local_Room_"+(size).toString();
      setState(()  {

        RealRealtab=localRoomsList;
      });

      Route = '3';

      print("cccccccccccc");


    }
    else{Route = '2';}



    }




  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Color.fromARGB(255, 30, 30, 30),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 153, 0, 0),
        actions: [


        ],

        title: Text("join room"),

      ),
      body:ListView.builder(
          itemCount:RealRealtab.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
              child: Card(
                child: ListTile(
                  tileColor: Color.fromARGB(255, 169, 73, 73),
                  onTap: () async {
                    if(Route=='1'){

                      print("bbbbbbbbbbbbbbbbbb");
                      await HelperFunctions.saveRoomSharedPreference("Local_Room_1");
                      await HelperFunctions.savegameSharedPreference(true);
                      await FirebaseFirestore.instance.collection('users').doc(myUsername.toString()).update({
                        "Roomname": "Local_Room_1",
                      }).catchError((e) {
                        print(e.toString());
                      });
                      Navigator.of(context).pushNamed(
            'peopleintheroom', arguments: '');}

                    if(Route=='3'){
                    print("bbbbbbbbbbbbbbbbbb");
                    await HelperFunctions.savegameSharedPreference(true);
                    await FirebaseFirestore.instance.collection('users').doc(myUsername.toString()).update({
                      "Roomname": "Local_Room_"+((size).toString()),
                    }).catchError((e) {
                      print(e.toString());
                    });


                    await HelperFunctions.saveRoomSharedPreference("Local_Room_"+((size).toString()));}



                    else{print('°°°°°°°°°°°°');
                    await HelperFunctions.saveRoomSharedPreference(RealRealtab[index]);

                    await _firestore
                        .collection(RealRealtab[index])
                        .get()
                        .then((value) {
                      setState(() {
                        if (value != null) {
                          size1 = value.size;

                          testkind = value.docs[size1-1].data()["kind"];


                        }
                      });
                    });
                    print('aaaaaaaaaaaaaaaaaaa');
                    if(kind==testkind){kind='Runner';}
                    print(kind);
                    await FirebaseFirestore.instance.collection(RealRealtab[index]).doc(myUsername).set({
                      "userName": userMap["userName"],
                      "Locationlat": lat,
                      "Locationlon" : long,
                      "identifier" : "Player",
                      "kind" : kind,
                      "risk" :'',
                      "Result" :'',


                    }).catchError((e) {
                      print(e.toString());
                    });
                    await FirebaseFirestore.instance.collection('users').doc(myUsername.toString()).update({
                      "Roomname": RealRealtab[index],
                    }).catchError((e) {
                      print(e.toString());
                    });

                    await HelperFunctions.savegameSharedPreference(true);
                    Navigator.of(context).pushNamed(
                        'peopleintheroom', arguments: '');}




                  },
                  title: Text(RealRealtab[index]+"                          join game",style: TextStyle(color:Colors.white),textAlign: TextAlign.center,),



                ),

              ),
            );
          }
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