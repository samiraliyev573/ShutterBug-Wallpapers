import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wallpaperApp/data/data.dart';
import 'package:wallpaperApp/homescreen.dart';
import 'package:wallpaperApp/views/artists_page.dart';

import 'package:wallpaperApp/views/drawer_3d.dart';
import 'package:wallpaperApp/views/feedback_screen.dart';

import 'package:wallpaperApp/views/categories.dart';
import 'package:wallpaperApp/views/instructionpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Color(0xFFbae8e8), fontFamily: 'Circular'),
      title: 'Wallpaper App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Drawer3D(),
        '/explore': (context) => ExploreArtists(),
        '/feedback': (context) => FeedbackScreen(),
        '/categories': (context) => Categories(),
        '/homepage': (context) => HomePage()
      },
    );
  }
}
