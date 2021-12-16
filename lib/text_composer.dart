import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  TextComposer(this.enviarMensagem);
  final Function({String text, XFile imgFile}) enviarMensagem;


  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final TextEditingController _controler = TextEditingController();

  bool _temTexto = false;

  void _reseta(){
    _controler.clear();
    setState(() {
      _temTexto = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8  ),
      child: Row(
        children: [
          IconButton(
              onPressed: () async{
               final XFile? imgFile = await ImagePicker().pickImage(source: ImageSource.camera);
               if(imgFile == null){
                 return;
               }
               else{
                  widget.enviarMensagem(imgFile: imgFile);
               }
              },
              icon: const Icon(Icons.photo_camera),
          ),
          Expanded(
              child: TextField(
                controller: _controler,
                decoration: const InputDecoration.collapsed(hintText: 'Enviar uma Mensagem'),
                onChanged: (text){
                  setState(() {
                    _temTexto = text.isNotEmpty;
                  });
                },
                onSubmitted: (text){
                  widget.enviarMensagem(text:text);
                  _reseta();
                },
              ),
          ),
          IconButton(
              onPressed: _temTexto?(){
                widget.enviarMensagem(text: _controler.text);
                _reseta();
              } : null,
              icon: Icon(Icons.send),

          ),
        ],
      ),
    );
  }
}
