import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import 'package:undraw/illustrations.g.dart';

final _cache = <String, String>{};

Future<String> _fetchFromWeb(String location) async {
  final uri = Uri.parse(location);
  final response = await http.get(uri);
  return response.body;
}

Future<String> getTintedIllustration(
  UnDrawIllustration illustration,
  Color accent,
) async {
  final location = illustrationMap[illustration]!;

  String image;

  if (_cache.containsKey(location)) {
    image = _cache[location]!;
  } else if (location.startsWith("http")) {
    image = await _fetchFromWeb(location);
    _cache[location] = image;
  } else {
    String path = "packages/undraw/assets/$location";
    image = await rootBundle.loadString(path);
    _cache[location] = image;
  }

  String valueString = accent.toString().split('(0x')[1].split(')')[0];
  valueString = valueString.substring(2, valueString.length);
  image = image.replaceAll("#6c63ff", "#$valueString");

  return image;
}
