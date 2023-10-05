import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loginpage/models/locationmodel.dart';
import 'package:flutter_loginpage/shared/helperfunction.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';


class joinroom extends StatefulWidget {
  @override
  _joinroomState createState() => _joinroomState();

}

class _joinroomState extends State<joinroom> with WidgetsBindingObserver {
  Map<String, dynamic> userMap;
  bool isLoading = false;
  String error ='';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var myfriends = new List();
  String myUsername='';
  String RoomName ='';
  int i = 0;
  var peopleintherome = new List();
   int size =0;
  var ListofRooms = new List();
  Position _currentPosition=null;
  String kind ='Tagger';
  String testkind ='';
  String lat = '0';
  String long = '0';
  String test = "1";
  Position position=null;




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
        .collection('users')
        .where(
        "userName", isEqualTo: myUsername)
        .get()
        .then((value) async {

      if (value != null) {
        print(")))))))))))))))))))");
        userMap = value.docs[0].data();
        RoomName= userMap["game_requests"];
        ListofRooms.add(RoomName);

        print("bbbbbbbbbbbbbb");

      }

    },);
    print(ListofRooms[0]);
    if(ListofRooms[0]==null){ListofRooms[0]='0';}
    print("cccccccccc");

    print(ListofRooms);






    if(ListofRooms[0]=='0'){
      print('a');
      Navigator.of(context).pushNamed(
          'empty', arguments: '');

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
          itemCount:ListofRooms.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
              child: Card(
                child: ListTile(
                  tileColor: Color.fromARGB(255, 169, 73, 73),
                  onTap: () async {
                    await FirebaseFirestore.instance
                        .collection(ListofRooms[index]).where("identifier", isEqualTo : "Player")
                        .get()
                        .then((value) {
                      setState(() {
                        if (value != null) {
                          size = value.size;
                        }
                      });
                    });
                    if(size<10){

                    print('°°°°°°°°°°°°');
                    await _firestore
                        .collection(RoomName)
                        .get()
                        .then((value) {
                      setState(() {
                        if (value != null) {
                          size = value.size;

                          testkind = value.docs[size-1].data()["kind"];


                        }
                      });
                    });
                    print('aaaaaaaaaaaaaaaaaaa');
                    if(kind==testkind){kind='Runner';}
                    print(kind);
                    await FirebaseFirestore.instance.collection(RoomName).doc(myUsername).set({
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
                    ListofRooms.removeAt(0);
                    await FirebaseFirestore.instance.collection("users")
                        .doc(myUsername).update({
                      "game_requests": ListofRooms,
                    }).catchError((e) {
                      print(e.toString());
                    });
                    await HelperFunctions.savegameSharedPreference(true);
                    await HelperFunctions.saveRoomSharedPreference(RoomName);
                    await FirebaseFirestore.instance.collection('users').doc(myUsername.toString()).update({
                      "Roomname": RoomName,
                    }).catchError((e) {
                      print(e.toString());
                    });
                    Navigator.of(context).pushNamed(
                        'peopleintheroom', arguments: '');}
                    else{

                      showDialog(context: context, builder: (context){

                        return AlertDialog(title:Text('Phone Alert'),content: Text("The room is full" ),actions: [FlatButton(onPressed: ()  {


                        }, child: Text('Continue'))],);
                      });







                    }



                  },
                  title: Text(ListofRooms[index]+"                          join game",style: TextStyle(color:Colors.white),textAlign: TextAlign.center,),



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


