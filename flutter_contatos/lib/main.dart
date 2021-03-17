import 'package:flutter/material.dart';
import 'package:flutter_contatos/ui/home_page.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.blue,
      accentColor: Colors.blueAccent,
      fontFamily: 'Times New Roman'
    ),
  )
  );
}



