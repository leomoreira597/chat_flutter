import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {
  TextComposer(this.enviarMensagem);
  Function(String) enviarMensagem;


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
              onPressed: (){
                
              },
              icon: Icon(Icons.photo_camera),
          ),
          Expanded(
              child: TextField(
                controller: _controler,
                decoration: InputDecoration.collapsed(hintText: 'Enviar uma Mensagem'),
                onChanged: (text){
                  setState(() {
                    _temTexto = text.isNotEmpty;
                  });
                },
                onSubmitted: (text){
                  widget.enviarMensagem(text);
                  _reseta();
                },
              ),
          ),
          IconButton(
              onPressed: _temTexto?(){
                widget.enviarMensagem(_controler.text);
                _reseta();
              } : null,
              icon: Icon(Icons.send),

          ),
        ],
      ),
    );
  }
}
