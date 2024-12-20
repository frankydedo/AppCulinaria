import 'package:flutter/material.dart';
// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, unused_import, unnecessary_import
import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/pages/SearchPage.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/DifficultyProvider.dart';
import 'package:provider/provider.dart';

class MyDifficolta extends StatelessWidget {
  final Function(List<int>) onSelectionChanged;
  final List<int> selectedDifficultyIndices;

  MyDifficolta({Key? key, required this.onSelectionChanged, required this.selectedDifficultyIndices});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, DifficultyProvider>(
      builder: (context, colorsModel, difficultyModel, _) {
        return AlertDialog(
          backgroundColor: colorsModel.dialogBackgroudColor,
          content: SizedBox(
            width: 400,
            height: 450,
            child: Column(
              children: [
                Icon(
                  Icons.restaurant_menu_rounded,
                  color: colorsModel.coloreSecondario,
                  size: 50,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: difficultyModel.allDifficulties.length,
                    itemBuilder: (context, index) {
                      String difficulty = difficultyModel.allDifficulties[index];
                      bool isSelected = difficultyModel.isSelected(index);
                      return CheckboxListTile(
                        side: BorderSide(color: colorsModel.textColor),
                        activeColor: colorsModel.coloreSecondario,
                        title: Text(
                          difficulty,
                          style: TextStyle(
                            color: colorsModel.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        value: isSelected,
                        onChanged: (val) {
                          difficultyModel.toggleDifficultyIndex(index);
                          onSelectionChanged(difficultyModel.selectedDifficultyIndices.toList());
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: difficultyModel.hasSelection 
                      ? () {
                          difficultyModel.resetSelection();
                          onSelectionChanged([]);
                        }
                      : null,
                      style: ElevatedButton.styleFrom(
                        foregroundColor:  Colors.white,
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
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
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
