import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/anasayfa.dart';
import 'package:todo_list/kayitEkrani.dart';

void main() {
  runApp(Yapilacaklar());
}

class Yapilacaklar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF36417F),
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context,kullaniciVerisi){
          if(kullaniciVerisi.hasData){
            return Anasayfa();
          }
          else{
            return KayitEkrani();
          }
        },),
    );
  }
}
