import 'package:buonappetito/utils/ConfermaDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';

class CarrelloPage extends StatefulWidget {
  const CarrelloPage({Key? key}) : super(key: key);

  @override
  State<CarrelloPage> createState() => _CarrelloPageState();
}

class _CarrelloPageState extends State<CarrelloPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {

    Future showConfermaDialog(BuildContext context, String domanda) {
      return showDialog(
        context: context,
        builder: (context) => ConfermaDialog(domanda: domanda,),
      );
    }

    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
        List<String> carrello = ricetteModel.carrello;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              carrello.isEmpty ? '' : 'CARRELLO',
              style: GoogleFonts.encodeSans(
                color: colorsModel.getColoreTitoli(context),
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: carrello.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove_shopping_cart_rounded,
                        color: Colors.grey,
                        size: 80,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Il tuo carrello è vuoto',
                        style: GoogleFonts.encodeSans(
                          textStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Aggiungi gli ingredienti da acquistare\nper vederli qui.',
                        style: GoogleFonts.encodeSans(
                          textStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                            onTap: ()async{
                              bool conferma = await showConfermaDialog(context, "Sicuro di eliminare tutti gli elementi dal carrello?");
                              if(conferma){
                                setState(() {
                                  ricetteModel.carrello.clear();
                                });
                              }
                            },
                            child: Text(
                              "Rimuovi tutto",
                              style: GoogleFonts.encodeSans(
                                color: colorsModel.getColoreSecondario(),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimatedList(
                          key: _listKey,
                          initialItemCount: carrello.length,
                          itemBuilder: (context, index, animation) {
                            if (index >= carrello.length) return Container(); // Controllo per evitare RangeError
                            final item = carrello[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10, right: 0, left: 4, top: 5),
                              child: _buildSlidableItem(context, item, index, ricetteModel, colorsModel),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  void _removeItem(int index, RicetteProvider ricetteModel) {
    if (index < 0 || index >= ricetteModel.carrello.length) return; // Controllo per evitare RangeError
    final item = ricetteModel.carrello[index];

    _listKey.currentState!.removeItem(
      index,
      (context, animation) => FadeTransition(
        opacity: animation,
        child: _buildSlidableItem(context, item, index, ricetteModel, context.read<ColorsProvider>()),
      ),
    );

    ricetteModel.rimuoviElementoCarrello(item);

    setState(() {});
  }

  Widget _buildSlidableItem(BuildContext context, String item, int index, RicetteProvider ricetteModel, ColorsProvider colorsModel) {
    return Slidable(
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              if (index >= ricetteModel.carrello.length) return; // Controllo aggiuntivo per evitare RangeError
              _removeItem(index, ricetteModel);
            },
            borderRadius: BorderRadius.circular(20),
            icon: Icons.check_rounded,
            backgroundColor: Colors.green,
          ),
        ],
      ),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0, top: 15),
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.green,
                  size: 32,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    item,
                    style: GoogleFonts.encodeSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 15),
                child: Icon(
                  Icons.keyboard_double_arrow_left_rounded,
                  color: Colors.grey[400],
                  size: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
