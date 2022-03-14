library flutter_redux;

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart'
    show use, Hook, HookState, useStream;
import 'package:insomnia_keeper_flutter/data/misc.dart';
import 'package:redux/redux.dart';

class StoreProvider<S> extends InheritedWidget {
  final Store<S> _store;

  const StoreProvider({
    Key? key,
    required Store<S> store,
    required Widget child,
  })  : _store = store,
        super(key: key, child: child);

  static Store<S> of<S>(BuildContext context, {bool listen = true}) {
    final provider = (
        listen
        ? context.dependOnInheritedWidgetOfExactType<StoreProvider<S>>()
        : context.getElementForInheritedWidgetOfExactType<StoreProvider<S>>()?.widget
    ) as StoreProvider<S>?;

    if (provider == null) {
      final type = _typeOf<StoreProvider<S>>();
      throw StoreProviderError(type);
    }

    return provider._store;
  }

  static Type _typeOf<T>() => T;

  @override
  bool updateShouldNotify(StoreProvider<S> oldWidget) => _store != oldWidget._store;
}

class StoreProviderError extends Error {
  Type type;

  StoreProviderError(this.type);

  @override
  String toString() {
    return '''Error: No $type found. To fix, please try:
  * Wrapping your MaterialApp with the StoreProvider<State>,
  rather than an individual Route
  * Providing full type information to your Store<State>,
  StoreProvider<State> and StoreConnector<State, ViewModel>
  * Ensure you are using consistent and complete imports.
  E.g. always use `import 'package:my_app/app_state.dart';
If none of these solutions work, please file a bug at:
https://github.com/brianegan/flutter_redux/issues/new
      ''';
  }
}

Store<S> useStore<S>() => use(_UseStoreHook());

class _UseStoreHook<S> extends Hook<Store<S>> {
  @override
  HookState<Store<S>, Hook<Store<S>>> createState() => _UseStoreHookState<S>();
}

class _UseStoreHookState<S> extends HookState<Store<S>, _UseStoreHook<S>> {
  @override
  Store<S> build(BuildContext context) => StoreProvider.of<S>(context);
}

typedef Dispatch = dynamic Function(dynamic action);

Dispatch useDispatch<S>() => useStore<S>().dispatch;

typedef Selector<State, Output> = Output Function(State state);

typedef EqualityFn<T> = bool Function(T a, T b);

dynamic useSelector<State, Output>(dynamic selector, [EqualityFn? equalityFn]) {
  final store = useStore<State>();
  final snap = useStream<dynamic>(
      store.onChange.map(selector).distinct(equalityFn),
      initialData: selector(store.state)
  );
  return snap.data;
}
