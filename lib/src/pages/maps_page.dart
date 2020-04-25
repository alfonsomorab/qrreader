import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/utils/launch_web_util.dart' as utils;

class MapsPage extends StatelessWidget {

  final streamScans = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    streamScans.getScans();

    return StreamBuilder(
      stream: streamScans.stream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center( child: CircularProgressIndicator(),);
        }

        final scans = snapshot.data;

        if (scans.length == 0){
          return Center( child: Text('No hay registros'),);
        }

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (BuildContext context, i){
            return Dismissible(
              key: UniqueKey(),
              onDismissed: ( direction ) => streamScans.deleteScan(scans[i].id),
              background: Container( color: Colors.red,),
              child: ListTile(
                title: Text(scans[i].value),
                subtitle: Text('ID: ${ scans[i].id } / Tipo: ${  scans[i].type }'),
                leading: Icon(Icons.map, color: Theme.of(context).primaryColor,),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: (){
                  utils.launchURL(context, scans[i]);
                },
              ),
            );
          },

        );
      }
    );

  }
}
