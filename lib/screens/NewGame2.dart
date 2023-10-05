import 'package:flutter/material.dart';
import 'package:flutter_loginpage/models/user.dart';
import 'package:flutter_loginpage/screens/Checkyouremail.dart';
import 'package:flutter_loginpage/shared/helperfunction.dart';
import 'package:flutter_loginpage/widgets/BackgroundImage1.dart';
import 'package:flutter_loginpage/widgets/background-image.dart';
import 'package:provider/provider.dart';

import 'authenticate.dart';
import 'login-page.dart';

class NewGame2 extends StatelessWidget {
  @override
  @override
  bool buttoncheck;
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



                  title: Text("New Game"),

                ),
                body: Form(

                  child:
                  SafeArea(
                    child: Column(
                        children: [
                          SizedBox(
                            height: 215
                            ,
                          ),
                          FlatButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 33),
                            shape: StadiumBorder(),
                            onPressed: () async {
                              Navigator.of(context).pushNamed(
                                  'joinroom', arguments: '');



                            },
                            child: Text('Join Game With Friends', style: TextStyle(color: Colors
                                .white, fontSize: 25, fontWeight: FontWeight.w700
                              ,),),
                            color: Colors.red[800],

                          ),
                          SizedBox(
                            height: 30
                            ,
                          ),
                          Center(
                            child: FlatButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 70),

                              shape: StadiumBorder(),
                              onPressed: () async {
                                buttoncheck=await HelperFunctions.getLocalGameSharedPreference();
                                if(buttoncheck==true){Navigator.of(context).pushNamed(
                                    'JoinLocalGame',arguments: '');}

                              },
                              child: Text('Join Local Game', style: TextStyle(color: Colors
                                  .white, fontSize: 25, fontWeight: FontWeight.w700
                                ,),),
                              color: Colors.red[800],

                            ),
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
  }}