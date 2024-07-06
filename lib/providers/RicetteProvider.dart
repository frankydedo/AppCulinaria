// ignore_for_file: unused_field, duplicate_import

import 'dart:math';

import 'package:buonappetito/data/RicetteDB.dart';
import 'package:buonappetito/models/Categoria.dart';
import 'package:buonappetito/models/Ricetta.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class RicetteProvider extends ChangeNotifier {

  String percorsoFotoProfilo = 'assets/images/logoAPPetito-1024.png';
  String nomeProfilo = "your name";
  int finestraTemporale = 1; //numero delle settimane da mostrare in "aggiunti di recente"

  List<Ricetta> preferiti = [];
  List<String> carrello =[];
  List<String> get carrelloInvertito => carrello.reversed.toList();
  List<String> elementiCancellatiCarrello = [];
   final _RicetteBox = Hive.box('Recipes');
   RicetteListDB _db = RicetteListDB();
 
  RicetteProvider() {
    _loadData();
  }

  List<Categoria> categorie = [
    Categoria(nome: "Primi",
      ricette: [
        Ricetta(
          categorie: ["Primi", "Carne"],
          percorsoImmagine: "assets/foto_piatti/ZitiAllaGenovese_2.jpg",
          descrizione: "Ziti spezzati a mano alla genovese",
          ingredienti: {
            "Ziti": "120 g / testa",
            "Carne di bovino": "120 g / testa",
            "Cipolle": "100 g / testa",
            "Pecorino": "q.b.",
            "Pepe": "q.b."
          },
          passaggi: [
            "Scottare la carne per qualche secondo",
            "caramellare le cipolle",
            "Unire carne e cipolle col brodo",
            "Apettare 2 ore",
            "Bollire gli ziti",
            "Mantecare con formaggio",
            "Ricoprire con pepe"
          ],
          titolo: "Ziti alla Genovese",
          minutiPreparazione: 180,
          difficolta: 2,
          dataAggiunta: DateTime.now(),
        ),

        Ricetta(
          categorie: ["Primi", "Pesce"],
          percorsoImmagine: "assets/foto_piatti_gz/SpaghettiAlleVongole_1.jpg.avif",
          descrizione: "Spaghetti alle vongole",
          ingredienti: {
            "Spaghetti": "120 g / testa",
            "Vongole": "120 g / testa",
            "Sale": "q.b.",
            "Pepe": "q.b."
          },
          passaggi: [
            "Far aprire le vongole in padella",
            "Bollire la pasta",
            "Scolare la pasta nelle vongole",
            "Mantecare con olio e.v.o a filo"
          ],
          titolo: "Spaghetti alle Vongole",
          minutiPreparazione: 12,
          difficolta: 0,
          dataAggiunta: DateTime.now().subtract(Duration(days: 8)),
        ),
      ]
    ),
    Categoria(nome: "Secondi",
    ricette: [
      Ricetta(
    categorie: ["Secondi", "Carne"],
    percorsoImmagine: "assets/foto_piatti_gz/Ribs_1.jpg.avif",
    descrizione: "Ribs speziate alla brace",
    ingredienti: {
      "Ribs di maiale": "100 g / testa",
      "Salsa BBQ": "q.b.",
      "Spezie": "q.b.",
      "Sale": "q.b.",
      "Pepe": "q.b."
    },
    passaggi: [
      "Riscaldare la brace",
      "Massaggiare la carne con le spezie",
      "Spennellare con salsa BBQ",
      "Cuocere a 120° per 2 ore"
    ],
    titolo: "Ribs alla brace",
    minutiPreparazione: 130,
    difficolta: 1,
    dataAggiunta: DateTime.now().subtract(Duration(days: 20)),
  )
    ]),
    // Categoria(nome: "Contorni"),
    // Categoria(nome: "Dolci"),
    // Categoria(nome: "Vegano"),
    Categoria(nome: "Carne",
    ricette: [
      Ricetta(
    categorie: ["Secondi", "Carne"],
    percorsoImmagine: "assets/foto_piatti_gz/Ribs_1.jpg.avif",
    descrizione: "Ribs speziate alla brace",
    ingredienti: {
      "Ribs di maiale": "100 g / testa",
      "Salsa BBQ": "q.b.",
      "Spezie": "q.b.",
      "Sale": "q.b.",
      "Pepe": "q.b."
    },
    passaggi: [
      "Riscaldare la brace",
      "Massaggiare la carne con le spezie",
      "Spennellare con salsa BBQ",
      "Cuocere a 120° per 2 ore"
    ],
    titolo: "Ribs alla brace",
    minutiPreparazione: 130,
    difficolta: 1,
    dataAggiunta: DateTime.now().subtract(Duration(days: 20)),
  ),
  Ricetta(
    categorie: ["Primi", "Carne"],
    percorsoImmagine: "assets/foto_piatti/ZitiAllaGenovese_2.jpg",
    descrizione: "Ziti spezzati a mano alla genovese",
    ingredienti: {
      "Ziti": "120 g / testa",
      "Carne di bovino": "120 g / testa",
      "Cipolle": "100 g / testa",
      "Pecorino": "q.b.",
      "Pepe": "q.b."
    },
    passaggi: [
      "Scottare la carne per qualche secondo",
      "caramellare le cipolle",
      "Unire carne e cipolle col brodo",
      "Apettare 2 ore",
      "Bollire gli ziti",
      "Mantecare con formaggio",
      "Ricoprire con pepe"
    ],
    titolo: "Ziti alla Genovese",
    minutiPreparazione: 180,
    difficolta: 2,
    dataAggiunta: DateTime.now(),
  ),

    ]),
    Categoria(nome: "Pesce",
    ricette: [
      Ricetta(
    categorie: ["Primi", "Pesce"],
    percorsoImmagine: "assets/foto_piatti_gz/SpaghettiAlleVongole_1.jpg.avif",
    descrizione: "Spaghetti alle vongole",
    ingredienti: {
      "Spaghetti": "120 g / testa",
      "Vongole": "120 g / testa",
      "Sale": "q.b.",
      "Pepe": "q.b."
    },
    passaggi: [
      "Far aprire le vongole in padella",
      "Bollire la pasta",
      "Scolare la pasta nelle vongole",
      "Mantecare con olio e.v.o a filo"
    ],
    titolo: "Spaghetti alle Vongole",
    minutiPreparazione: 12,
    difficolta: 0,
    dataAggiunta: DateTime.now().subtract(Duration(days: 8)),
  ),
    ])
  ];

  List <Ricetta> ricette = [
    Ricetta(
    categorie: ["Primi", "Carne"],
    percorsoImmagine: "assets/foto_piatti/ZitiAllaGenovese_2.jpg",
    descrizione: "Ziti spezzati a mano alla genovese",
    ingredienti: {
      "Ziti": "120 g / testa",
      "Carne di bovino": "120 g / testa",
      "Cipolle": "100 g / testa",
      "Pecorino": "q.b.",
      "Pepe": "q.b."
    },
    passaggi: [
      "Scottare la carne per qualche secondo",
      "caramellare le cipolle",
      "Unire carne e cipolle col brodo",
      "Apettare 2 ore",
      "Bollire gli ziti",
      "Mantecare con formaggio",
      "Ricoprire con pepe"
    ],
    titolo: "Ziti alla Genovese",
    minutiPreparazione: 180,
    difficolta: 2,
    dataAggiunta: DateTime.now(),
  ),

  Ricetta(
    categorie: ["Primi", "Pesce"],
    percorsoImmagine: "assets/foto_piatti_gz/SpaghettiAlleVongole_1.jpg.avif",
    descrizione: "Spaghetti alle vongole",
    ingredienti: {
      "Spaghetti": "120 g / testa",
      "Vongole": "120 g / testa",
      "Sale": "q.b.",
      "Pepe": "q.b."
    },
    passaggi: [
      "Far aprire le vongole in padella",
      "Bollire la pasta",
      "Scolare la pasta nelle vongole",
      "Mantecare con olio e.v.o a filo"
    ],
    titolo: "Spaghetti alle Vongole",
    minutiPreparazione: 12,
    difficolta: 0,
    dataAggiunta: DateTime.now().subtract(Duration(days: 8)),
  ),

  Ricetta(
    categorie: ["Secondi", "Carne"],
    percorsoImmagine: "assets/foto_piatti_gz/Ribs_1.jpg.avif",
    descrizione: "Ribs speziate alla brace",
    ingredienti: {
      "Ribs di maiale": "100 g / testa",
      "Salsa BBQ": "q.b.",
      "Spezie": "q.b.",
      "Sale": "q.b.",
      "Pepe": "q.b."
    },
    passaggi: [
      "Riscaldare la brace",
      "Massaggiare la carne con le spezie",
      "Spennellare con salsa BBQ",
      "Cuocere a 120° per 2 ore"
    ],
    titolo: "Ribs alla brace",
    minutiPreparazione: 130,
    difficolta: 1,
    dataAggiunta: DateTime.now().subtract(Duration(days: 20)),
  )
  ];

  void cambiaFotoProfilo(String nuovaFoto){
    percorsoFotoProfilo = nuovaFoto;
    notifyListeners();
  }

  void cambiaNomeProfilo(String nuovoNome){
    nomeProfilo = nuovoNome;
    notifyListeners();
  }

  void setFinestraTemporale(int settimane){
    this.finestraTemporale = settimane;
    notifyListeners();
  }

  void aggiungiIngredienteAlCarrello(String i){
    if(elementiCancellatiCarrello.contains(i)){
      elementiCancellatiCarrello.remove(i);
    }
    carrello.add(i);
    notifyListeners();
  }
  void rimuoviIngredienteDalCarrello(String i){
    elementiCancellatiCarrello.add(i);
    carrello.remove(i);
    notifyListeners();
  }

  void ripristinaCancellaizioneCarrello(){
    String elem = elementiCancellatiCarrello.last;
    elementiCancellatiCarrello.remove(elem);
    aggiungiIngredienteAlCarrello(elem);
    notifyListeners();
  }

  void rimuoviTuttoDalCarrello(){
    for(String elem in carrello){
      elementiCancellatiCarrello.add(elem);
    }
    carrello.clear();
    notifyListeners();
  }

  void aggiungiAiPreferiti(Ricetta r){
    r.setPreferita();
    preferiti.add(r);
    notifyListeners();
  }


  void rimuoviDaiPreferiti(Ricetta r){
    r.resetPreferita();
    preferiti.remove(r);
    notifyListeners();
  }

  void aggiungiNuovaCategoria(Categoria c){
    if (categorie.contains(c)){
      return;
    }
    categorie.add(c);
    notifyListeners();
  }

  void rimuoviCategoria(Categoria c){
    categorie.remove(c);
    notifyListeners();
  }
  
  void aggiungiNuovaRicetta(Ricetta r){
    ricette.add(r);
    for (String nomeCategoria in r.categorie){
      Categoria? categoria = categorie.where((c) => c.nome == nomeCategoria).firstOrNull;
      categoria?.aggiungiRicetta(r);
    }
    categorie.removeWhere((c) => c.ricette.isEmpty);
    _saveData();
    notifyListeners();
  }

  void rimuoviRicetta(Ricetta r){
    for (String nomeCategoria in r.categorie){
      Categoria? categoria = categorie.where((c) => c.nome == nomeCategoria).firstOrNull;
      categoria?.riumoviRicetta(r);
    }
    if(preferiti.contains(r)){
      rimuoviDaiPreferiti(r);
    }
    categorie.removeWhere((c) => c.ricette.isEmpty);

    ricette.remove(r);
    _saveData();
    notifyListeners();
  }


  List<Ricetta> generaAggiuntiDiRecente(){
    List<Ricetta> aggiuntiDiRecente = ricette.where((r) => r.dataAggiunta.isAfter(DateTime.now().subtract(Duration(days: 7 * finestraTemporale)))).toList();
    aggiuntiDiRecente.sort((a, b) => b.dataAggiunta.compareTo(a.dataAggiunta));
    return aggiuntiDiRecente;
  }

  List<Ricetta> generaRicetteCarosello() {
    List<Ricetta> ric = [];
    if (ricette.length < 4) {
      return ricette;
    } else {
      Random random = Random();
      Set<int> indici = Set();
      while (indici.length < 3) {
        indici.add(random.nextInt(ricette.length));
      }
      for (int i in indici) {
        ric.add(ricette.elementAt(i));
      }
      return ric;
    }
  }

  Future<void> _loadData() async {
    // Apri il box specifico per il profilo
    await Hive.box('Recipes');
    _db.loadData();

    if(_db.RecipesList == null ){
      _db.createInitialData();
    }
    ricette = _db.RecipesList!;
    notifyListeners();
  }

  Future<void> _saveData() async {
   _db.RecipesList = ricette;

    _db.updateDatabase();
    notifyListeners();
  }





}
