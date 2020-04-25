import 'package:flutter/material.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

import 'package:qrreaderapp/src/pages/addresses_page.dart';
import 'package:qrreaderapp/src/pages/maps_page.dart';
import 'package:qrreaderapp/src/utils/launch_web_util.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scanStream = new ScansBloc();

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            onPressed: scanStream.deleteAllScans,
            icon: Icon( Icons.delete_forever ),
          )
        ],
      ),
      body: _getCurrentPage(_currentPage),
      bottomNavigationBar:  _createBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _callCameraReader,
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _callCameraReader() async{
    // https://alfonsomora.xyz
    // geo:40.776185716054194,-74.03100386103519

    String futureString = '';
    //String futureString = 'https://alfonsomora.xyz';
    //String futureString = 'geo:40.776185716054194,-74.03100386103519';

    try {
      futureString = await BarcodeScanner.scan();
    }
    catch (e){
      futureString = e.toString();
    }

    if ( futureString != null){
      final scanModel = new ScanModel(value: futureString);
      scanStream.addScan(scanModel);
      utils.launchURL(context, scanModel);
    }

  }

  Widget _createBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentPage,
      onTap: (index){
        setState(() {
          _currentPage = index;
        });
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon( Icons.map ),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.near_me ),
          title: Text('Direcciones')
        ),
      ],

    );
  }

  Widget _getCurrentPage(int currentPage) {
    switch (currentPage){
      case 0: return MapsPage();
      case 1: return AddressesPage();
      default:
        return MapsPage();
    }
  }
}
