import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {
  const TextComposer({Key? key}) : super(key: key);

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  bool _temTexto = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
              onPressed: (){
                
              },
              icon: Icon(Icons.photo_camera),
          ),
          Expanded(
              child: TextField(
                decoration: InputDecoration.collapsed(hintText: 'Enviar uma Mensagem'),
                onChanged: (text){
                  setState(() {
                    _temTexto = text.isNotEmpty;
                  });
                },
                onSubmitted: (text){

                },
              ),
          ),
          IconButton(
              onPressed: _temTexto?(){

              } : null,
              icon: Icon(Icons.send),

          ),
        ],
      ),
    );
  }
}
