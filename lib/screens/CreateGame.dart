import 'package:flutter/material.dart';
import 'package:flutter_loginpage/models/locationmodel.dart';
import 'package:flutter_loginpage/models/user.dart';
import 'package:flutter_loginpage/screens/Checkyouremail.dart';
import 'package:flutter_loginpage/shared/helperfunction.dart';
import 'package:flutter_loginpage/widgets/BackgroundImage1.dart';
import 'package:flutter_loginpage/widgets/background-image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'authenticate.dart';
import 'login-page.dart';

class CreateGame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateGameState();
  }
}
class CreateGameState extends State<CreateGame> {
  get userData => null;
  String myUsername;
  Map<String, dynamic> userMap;
  Position _currentPosition=null;
  String lat = '0';
  String long = '0';
  Position position=null;
  String tt;
  var currDt;
  String codeDialog ='';
  String valueText ='';
  TextEditingController _textFieldController = TextEditingController();



  void initState(){

    location();

  }

  Future<void> location() async {
    position =await _getCurrentLocation();
    lat = position.latitude.toString();
    long =position.longitude.toString();

  }
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Phone Alert'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Choose a name for the room"),
            ),
            actions: <Widget>[

              FlatButton(
                color: Colors.red,
                textColor: Colors.black,
                child: Text('Confirm'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
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


                  title: Text("Create Room"),

                ),
                body: SingleChildScrollView(
                  child: Form(


                      child: SafeArea(
                        child: Column(
                            children: [
                              SizedBox(
                                height: 215
                                ,
                              ),
                              FlatButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 97),

                                shape: StadiumBorder(),
                                onPressed: () async {
                                  myUsername = await HelperFunctions.getUserNameSharedPreference();
                                  print(myUsername);

                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .where("userName", isEqualTo: myUsername)
                                      .get()
                                      .then((value) {

                                      if (value != null) {
                                        userMap = value.docs[0].data();}
                                      }
                                   );
                                  currDt = DateTime.now();
                                  await HelperFunctions.savedaySharedPreference(currDt.day.toString());
                                  await HelperFunctions.savehourSharedPreference(currDt.hour.toString());
                                  await HelperFunctions.savemonthSharedPreference(currDt.month.toString());
                                  print("bbbbbbbbbbbbbbbbbb");

                                  await _displayTextInputDialog(context);
                                  await HelperFunctions.saveRoomSharedPreference(valueText);




                                  await FirebaseFirestore.instance.collection(valueText).doc(myUsername.toString()).set({
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
                                  await FirebaseFirestore.instance.collection(valueText).doc("GameStats").set({
                                    "identifier" : "GameStats",
                                    "statsTab" : [],
                                  }).catchError((e) {
                                    print(e.toString());
                                  });
                                  await FirebaseFirestore.instance.collection(valueText).doc("Time").set({
                                    "identifier" : "Time",
                                    "day" : currDt.day.toString(),
                                    "hour" : currDt.hour.toString(),
                                  }).catchError((e) {
                                    print(e.toString());
                                  });
                                  await HelperFunctions.savegameSharedPreference(true);

                                  print("cccccccccccccccccc");
                                  await FirebaseFirestore.instance.collection('users').doc(myUsername.toString()).update({
                                    "Roomname": valueText,
                                  }).catchError((e) {
                                    print(e.toString());
                                  });


                                  tt=await HelperFunctions.getRoomSharedPreference();
                                  print(tt);
                                  Navigator.of(context).pushNamed(
                                      'SetDate', arguments: '');



                                  },
                                    child: Text('Create Room', style: TextStyle(color: Colors
                                        .white, fontSize: 25, fontWeight: FontWeight.w700
                                      ,),),
                                    color: Colors.red[800],

                                  ),
                              SizedBox(
                                height: 30
                                ,
                              ),
                                  FlatButton(
                                  padding: EdgeInsets.symmetric(

                              vertical: 10, horizontal: 97),

                          shape: StadiumBorder(),
                          onPressed: () async {Navigator.of(context).pushNamed(
                              'GameRules', arguments: '');




                          },
                          child: Text('Game Rules', style: TextStyle(color: Colors
                              .white, fontSize: 25, fontWeight: FontWeight.w700
                            ,),),
                          color: Colors.red[800],

                        ),

                              SizedBox(
                                height: 20
                                ,
                              ),
                              Center(
                              ),





                            ]
                        ),
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