import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:undraw/illustrations.g.dart';

final _cache = <String, String>{};

Future<String> _fetchFromWeb(String location) async {
  final uri = Uri.parse(location);
  final response = await http.get(uri);
  return response.body;
}

String _colorToHex(Color color, {bool leadingHashSign = true}) =>
    '${leadingHashSign ? '#' : ''}'
    '${color.red.toRadixString(16).padLeft(2, '0')}'
    '${color.green.toRadixString(16).padLeft(2, '0')}'
    '${color.blue.toRadixString(16).padLeft(2, '0')}';

Future<String> getTintedIllustration(
  UnDrawIllustration illustration,
  Color accent,
) async {
  final location = illustrationMap[illustration]!;

  String svg;
  if (_cache.containsKey(location)) {
    svg = _cache[location]!;
  } else {
    svg = await _fetchFromWeb(location);
    _cache[location] = svg;
  }

  // Replace the default color with the accent color
  svg = svg.replaceAll("#6c63ff", _colorToHex(accent));

  return svg;
}
