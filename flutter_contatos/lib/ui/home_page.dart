import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contatos/dao/contatoDAO.dart';
import 'package:flutter_contatos/entity/contato.dart';
import 'package:flutter_contatos/ui/contato_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContatoDAO contatoDao = ContatoDAO();
  List<Contato> contatos = List();

  void initState() {
    super.initState();
    updateList();
  }

  void updateList() {
    // Busca todos os contatos e muda o estado
    contatoDao.buscaTodosContatos().then((list) {
      setState(() => contatos = list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: contatos.length,
        itemBuilder: (context, index) {
          return _contatoCard(context, index);
        },
      ),
    );
  }

  Widget _contatoCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contatos[index].img != null
                          ? FileImage(File(contatos[index].img))
                          : AssetImage("Images/user.png")),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contatos[index].name ?? "",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contatos[index].email ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      contatos[index].phone ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
      onLongPress: () {
        _showImage(context, index);
      },
    );
  }

  void _showImage(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: contatos[index].img != null
                      ? FileImage(File(contatos[index].img))
                      : AssetImage("Images/user.png"),
                  fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            //onclose obrigatório. Não fará nada
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  //ocupa o mínimo de espaço.
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                            child: Text("ligar",
                                style: TextStyle(
                                    color: Colors.lightBlue, fontSize: 20.0)),
                            onPressed: () {
                              launch(
                                  "tel:${contatos[index].phone}"); //Para abrir a ligação Padrão do cell
                              Navigator.pop(context);
                            })),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                            child: Text("editar",
                                style: TextStyle(
                                    color: Colors.lightBlue, fontSize: 20.0)),
                            onPressed: () {
                              Navigator.pop(context);
                              _showContactPage(contato: contatos[index]);
                            })),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                            child: Text("excluir",
                                style: TextStyle(
                                    color: Colors.lightBlue, fontSize: 20.0)),
                            onPressed: () {
                              contatoDao.removerContato(contatos[index]
                                  .id); //Chama a func para remoção
                              updateList();
                              Navigator.pop(context);
                            }))
                  ],
                ),
              );
            },
          );
        });
  }

  void _showContactPage({Contato contato}) async {
    Contato contatoRet = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContatoPagina(contato: contato)));

    if (contatoRet != null) {
      print(contatoRet.id);
      if (contatoRet.id == null)
        await contatoDao.inserirContato(contatoRet);
      else
        await contatoDao.alterarContato(contatoRet);

      updateList();
    }
  }
}
