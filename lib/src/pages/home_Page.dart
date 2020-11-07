import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:pie_chart/pie_chart.dart';

import 'package:band_names/src/services/socket_service.dart';
import 'package:band_names/src/models/band_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {

  static final routeName = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [];

  @override
  void initState() { 
    super.initState();
    final _socketService = Provider.of<SocketService>(context, listen: false);

    _socketService.socket.on('active-bands', _handleActiveBands );
  }

  @override
  void dispose() { 
    super.dispose();
    final _socketService = Provider.of<SocketService>(context, listen: false);
    _socketService.socket.off( 'active-bands' );
  }

  @override
  Widget build(BuildContext context) {
    
    final _socketService = Provider.of<SocketService>(context);  

    return Scaffold(
      appBar: AppBar(
        title: Text('Band Names', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.only( right: 10.0 ),
            child: ( _socketService.serverStatus == ServerStatus.Online ) 
                    ? Icon( Icons.check_circle_outline, color: Colors.blue[300])
                    : Icon( Icons.offline_bolt_outlined, color: Colors.red, )
          )
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (BuildContext context, int index) => _bandTile(bands[ index ])
        ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.add ),
        onPressed: _addNewBand
      ),
    );
  }

  _handleActiveBands( dynamic payload ) {
      bands = ( payload as List ).map(( banda ) => Band.fromMap( banda )).toList();
      setState(() {});
  }

  _addNewBand(){

    final textCtrl = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: ( _ ) => CupertinoAlertDialog(
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
        )
    );
  }

  void _addBandToList( String name ){
    if ( name.length > 1 ) {
      final _socketService = Provider.of<SocketService>(context, listen: false);
      _socketService.socket.emit('add-band', { 'name': name });
    }

    Navigator.pop(context);
  }

  Widget _bandTile(Band band) {
    final _socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key( band.id ),
      direction: DismissDirection.startToEnd,
      onDismissed: ( _ ) => _socketService.socket.emit('delete-band', { 'id': band.id }),
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
          onTap: () => _socketService.socket.emit('vote-band', { 'id': band.id }),
        ),
    );
  }

  Widget _showGraph() {

    Map<String, double> dataMap = {};
    bands.forEach(( banda ) {
      dataMap.addAll({ banda.name: banda.votes.toDouble() });
    });

    return bands.length != 0 
    ? Container(
      padding: EdgeInsets.only( top: 10.0 ),
      child: PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 2.2,
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 20,
        centerText: "Votos",
        legendOptions: LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
        ),
      )
    )
    : Container(
      padding: EdgeInsets.only( top: 20.0 ),
      child: CircularProgressIndicator()
    );
  }
}
