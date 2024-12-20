import 'package:hive/hive.dart';

part 'Ricetta.g.dart'; // Questa direttiva deve essere presente

@HiveType(typeId: 0)
class Ricetta {
  @HiveField(0)
  String percorsoImmagine;

  @HiveField(1)
  String titolo;

  @HiveField(2)
  String descrizione;

  @HiveField(3)
  Map<String, String> ingredienti;

  @HiveField(4)
  List<String> categorie;

  @HiveField(5)
  List<String> passaggi;

  @HiveField(6)
  int difficolta;

  @HiveField(7)
  int minutiPreparazione;

  @HiveField(8)
  DateTime dataAggiunta;

  @HiveField(9)
  bool isFavourite = false;

  Ricetta({
    required this.percorsoImmagine,
    required this.categorie,
    required this.descrizione,
    required this.ingredienti,
    required this.passaggi,
    required this.titolo,
    required this.minutiPreparazione,
    required this.difficolta,
    required this.dataAggiunta,
  });

  String getCategorie() {
    String c = "";
    for (int i = 0; i < categorie.length; i++) {
      if (i == 0) {
        c += categorie[i]; 
      }  else {
        c += ' | ' + categorie[i];
      }
    }
    return c;
  }

  void setPreferita() {
    isFavourite = true;
  }

  void setImmagine(String immagine) {
    percorsoImmagine= immagine ;
  }

  void resetPreferita() {
    isFavourite = false;
  }

  void setIngredienti(Map<String, String> listaIngredienti) {
    this.ingredienti = listaIngredienti;
  }

  void setPassaggi(List <String> listaPassaggi) {
    this.passaggi = listaPassaggi;
  }

  void setTitolo(String titoloNuovo) {
    this.titolo = titoloNuovo;
  }

  void setCategorie(List <String> listaCategorie) {
    this.categorie = listaCategorie;
  }

  void aggiungiNuovaCategoria (String nuovaCategoria)
  {
    categorie.add(nuovaCategoria);
  }

  void setDescrizione(String descrizioneNuova) {
    this.descrizione = descrizioneNuova;
  }

  void aggiungiIngrediente(String ingrediente, String dose) {
    ingredienti.addAll({ingrediente: dose});
  }

  void rimuoviIngrediente(String ingrediente) {
    ingredienti.remove(ingrediente);
  }

  void aggiungiPassaggio(String passaggio) {
    passaggi.add(passaggio);
  }

  void rimuoviPassaggio(String passaggio) {
    passaggi.remove(passaggio);
  }

  void setDifficolta(int difficoltaNuova) {
    difficolta = difficoltaNuova;
  }

  void setMinutiPreparazione(int minuti) {
    minutiPreparazione = minuti;
  }

  String getDifficoltaAsString(){
    switch (this.difficolta) {
      case 0: return "Principiante";
      case 1: return "Amatoriale";
      case 2: return "Intermedio";
      case 3: return "Chef";
      default: return "Chef Stellato";
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ricetta &&
        _compareMaps(ingredienti, other.ingredienti) &&
        _compareLists(passaggi, other.passaggi);
  }

  @override
  int get hashCode => ingredienti.hashCode ^ passaggi.hashCode;

  bool _compareMaps(Map<String, String> map1, Map<String, String> map2) {
    if (map1.length != map2.length) return false;
    for (String key in map1.keys) {
      if (!map2.containsKey(key) || map1[key] != map2[key]) {
        return false;
      }
    }
    return true;
  }

  bool _compareLists(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}
