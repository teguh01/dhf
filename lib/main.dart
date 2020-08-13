import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:string_splitter/string_splitter.dart';

import 'sensor.dart';

Future<Album> fetchAlbum() async {
  final response = await http.get(
      'https://platform.antares.id:8443/~/antares-cse/antares-id/sendSuhu/suhu/la',
       headers: {"X-M2M-Origin": "access-id:access-password",
                "Content-Type": "application/json;ty=4",
                "Accept": "application/json", 
      }
    );
  if (response.statusCode == 200) {
    print(json.decode(response.body));
    print("berhasil");
    return Album.fromJson(json.decode(response.body));
  } else {
    print("gagal");
    throw Exception('Failed to load album');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Album> futureAlbum;

  setUpTimedFetch() {
    Timer.periodic(Duration(milliseconds: 5000), (timer) {
      setState(() {
        futureAlbum = fetchAlbum();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setUpTimedFetch();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(snapshot.data.suhu),
                  ]
                ),
              );
              }else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
