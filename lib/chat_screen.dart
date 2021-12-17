import 'package:chat_flutter/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User? _currentUser;

    @override
  void initState() {
      super.initState();
      FirebaseAuth.instance.authStateChanges().listen((user) {
        _currentUser = user;
      });
  }

  Future<User?> _getUser() async{
      if(_currentUser != null){
        return _currentUser;
      }
      else {
        try {
          final GoogleSignInAccount? googleSignInAccount = await googleSignIn
              .signIn();
          final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!
              .authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken,
          );
          final UserCredential userCredential = await FirebaseAuth.instance
              .signInWithCredential(credential);
          final User? user = userCredential.user;
          return user;
        }
        catch (error) {
              return null;
        }
      }
  }

  void _enviarMensagem({String? text, XFile? imgFile}) async {
    final User? user = await _getUser();
    // final snack = const SnackBar(content:
    //   Text('Não foi possivel fazer o login!! Tente novamente!!'),
    //   backgroundColor: Colors.red,
    // );

    if(user == null){
      _scaffoldKey.currentState!;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Não foi possivel fazer o login!! Tente novamente!!'),
            backgroundColor: Colors.red,
        )
      );
    }

    Map<String, dynamic> data = {
      "uid": user!.uid,
      "senderName": user!.displayName,
      "senderPhotoUrl": user.photoURL,

    };

    if(imgFile != null){
      File file = File(imgFile.path);
      UploadTask task = FirebaseStorage.instance.ref().child(
        DateTime.now().millisecondsSinceEpoch.toString()
      ).putFile(file);
      TaskSnapshot taskSnapshot = await task;
      String url = await taskSnapshot.ref.getDownloadURL();
      data['file'] = url;
    }
    if(text!= null){
      data['text'] = text;
    }

    await Firebase.initializeApp();
    FirebaseFirestore.instance.collection('mensagem').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Olá"),
        elevation: 0,
      ),
      body: Column (
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('mensagem').snapshots(),
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                    default:
                      List<DocumentSnapshot> documents = snapshot.data!.docs.reversed.toList();

                      return ListView.builder(
                          itemCount: documents.length,
                          reverse: true,
                          itemBuilder: (context, index){
                            return ListTile(
                              title: Text(
                                documents[index].get('text'),
                              ),
                            );
                          }
                      );
                }
              },
            ),
          ),
          TextComposer(
              _enviarMensagem
          ),
        ],
      ),
    );
  }
}
