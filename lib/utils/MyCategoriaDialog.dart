// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, unused_import, unnecessary_import, unused_local_variable, deprecated_member_use

import 'package:buonappetito/models/Categoria.dart';
import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/pages/SearchPage.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyCategoriaDialog extends StatefulWidget {
  Map<Categoria, bool> selezioneCategorie;
  bool canAddNewCategory;
  

  MyCategoriaDialog({super.key, required this.selezioneCategorie, required this.canAddNewCategory});

  @override
  State<MyCategoriaDialog> createState() => _MyCategoriaDialogState();
}

class _MyCategoriaDialogState extends State<MyCategoriaDialog> {

  Map<Categoria, bool> selezionePrecedente = {};

  @override
  void initState(){
    super.initState();
    for(var entry in widget.selezioneCategorie.entries){
      selezionePrecedente.addAll({entry.key : entry.value});
    }
  }

  void _showAddCategoryDialog(RicetteProvider ricetteModel) {
    TextEditingController categoriaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        ColorsProvider colorsModel = Provider.of<ColorsProvider>(context, listen: false);
        return AlertDialog(
          backgroundColor: colorsModel.backgroudColor,
          title: Text(
            "Aggiungi Categoria",
            style: TextStyle(
              color: colorsModel.textColor,
              fontSize: 22,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: TextField(
            controller: categoriaController,
            decoration: InputDecoration(
              hintText: "Nome Categoria",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Annulla",
                style: TextStyle(
                  color: colorsModel.isLightMode ? colorsModel.coloreSecondario : Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                String newCategoriaNome = categoriaController.text.trim();
                newCategoriaNome = newCategoriaNome[0].toUpperCase()+newCategoriaNome.substring(1).toLowerCase(); // formatto la stringa con solo la prima lettera maiuscola
                if (newCategoriaNome.isNotEmpty) {
                  Categoria newCategoria = Categoria(nome: newCategoriaNome, ricette: []);
                  setState(() {
                    ricetteModel.aggiungiNuovaCategoria(newCategoria);
                    widget.selezioneCategorie[newCategoria] = true;
                  });
                  Navigator.pop(context);
                }
              }, 
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, 
                backgroundColor: colorsModel.coloreSecondario,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                elevation: 5,
                shadowColor: Colors.black,
              ),                          
              child: Text(
                "Salva",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, selezionePrecedente);
            return false;
          },
          child: AlertDialog(
            backgroundColor: colorsModel.dialogBackgroudColor,
            content: SizedBox(
              width: 400,
              height: 500,
              child: Column(
                children: [
                  Stack(
                    children:[
                      Center(
                        child: Icon(
                          Icons.checklist_rounded,
                          color: colorsModel.coloreSecondario,
                          size: 70,
                        ),
                      ),
                      Row(
                        children: [
                          //tasto return
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context, selezionePrecedente);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.arrow_back_ios, color:colorsModel.coloreSecondario),
                            )
                          ),
                          Spacer(),

                          //tasto aggiugni categoria

                          widget.canAddNewCategory ?

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () => _showAddCategoryDialog(ricetteModel),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: colorsModel.coloreSecondario,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                elevation: 5,
                                shadowColor: Colors.black,
                              ),
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          )

                          :

                          SizedBox()
                        ],
                      )
                    ]
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ricetteModel.categorie.isNotEmpty
                      ? ListView.builder(
                          itemCount: ricetteModel.categorie.length,
                          itemBuilder: (context, index) {
                            Categoria categoria = ricetteModel.categorie[index];
                            bool isSelected = widget.selezioneCategorie[categoria] ?? false;
                            return CheckboxListTile(
                              side: BorderSide(color: colorsModel.textColor),
                              activeColor: colorsModel.coloreSecondario,
                              title: Text(
                                categoria.nome,
                                style: GoogleFonts.encodeSans(
                                  textStyle: TextStyle(
                                    color: colorsModel.textColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              value: isSelected,
                              onChanged: (val) {
                                setState(() {
                                  widget.selezioneCategorie[categoria] = val!;
                                });
                              },
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            'Nessuna categoria disponibile :/',
                            style: GoogleFonts.encodeSans(
                              color: Colors.grey,
                              fontSize: 20
                            )
                          ),
                        ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //reset button
                      ElevatedButton(
                        onPressed: widget.selezioneCategorie.values.every((value) => value == false) ? 
                        null:
                        () {
                          setState(() {
                            widget.selezioneCategorie.updateAll((key, value) => false);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, 
                          backgroundColor: colorsModel.coloreSecondario,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          elevation: 5,
                          shadowColor: Colors.black,
                        ),                          
                        child: Text(
                          "Reset",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // save button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, widget.selezioneCategorie);
                        }, 
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, 
                          backgroundColor: colorsModel.coloreSecondario,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          elevation: 5,
                          shadowColor: Colors.black,
                        ),                          
                        child: Text(
                          "Salva",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}