import 'package:flutter/material.dart';
import 'package:insomnia_keeper_flutter/widgets/root.dart';

import 'data/store.dart';
import 'misc/flutter_redux_hooks.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
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
