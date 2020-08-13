import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

class Album {
  final String suhu;

  Album({this.suhu});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      suhu: json['m2m:cin']['con']['temperature'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Album> futureAlbum;

  setUpTimedFetch() {
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
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
              if (snapshot.hasData) {
                return Text(snapshot.data.suhu);
              } else if (snapshot.hasError) {
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
