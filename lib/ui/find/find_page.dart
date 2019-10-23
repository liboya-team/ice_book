import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FindPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FindPageState();
  }

}

class _FindPageState extends State<FindPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(5),),
          ListTile(
            leading: Icon(Icons.book, color: Colors.blue,),
            title: Text("书源"),
            onTap: (){
              
            },
          ),
          ListTile(
            leading: Icon(Icons.format_list_numbered, color: Colors.deepOrange,),
            title: Text("排行"),
            onTap: (){

            },
          ),
          Padding(padding: EdgeInsets.all(5),),

        ],
      ),
    );
  }

}