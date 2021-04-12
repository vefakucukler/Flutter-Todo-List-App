import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class KayitFormu extends StatefulWidget {
  @override
  _KayitFormuState createState() => _KayitFormuState();
}

bool kayitDurumu = false;
String kullaniciAdi, email, sifre;

class _KayitFormuState extends State<KayitFormu> {
  

  var dogrulamaAnahtari = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: dogrulamaAnahtari,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                height: 120,
                child: Image.asset("images/todo.png.png"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.center,
              child: Text("TODO LİST"),
            ),
            if (!kayitDurumu)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (alinanAd) {
                    kullaniciAdi = alinanAd;
                  },
                  validator: (alinanAd) {
                    return alinanAd.isEmpty
                        ? "Kullanıcı Adı boş bırakılamaz"
                        : null;
                  },
                  decoration: InputDecoration(
                    labelText: "Kullanıcı Adı Giriniz",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (alinanEmail) {
                  email = alinanEmail;
                },
                validator: (alinanEmail) {
                  return alinanEmail.contains("@") ? null : "Geçersiz Email";
                },
                decoration: InputDecoration(
                  labelText: "Email Giriniz",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: true,
                onChanged: (alinanSifre) {
                  sifre = alinanSifre;
                },
                validator: (alinanSifre) {
                  return alinanSifre.length >= 6
                      ? null
                      : "En az 6 Karakter girin";
                },
                decoration: InputDecoration(
                  labelText: "Şifre Giriniz",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                child: ElevatedButton(
                  child: kayitDurumu ? Text("Giriş Yap") : Text("Kaydol"),
                  onPressed: () {
                    kayitEkle();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF36417F),
                    shadowColor: Colors.black,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  kayitDurumu = !kayitDurumu;
                });
              },
              child: kayitDurumu
                  ? Text(
                      "Hesabım yok",
                    )
                  : Text(
                      "Zaten Hesabım Var",
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void kayitEkle() {
    if (dogrulamaAnahtari.currentState.validate()) {
      formuTeslimEt(kullaniciAdi, email, sifre);
    }
  }
}

formuTeslimEt(String kullaniciAdi, String email, String sifre) async {
  final yetki = FirebaseAuth.instance;
  AuthResult yetkiSonucu;
// kayıt durumu true ise giriş yapacak
  if (kayitDurumu) {

    yetkiSonucu = await yetki.signInWithEmailAndPassword(
        email: email, password: sifre);
  }
  // kayıt durumu false ise kayıt olacak
  else {
    yetkiSonucu = await yetki.createUserWithEmailAndPassword(
        email: email, password: sifre);

        String uidTutucu = yetkiSonucu.user.uid;

        await Firestore.instance.collection("Kullanicilar").document(uidTutucu).setData({
          "kullaniciAdi":kullaniciAdi,"email":email,
        });
  }
}
