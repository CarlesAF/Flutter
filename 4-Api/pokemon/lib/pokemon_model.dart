// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'dart:async';

class Digimon {
  final String name;
  String? imageUrl;
  String? apiname;
  String? levelDigimon;

  int rating = 10;

  Digimon(this.name);

  Future getImageUrl() async {
    if (imageUrl != null) {
      return;
    }

    HttpClient http = HttpClient();
    try {
      apiname = name.toLowerCase();

      var uri = Uri.https('digimon-api.vercel.app', '/api/digimon/name/$apiname');
      var request = await http.getUrl(uri);
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();

      List data = json.decode(responseBody);
      imageUrl = data[0]["img"];
      levelDigimon = data[0]["level"];

      //print(levelDigimon);
    } catch (exception) {
      //print(exception);
    }
  }
}
