import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    home: AdamAsmacaOyunu(),
  ));
}

class AdamAsmacaOyunu extends StatefulWidget {
  @override
  _AdamAsmacaOyunuState createState() => _AdamAsmacaOyunuState();
}

class _AdamAsmacaOyunuState extends State<AdamAsmacaOyunu> {
  List<String> kelimeler = ["biriktir", "flutter", "mobile", "development"];
  String kelime = "";
  List<String> tahminler = [];
  int yanlisTahminler = 0;
  int maxTahminHakki = 6;
  TextEditingController tahminController = TextEditingController();
  bool oyunBitti = false;

  @override
  void initState() {
    super.initState();
    kelime = getRandomKelime();
  }

  @override
  void dispose() {
    tahminController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Adam Asmaca Oyunu'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Tahmin edilen kelime: ${getKelimeDurumu()}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                'Yanlış tahminler: ${yanlisTahminler.toString()} / ${maxTahminHakki.toString()}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              if (yanlisTahminler > 0) buildAdam(),
              SizedBox(height: 20),
              TextField(
                controller: tahminController,
                onChanged: (value) {
                  setState(() {
                    if (!oyunBitti && value.length == 1) {
                      tahminYap(value);
                      tahminController.clear();
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Harf tahmini yapın',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    kelime = getRandomKelime(); // Yeni kelime için rastgele bir kelime seçilir
                    resetOyunu();
                  });
                },
                child: Text('Yeni Kelime'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getRandomKelime() {
    Random random = Random();
    int randomIndex = random.nextInt(kelimeler.length);
    return kelimeler[randomIndex];
  }

  String getKelimeDurumu() {
    String durum = '';
    for (int i = 0; i < kelime.length; i++) {
      if (tahminler.contains(kelime[i])) {
        durum += kelime[i];
      } else {
        durum += '_';
      }
      durum += ' ';
    }
    return durum;
  }

  void tahminYap(String harf) {
    if (!tahminler.contains(harf)) {
      tahminler.add(harf);
      if (!kelime.contains(harf)) {
        yanlisTahminler++;
        if (yanlisTahminler == maxTahminHakki) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Yandın!'),
                content: Text('Adam tamamen asıldı.\nDoğru kelime: $kelime'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        kelime = getRandomKelime();
                        resetOyunu();
                      });
                    },
                    child: Text('Yeniden Oyna'),
                  ),
                ],
              );
            },
          );
          oyunBitti = true;
        }
      } else {
        if (getKelimeDurumu().replaceAll(' ', '') == kelime) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Başardın!'),
                content: Text('Kelimeyi doğru tahmin ettin.'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        kelime = getRandomKelime();
                        resetOyunu();
                      });
                    },
                    child: Text('Yeni Kelime'),
                  ),
                ],
              );
            },
          );
          oyunBitti = true;
        }
      }
    }
  }

  Widget buildAdam() {
    List<Widget> uzuvlar = [];
    if (yanlisTahminler >= 1) {
      uzuvlar.add(CircleAvatar(radius: 15,backgroundColor: Colors.blue,));
    }
    if (yanlisTahminler >= 2) {
      uzuvlar.add(Container(
        width: 4,
        height: 20,
        color: Colors.blue,
      ));
    }
    if (yanlisTahminler >= 3) {
      uzuvlar.add(Container(
        width: 50,
        height: 4,
        color: Colors.blue,
      ));
    }
    if (yanlisTahminler >= 4) {
      uzuvlar.add(Container(
        width: 50,
        height: 4,
        color: Colors.blue,
      ));
    }
    if (yanlisTahminler >= 5) {
      uzuvlar.add(Container(
        width: 4,
        height: 20,
        color: Colors.blue,
      ));
    }
    if (yanlisTahminler >= 6) {
      uzuvlar.add(Container(
        width: 20,
        height: 4,
        color: Colors.blue,
      ));
    }
    return Column(children: uzuvlar);
  }

  void resetOyunu() {
    tahminler.clear();
    yanlisTahminler = 0;
    oyunBitti = false;
  }
}
