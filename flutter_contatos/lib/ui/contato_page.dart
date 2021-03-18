import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contatos/entity/contato.dart';
import 'package:image_picker/image_picker.dart';

class ContatoPagina extends StatefulWidget {
  Contato contato;

  ContatoPagina({this.contato});

  @override
  _ContatoPaginaState createState() => _ContatoPaginaState();
}

class _ContatoPaginaState extends State<ContatoPagina> {
  Contato _contatoEditado;
  bool _usuarioEditou;

  final _nomeFocus = FocusNode();

  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  void initState() {
    super.initState();
    if (widget.contato == null) {
      // Se n estiver criado, crie um
      _contatoEditado = Contato();
    } else {
      _contatoEditado = Contato.fromMap(widget.contato.toMap());
      nomeController.text = _contatoEditado.name;
      emailController.text = _contatoEditado.email;
      phoneController.text = _contatoEditado.phone;
    }
  }

  Future<bool> _requestPop() {
    if (_usuarioEditou != null && _usuarioEditou) {
      showDialog(
          context: context,
          builder: (context) {
            // Alerta para caso o usuário saia sem salvar
            return AlertDialog(
              title: Text("Abandonar alteração?"),
              content: Text("Os dados serão perdidos."),
              actions: <Widget>[
                FlatButton(
                    child: Text("cancelar"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                FlatButton(
                  child: Text("sim"),
                  onPressed: () {
                    //desempilha 2x
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    } else {
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(_contatoEditado.name ?? "Novo contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_contatoEditado.name != null &&
                _contatoEditado.name.isNotEmpty) {
              Navigator.pop(context, _contatoEditado);
            } else {
              FocusScope.of(context).requestFocus(_nomeFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _contatoEditado.img != null
                              ? FileImage(File(_contatoEditado.img))
                              : AssetImage("Images/user.png"))),
                ),
                onTap: () {
                  _escolherImagem();
                  // ImagePicker()
                  //     .getImage(source: ImageSource.camera)
                  //     .then((file) {
                  //   if (file == null) {
                  //     return;
                  //   } else {
                  //     setState(() {
                  //       _contatoEditado.img = file.path;
                  //     });
                  //   }
                  // });
                },
              ),
              TextField(
                controller: nomeController,
                focusNode: _nomeFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _usuarioEditou = true;
                  setState(() {
                    _contatoEditado.name = text;
                  });
                },
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "E-mail"),
                onChanged: (text) {
                  _usuarioEditou = true;
                  _contatoEditado.email = text;
                },
              ),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: "Telefone"),
                onChanged: (text) {
                  _usuarioEditou = true;
                  _contatoEditado.phone = text;
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _escolherImagem() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(       
            insetPadding: EdgeInsets.all(10),     
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SimpleDialogOption(
                    child: Text("Câmera", style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      ImagePicker()
                          .getImage(source: ImageSource.camera)
                          .then((file) {
                        if (file == null) {
                          return;
                        } else {
                          setState(() {
                            _contatoEditado.img = file.path;
                          });
                        }
                      });
                      _usuarioEditou = true;
                    },
                  ),
                  Divider(
                    color: Colors.blue,
                  ),
                  SimpleDialogOption(
                    child: Text("Escolher da Galeria", style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      ImagePicker()
                          .getImage(source: ImageSource.gallery)
                          .then((file) {
                        if (file == null) {
                          return;
                        } else {
                          setState(() {
                            _contatoEditado.img = file.path;
                          });
                        }
                      });
                      _usuarioEditou = true;
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }
}
