import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:undraw/illustrations.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Fetch the illustration from the web
Future<String> _getFromWeb(String location) async {
  final uri = Uri.parse(location);
  final response = await http.get(uri);
  return response.body;
}

// Get the illustration from the shared preferences or from the web
Future<String> _getIllustration(String location) async {
  final prefs = await SharedPreferences.getInstance();
  final fromPrefs = prefs.getString(location) ?? '';
  if (fromPrefs.isNotEmpty) {
    return fromPrefs;
  }

  final fromWeb = await _getFromWeb(location);
  if (fromWeb.isNotEmpty) {
    prefs.setString(location, fromWeb);
    return fromWeb;
  }

  throw Exception('Illustration cloud not be fetched');
}

// Convert a color to a hex string
String _colorToHex(Color color, {bool leadingHashSign = true}) =>
    '${leadingHashSign ? '#' : ''}'
    '${color.red.toRadixString(16).padLeft(2, '0')}'
    '${color.green.toRadixString(16).padLeft(2, '0')}'
    '${color.blue.toRadixString(16).padLeft(2, '0')}';

// Get the illustration with the accent color
Future<String> getTintedIllustration(
  UnDrawIllustration illustration,
  Color accent,
) async {
  final location = illustrationMap[illustration]!;

  // Fetch the illustration
  String svg = await _getIllustration(location);

  // Replace the default color with the accent color
  svg = svg.replaceAll("#6c63ff", _colorToHex(accent));

  return svg;
}
