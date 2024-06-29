import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NuovoIngredienteDialog extends StatefulWidget {
  final String msg;

  const NuovoIngredienteDialog({Key? key, required this.msg}) : super(key: key);

  @override
  _NuovoIngredienteDialogState createState() => _NuovoIngredienteDialogState();
}

class _NuovoIngredienteDialogState extends State<NuovoIngredienteDialog> {
  String? provIngrediente;
  String? provQuantita;
  String unit = "grammi";
  bool enableQuantita = true; 

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // icona [?]
                Icon(
                  Icons.help_outline,
                  color: colorsModel.getColoreSecondario(),
                  size: 70,
                ),
                SizedBox(height: 20),

                // testo richiesta
                Text(
                  widget.msg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 20),

                // form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // ingrediente
                      TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Completare campo";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          provIngrediente = value;
                        },
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Ingrediente',
                        ),
                      ),
                      SizedBox(height: 20),

                      // quantità e selettore unità
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              enabled: enableQuantita, // Abilita o Disabilita il campo in base allo stato
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (enableQuantita){
                                  if (value == null || value.isEmpty) {
                                    return "Completare campo";
                                  }
                                }
                                return null;
                              },
                              onChanged: (value) {
                                provQuantita = value;
                              },
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Quantità ciascuno',
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          DropdownButton<String>(
                            value: unit,
                            icon: Icon(Icons.arrow_downward),
                            onChanged: (String? newValue) {
                              setState(() {
                                unit = newValue!;
                                enableQuantita = (unit == 'grammi');
                                if (!enableQuantita) {
                                  provQuantita = '';
                                }
                              });
                            },
                            items: <String>['grammi', 'Q.B.']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // tasti
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    // tasto annulla

                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Annulla",
                        style: TextStyle(
                          color: colorsModel.getColoreSecondario(),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // tasto fatto
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Solo se l'unità è 'grammi', aggiunge il valore della quantità
                          if (unit == 'grammi') {
                            Map<String, String> nuovoIngrediente = {provIngrediente!: provQuantita! + " " + unit};
                            Navigator.pop(context, nuovoIngrediente);
                          } else {
                            // Altrimenti, aggiunge solo l'ingrediente senza quantità
                            Map<String, String> nuovoIngrediente = {provIngrediente!: "Q.B."};
                            Navigator.pop(context, nuovoIngrediente);
                          }
                        }
                      }, 
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, 
                        backgroundColor: colorsModel.getColoreSecondario(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        elevation: 5,
                        shadowColor: Colors.black,
                      ),                          
                      child: Text(
                        "Fatto",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
