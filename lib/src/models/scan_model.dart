import 'package:latlong/latlong.dart';

class ScanModel {
  int id;
  String value;
  String type;

  ScanModel({
    this.id,
    this.value,
    this.type,
  }){
    if (this.value.contains('http')){
      this.type = 'http';
    }
    else{
      this.type = 'geo';
    }
  }

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
    id      : json["id"],
    value   : json["value"],
    type    : json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id"      : id,
    "value"   : value,
    "type"    : type,
  };

  LatLng getLatLng(){
    final lalo = value.substring(4).split(',');
    final lat = double.parse( lalo[0] );
    final lng = double.parse( lalo[1] );

    return LatLng( lat , lng );
  }
}