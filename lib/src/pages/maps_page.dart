import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class MapsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DBProvider.db.getAllScans(),
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
              onDismissed: ( direction ) => DBProvider.db.deleteScan(scans[i].id),
              background: Container( color: Colors.red,),
              child: ListTile(
                title: Text(scans[i].value),
                subtitle: Text('ID: ${ scans[i].id } / Tipo: ${  scans[i].type }'),
                leading: Icon(Icons.cloud_queue, color: Theme.of(context).primaryColor,),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: (){},
              ),
            );
          },

        );
      }
    );

  }
}
