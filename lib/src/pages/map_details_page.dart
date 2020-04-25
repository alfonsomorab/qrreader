import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:latlong/latlong.dart';


class MapDetailsPage extends StatefulWidget {

  @override
  _MapDetailsPageState createState() => _MapDetailsPageState();
}

class _MapDetailsPageState extends State<MapDetailsPage> {
  final mapController = MapController();

  List<String> mapTypes = ['streets', 'dark', 'light', 'outdoors', 'satellite'];
  String type = 'streets';
  int currentType = 0;

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;


    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de ubicación'),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.my_location ),
            onPressed: (){
              mapController.move( scan.getLatLng() , 15.0);
            },
          ),
        ],
      ),
      body: _createFlutterMap(scan),
      floatingActionButton: _createFloatingActionButton( context, scan ),
    );
  }

  Widget _createFloatingActionButton( BuildContext context, ScanModel scan ){
    return FloatingActionButton(
      child: Icon( Icons.redo ),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){
        setState(() {
          currentType++;
          if (currentType >= mapTypes.length){
            currentType = 0;
          }
          type = mapTypes[currentType];
          print(type);
          mapController.move(scan.getLatLng(), 10.0);

        });

      },
    );
  }

  Widget _createFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: mapController,
      options: new MapOptions(
        center: scan.getLatLng(),
        zoom: 13.0,
      ),
      layers: [
        _createMap(),
        _createMarker( scan ),
      ],
    );
  }

  _createMap(){

    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
        '{id}/{z}/{x}/{y}@2x.png?access_token={access_token}',
      additionalOptions: {
        'access_token' : 'pk.eyJ1IjoiYWxmb25zb21vcmFiIiwiYSI6ImNrOWVzd3AwOTA1cXIzZnBmazEyeGE3a2cifQ.fLSK4SyyXKWaxzpDLaXgzw',
        'id' : 'mapbox.$type'
        // Maps types: streets, dark, light, outdoors, satellite
      }
    );
  }

  _createMarker( ScanModel scan ){

    return MarkerLayerOptions(
      markers: <Marker> [
        Marker(
          width: 50.0,
          height: 50.0,
          point: scan.getLatLng(),
          builder: ( context ) => Container(
            child: Icon(
              Icons.location_on,
              size: 60.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ]
    );
  }
}
