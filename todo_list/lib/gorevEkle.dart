import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GorevEkle extends StatefulWidget {
  @override
  _GorevEkleState createState() => _GorevEkleState();
}

class _GorevEkleState extends State<GorevEkle> {
  TextEditingController adAlici = TextEditingController();
  TextEditingController tarihAlici = TextEditingController();

  verileriEkle() async {
    FirebaseAuth yetki = FirebaseAuth.instance;
    final FirebaseUser mevcutKullanici = await yetki.currentUser();
    String uidTutucu = mevcutKullanici.uid;
    var zamanTutucu = DateTime.now();

    await Firestore.instance
        .collection("Gorevler")
        .document(uidTutucu)
        .collection("Gorevlerim")
        .document(zamanTutucu.toString())
        .setData({
      "ad": adAlici.text,
      "sonTarih": tarihAlici.text,
      "zaman": zamanTutucu.toString(),
      "tamZaman": zamanTutucu
    });

    Fluttertoast.showToast(msg: "Görev Başarıyla Eklendi");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Görev Ekle"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: adAlici,
              decoration: InputDecoration(
                labelText: "Görev Adı",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: tarihAlici,
              decoration: InputDecoration(
                labelText: "Son Tarihi",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Firebaseye Ekleyecek
              verileriEkle();
            },
            child: Text("Görev Ekle"),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF36417F),
            ),
          )
        ],
      ),
    );
  }
}
