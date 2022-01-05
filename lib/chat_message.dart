import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  //const ({Key? key}) : super(key: key);
  ChatMessage(this.data, this.mine);

  final Map<String, dynamic> data;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          !mine ?
          Padding(padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(data['senderPhotoUrl']),
          ),
          ) : Container(),
          Expanded(
              child: Column(
                crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  data['imgFile'] != null ? Image.network(data['imgFile'], width: 250,) :
                      Text(
                        data['text'],
                        textAlign: mine ? TextAlign.end : TextAlign.start,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                  Text(
                    data['senderName'],
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
          ),
          mine ?
          Padding(padding: const EdgeInsets.only(left: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data['senderPhotoUrl']),
            ),
          ) : Container(),
        ],
      ),
    );
  }
}
