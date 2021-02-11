import 'package:flutter/material.dart';
import 'package:flutter_bovespa/ui/result.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';

const request = "";
// https://api.hgbrasil.com/finance/stock_price?key=21692bfc&symbol=bidi4

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.orange, primaryColor: Colors.orange),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController codigoController = TextEditingController();

  String dropdownValue = 'SLED3';

  void _resetCampos() {
    codigoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Consulta IBOVESPA"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(Icons.money, size: 150.0, color: Colors.orange),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Abreviação da empresa",
                      labelStyle: TextStyle(color: Colors.amber),
                      border: OutlineInputBorder()
                      ),
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  controller: codigoController,
                  validator: (value){
                    if(value.isEmpty) return "Insira uma empresa!";
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Result(codigoController.text.toUpperCase())));
                  },
                  color: Colors.orange,
                  textColor: Colors.white,
                  child: Text(
                    "Ver Dados",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ])),
    );
  }
}
