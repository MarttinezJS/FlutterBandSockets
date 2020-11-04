import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/src/models/band_model.dart';

class HomePage extends StatefulWidget {

  static final routeName = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1', name: 'Asking Alexandria', votes: 10 ),
    Band(id: '2', name: 'Linkin Park', votes: 8 ),
    Band(id: '3', name: 'Flow', votes: 3 ),
    Band(id: '4', name: 'Slipknot', votes: 6 ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Band Names', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index) => _bandTile(bands[ index ])
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.add ),
        onPressed: _addNewBand
      ),
    );
  }

  _addNewBand(){

    final textCtrl = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: ( c ) {
        return CupertinoAlertDialog(
          title: Text('nombre de la banda:'),
          content: CupertinoTextField(
            controller: textCtrl,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => _addBandToList( textCtrl.text ),
              child: Text('Añadir'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
          ],
        );
      }
    );
  }

  void _addBandToList( String name ){
    if ( name.length > 1 ) {
      bands.add( Band(id: DateTime.now().toString(), name: name, votes: 0 ) );
      setState(() {});
    }

    Navigator.pop(context);
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key( band.id ),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
      },
      background: Container(
        padding: EdgeInsets.only( left: 20.0 ),
        child: Align(
          child: Icon( Icons.delete, color: Colors.red, ),
          alignment: Alignment.centerLeft,
        ),
      ),
      child: ListTile(
          leading: CircleAvatar(
            child: Text( band.name.substring(0,2) ),
            backgroundColor: Colors.blue[100],
          ),
          title: Text( band.name ),
          trailing: Text('${ band.votes }', ),
          onTap: () {
            print( band.name );
          },
        ),
    );
  }
}
