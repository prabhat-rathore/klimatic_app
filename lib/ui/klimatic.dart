import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'package:http/http.dart' as http;
import 'dart:async';

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String _cityEntered;
  Future _goToNextScreen(BuildContext context) async{
    Map result=await Navigator.of(context).push(
      MaterialPageRoute<Map>(builder: (BuildContext){
        return Changecity();
      }),
    );
    if( result !=null && result.containsKey('info')){
      //print(result['info'].toString());
      _cityEntered=result['info'];
    }else{
      print("Nothing");
    }
  }
  void showStuff() async {
    Map data = await getWeather(util.apiId, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Klimatic",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed:(){_goToNextScreen(context);},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'images/umbrella.png',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: Text(
             '${_cityEntered==null ?util.defaultCity:_cityEntered}' ,
              style: cityStyle(),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset('images/light_rain.png'),
            // margin: const EdgeInsets.fromLTRB(30.0, 290.0, 0.0, 0.0),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30.0, 290.0, 0.0, 0.0),
            child: updateTempWidget(_cityEntered),
          ),
        ],
      ),
    );
  }

  Future<Map> getWeather(String apiId, String city) async {
    String apiUrl = "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util
        .apiId}&units=metric";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return FutureBuilder(
     future: getWeather(util.apiId, city==null ? util.defaultCity:city),
    builder: (BuildContext context,AsyncSnapshot<Map> snapshot){
    if(snapshot.hasData){
    Map content=snapshot.data;
    return Container(
    child:Column(
    children: <Widget>[
    ListTile(
    title: Text(content['main']['temp'].toString()+'C',
    style: TextStyle(color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 30.0),
    ),
    subtitle: ListTile(
      title: Text(
        "Humidity:${content['main']['humidity'].toString()}\n"
        "Min:${content['main']['temp_min'].toString()}C\n"
        "Max:${content['main']['temp_max'].toString()}C\n",
        style:datastyle() ,

    ),
    ),
    ),
    ],
    ) ,
    );
    }
    else
    {
    return Container();
    }
    });

    }

  }
  class Changecity extends StatelessWidget {
  var _cityFieldController= TextEditingController();
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Change city"),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: new Image.asset(
                'images/white_snow.png',
                width: 490.0,
                height: 1200.0,
                fit: BoxFit.fill,
              ),
            ),
            ListView(
              children: <Widget>[
                ListTile(
                  title: TextField(
                    decoration: InputDecoration(
                      hintText: "Enter City",
                    ),
                    controller: _cityFieldController,
                    keyboardType:TextInputType.text ,
                  ),
                ),
                ListTile(
                  title: FlatButton(
                      onPressed: (){
                        Navigator.pop(context,{
                          'info': _cityFieldController.text
                        });

                      },
                      textColor: Colors.white70,
                      color: Colors.redAccent,
                      child: Text('Get Weather'),),
                )
              ],
            )
          ],
        ),
      );
    }
  }


  tempStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: 22.9,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
    );
  }
  TextStyle datastyle(){
    return TextStyle(
      color: Colors.white,
      fontSize: 17.0,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
    );
  }

  TextStyle cityStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: 20.5,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
    );
  }
