import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:denemeawsstorage/amplifyconfiguration.dart';
import 'package:denemeawsstorage/models/ExObject.dart';
import 'package:flutter/material.dart';

import 'models/ModelProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _amplify = Amplify;

  final _exObject = 'exObject';

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() {
    final provider = ModelProvider();
    final dataStorePlugin = AmplifyDataStore(modelProvider: provider);

    _amplify.addPlugins([dataStorePlugin]);
    _amplify.configure(amplifyconfig);

    print('Amplify configured!!!');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // CREATE
          FlatButton(
              onPressed: () => create(),
              child: Text('Create'),
              color: Colors.green,
              textColor: Colors.white),

          // READ ALL
          FlatButton(
              onPressed: () => readAll(),
              child: Text('Read ALL'),
              color: Colors.blue,
              textColor: Colors.white),

          // READ BY ID
          FlatButton(
              onPressed: () => readById(),
              child: Text('Read BY ID'),
              color: Colors.cyan,
              textColor: Colors.white),

          // UPDATE
          FlatButton(
              onPressed: () => update(),
              child: Text('Update'),
              color: Colors.orange,
              textColor: Colors.white),

          // DELETE
          FlatButton(
              onPressed: () => delete(),
              child: Text('Delete'),
              color: Colors.red,
              textColor: Colors.white),
        ],
      ),
    );
  }

  void create() async {
    final exObject = ExObject(
      value: "This is an example object!",
      id: _exObject,
    );

    try {
      await Amplify.DataStore.save(exObject);
      print('Saved ${exObject.toString()}');
    } catch (e) {
      print(e);
    }
  }

  void readAll() async {
    try {
      final exObject = await Amplify.DataStore.query(ExObject.classType);
    } catch (e) {
      print(e);
    }
  }

  Future<ExObject?> readById() async {
    try {
      final exObjects = await Amplify.DataStore.query(ExObject.classType,
          where: ExObject.ID.eq(_exObject));

      if (exObjects.isEmpty) {
        print("No objects with ID: $_exObject");
        return null;
      }

      final exObject = exObjects.first;

      print(exObject.toString());

      return exObject;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  void update() async {
    try {
      final exObject = await readById();

      final updatedObject =
          exObject!.copyWith(value: exObject.value + ' [UPDATED]');

      await Amplify.DataStore.save(updatedObject);

      print('Updated object to ${updatedObject.toString()}');
    } catch (e) {
      print(e);
    }
  }

  void delete() async {
    try {
      final myObject = await readById();

      await Amplify.DataStore.delete(myObject!);

      print('Deleted object with ID: ${myObject.id}');
    } catch (e) {
      print(e);
    }
  }
}
