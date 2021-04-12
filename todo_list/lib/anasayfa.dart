import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/gorevEkle.dart';

class Anasayfa extends StatefulWidget {
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  //mevcut kullanıcı uid

  String mevcutKullaniciUid;

  @override
  void initState() {
    // TODO: implement initState
    mevcutKullaniciUidAl();
    super.initState();
  }

  mevcutKullaniciUidAl() async {
    //veritabanından uid yi al
    FirebaseAuth yetki = FirebaseAuth.instance;
    final FirebaseUser mevcutKullanici = await yetki.currentUser();

    setState(() {
      mevcutKullaniciUid = mevcutKullanici.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yapılacaklar"),
        actions: [
          IconButton(
            onPressed: () async{
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
          stream: Firestore.instance
              .collection("Gorevler")
              .document(mevcutKullaniciUid)
              .collection("Gorevlerim")
              .snapshots(),
          builder: (context, verilerim) {
            if (verilerim.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final alinanVeri = verilerim.data.documents;
              return ListView.builder(
                itemCount: alinanVeri.length,
                itemBuilder: (context, index) {
                  //eklenme zamani tutucu

                  var eklenmeZamani =
                      (alinanVeri[index]["tamZaman"] as Timestamp).toDate();
                  return Container(
                    margin: EdgeInsets.all(10.0),
                    height: 85,
                    decoration: BoxDecoration(
                      color: Color(0xFF36417F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                alinanVeri[index]["ad"],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                DateFormat.yMd()
                                    .add_jm()
                                    .format(eklenmeZamani)
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                alinanVeri[index]["sonTarih"],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () async {
                              await Firestore.instance
                                  .collection("Gorevler")
                                  .document(mevcutKullaniciUid)
                                  .collection("Gorevlerim")
                                  .document(
                                    alinanVeri[index]["zaman"],
                                  )
                                  .delete();
                            },
                            icon: Icon(Icons.delete, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF36417F),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => GorevEkle()),
          );
          //Görev ekleme sayfasına yönlendir
        },
      ),
    );
  }
}
