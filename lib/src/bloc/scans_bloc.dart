import 'dart:async';

import 'package:qrreaderapp/src/bloc/validators.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';


class ScansBloc with Validators {

  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._internal(){
    // Get scans from data base

  }

  final _scansStreamController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get stream      => _scansStreamController.stream.transform(validateGEO);
  Stream<List<ScanModel>> get streamHTTP  => _scansStreamController.stream.transform(validateHTTP);


  dispose(){
    _scansStreamController?.close();
  }

  getScans() async {
    _scansStreamController.sink.add( await DBProvider.db.getAllScans() );
  }

  addScan( ScanModel scan ) async {
    await DBProvider.db.newScan(scan);
    getScans();
  }

  deleteScan( int id ) async {
    await DBProvider.db.deleteScan(id);
    getScans();
  }

  deleteAllScans() async {
    await DBProvider.db.deleteAll();
    getScans();
  }



}