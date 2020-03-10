import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

void main() => runApp(CounterApp());

class CounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Counter>(
        create: (context) => Counter(),
        child: MaterialApp(home: ScreenCounter()));
  }
}

class ScreenCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context, listen: false);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Consumer<Counter>(
                builder: (context, counter, child) => Text('${counter.value}')),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => counter.decrement(),
                  child: Text('-'),
                ),
                RaisedButton(
                  onPressed: () => counter.reset(),
                  child: Text('↺'),
                ),
                RaisedButton(
                  onPressed: () => counter.increment(),
                  child: Text('+'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Counter extends ChangeNotifier {
  int value = 0;

  void increment() {
    value++;
    notifyListeners();
  }

  void decrement() {
    value--;
    notifyListeners();
  }

  void reset() {
    value = 0;
    notifyListeners();
  }
}
