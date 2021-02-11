import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//
Future<Map> getData(String cod) async {
  String request =
      "https://api.hgbrasil.com/finance/stock_price?key=21692bfc&symbol=$cod";
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Result extends StatelessWidget {
  String dropdownValue;
  Result(this.dropdownValue);

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("$dropdownValue"),
          backgroundColor: Colors.orange,
        ),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FutureBuilder<Map>(
              future: getData(dropdownValue),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(
                        child: SingleChildScrollView(
                      padding: EdgeInsets.all(10),
                      child: LoadingBouncingGrid.square(
                        borderColor: Colors.orange,
                        backgroundColor: Colors.orange,
                        size: 300,
                      ),
                    ));
                  default:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Erro ao carregar os dados...",
                            style: TextStyle(color: Colors.red, fontSize: 25)),
                      );
                    } else {
                      String name =
                          snapshot.data["results"][dropdownValue]["name"];
                      String name_company = snapshot.data["results"]
                          [dropdownValue]["company_name"];
                      String description = snapshot.data["results"]
                          [dropdownValue]["description"];
                      double price =
                          snapshot.data["results"][dropdownValue]["price"];
                      double change_percent = snapshot.data["results"]
                          [dropdownValue]["change_percent"];
                      return SingleChildScrollView(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              buildTextFormField("Nome", name_company),
                              Divider(),
                              buildTextFormField("Abreviação", name),
                              Divider(),
                              buildTextFormField("Descrição", description),
                              Divider(),
                              buildTextFormField("Preço", price.toString()),
                              Divider(),
                              buildTextFormField("Variação", change_percent.toString())
                            ],
                          ));
                    }
                }
              },
            )
          ],
        ));
  }

  Widget buildTextFormField(String label, String prefix) {
    return TextField(
        style: TextStyle(color: Colors.orange, fontSize: 25),
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.orange),
            border: OutlineInputBorder(),
            prefixText: "$prefix"),
          //autofocus: true,
          readOnly: true,
      );
  }
}
