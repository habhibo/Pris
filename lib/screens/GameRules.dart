import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loginpage/models/user.dart';
import 'package:flutter_loginpage/screens/Checkyouremail.dart';
import 'package:flutter_loginpage/shared/helperfunction.dart';
import 'package:flutter_loginpage/widgets/BackgroundImage1.dart';
import 'package:flutter_loginpage/widgets/background-image.dart';
import 'package:provider/provider.dart';

import 'authenticate.dart';
import 'login-page.dart';

class GameRules extends StatefulWidget {


  _GameRulesState createState() => _GameRulesState();
}
class _GameRulesState  extends State<GameRules> {

  @override
  @override
  String text='';

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
  int stackhour;
  double showday;
  int showhour;
  String room;
  bool buttonbool;
  Map<String, dynamic> userMap;
  String myUsername;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<bool> listofbool = [false];


  initState() {

    isend();
  }

  Future<void> isend() async {
    listofbool[0]=await HelperFunctions.getLocalGameSharedPreference();
    myUsername = await HelperFunctions.getUserNameSharedPreference();
    await _firestore
        .collection('users')
        .where("userName", isEqualTo: myUsername)
        .get()
        .then((value) {
      setState(() {
        if (value != null) {
          userMap = value.docs[0].data();
          Roomname= userMap["Roomname"];
        }
      });
    });

    testgame=await HelperFunctions.getgameSharedPreference();
    testlog=await HelperFunctions.getUserLoggedInSharedPreference();

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
      else{varisend=false;
      }
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

    if(exist==false){
      setState(()  {

        text="No game exists";
      });
      }
    else {
      if(exist==true && varisend==false){
        stackhour=(intday+duration.toInt()-nowday)*24+inthour-nowhour-1;
        showday=(stackhour/24);
        showhour=stackhour%24;
        setState(()  {

          text=((showday.toInt()).toString()+" days and "+showhour.toString()+" hours");
        });
      }
      else{setState(()  {

        text="No game exists";
      });}
    }
  }



  Widget build(BuildContext context) {
    return  Stack(
          children: [
            BackgroundImage1(),
            Center(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Color.fromARGB(255, 153, 0, 0),


                  title: Text("Game Rules"),

                ),
                body:  SafeArea(
                      child: Column(
                          children: [
                            SizedBox(
                              height: 50
                              ,
                            ),

                            Container(margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),width: 500,height: 30,
                              child: Row(children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(Icons.album, size: 9,color: Colors.red,),
                                      ),

                                      TextSpan(
                                          text: ''' Enable local games :  
 ''',style: TextStyle(fontSize: 21,color: Colors.white)
                                      ),

                                    ],
                                  ),
                                ),
                                ToggleButtons(
                                  children: <Widget>[
                                    Icon(Icons.wifi_sharp,size: 20,color: Colors.white,),
                                  ],
                                  onPressed: (int index) async {
                                    buttonbool=await HelperFunctions.getLocalGameSharedPreference();

                                      if(buttonbool==true){

                                        setState(() {buttonbool=false;});
                                        listofbool[0]=buttonbool;
                                      await HelperFunctions.saveLocalGameSharedPreference(false);

                                      }
                                      else{
                                        setState(() {buttonbool=true;});
                                        listofbool[0]=buttonbool;
                                        await HelperFunctions.saveLocalGameSharedPreference(true);


                                      }
                                      print(buttonbool);


                                  },
                                  isSelected: listofbool,

                                ),
                              ]),),

                            Container(margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),width: 500,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(Icons.album, size: 9,color: Colors.red,),
                                    ),
                                    TextSpan(
                                      text: ''' Time left for the current game : 
    '''+ text,style: TextStyle(fontSize: 21,color: Colors.white)
                                    ),
                                  ],
                                ),
                              ),),

                              /*('''  Time left for the current game :
    '''+ text,style: TextStyle(fontSize: 21,color: Colors.white),), ),*/
                            Container(margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),width: 500,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(Icons.album, size: 9,color: Colors.red,),
                                  ),
                                TextSpan(
                                text: ''' Maximum players 10.

''',style: TextStyle(fontSize: 21,color: Colors.white, fontWeight: FontWeight.w500),),
                                  WidgetSpan(
                                    child: Icon(Icons.album, size: 9,color: Colors.red,),
                                  ),
                                  TextSpan(
                                    text: ''' When is game complete.''',style: TextStyle(fontSize: 21,color: Colors.white, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),),





                            /*Text(



                              '''  1. Maximum player 10.

  2. When is game complete.''',style: TextStyle(fontSize: 21,color: Colors.white),), ),*/

                            SizedBox(
                              height: 5
                              ,
                            ),
                            Container(margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(Icons.album, size: 9,color: Colors.yellow,),
                                    ),
                                    TextSpan(
                                      text: ''' After is everyone is tagged''',style: TextStyle(fontSize: 18,color: Colors.white, fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),width: 300, ),
                            SizedBox(
                              height: 3
                              ,
                            ),
                            Container(margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),

                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(Icons.album, size: 9,color: Colors.yellow,),
                                    ),
                                    TextSpan(
                                      text: ''' Time Limit:
    . 3 days
    . 7 days
    . 14 days
    . 21 days
    . 1 month''',style: TextStyle(fontSize: 18,color: Colors.white,fontWeight :FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),width: 300, ),





                          ]
                      ),
                    ),

                ),
              ),
            ]
      );

  }}