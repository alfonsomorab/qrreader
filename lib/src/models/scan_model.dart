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
}