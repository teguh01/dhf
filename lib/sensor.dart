class Album {
  final String suhu;

  Album({this.suhu});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      suhu: json['m2m:cin']['con'],
    );
  }
}