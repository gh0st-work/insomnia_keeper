import 'package:flutter/material.dart';
import 'package:insomnia_keeper_flutter/widgets/root.dart';

import 'package:redux/redux.dart' show Store;
import 'package:insomnia_keeper_flutter/data/app_state.dart' show store;
import 'package:insomnia_keeper_flutter/misc/flutter_redux_hooks.dart' show StoreProvider;

void main() {
  runApp(const App());
}



class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StoreProvider<dynamic>(
      store: store,
      child: MaterialApp(
        title: 'Insomnia keeper',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: Root(),
      )
    );
  }
}




