import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:state_management_bloc/counter_bloc.dart';
import 'package:state_management_bloc/my_observer.dart';
import 'package:state_management_bloc/states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  Bloc.observer = MyObserver();
  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('State Management Using BLoC'),
      ),
      // Yes, provide is used internally by the bloc library
      // to expose instance of blocs to the children widgets
      body: BlocProvider<CounterBloc>(
        create: (context) => CounterBloc(),
        child: const DemoPage(),
      ),
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage();

  void _showBar(BuildContext context) {
    Flushbar(
      message: 'The counter has been altered!',
      duration: Duration(seconds: 1),
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CounterBloc, CounterState>(
      listenWhen: (previousState, currentState) =>
          (previousState.count != currentState.count) &&
          (currentState.count > 5),
      listener: (context, counterState) {
        _showBar(context);
      },
      child: Column(
        children: const [
          ButtonsAndText(),
          AniContainer(),
        ],
      ),
    );
  }
}

class ButtonsAndText extends StatelessWidget {
  const ButtonsAndText();

  @override
  Widget build(BuildContext context) {
    // For older versions of Dart that don't use extension
    // methods, simply go for:
    // final counterBloc = BlocProvider.of<CounterBloc>(context);
    // ignore: close_sinks
    final counterBloc = context.watch<CounterBloc>();

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
            child: const Text(
              '+1',
              style: TextStyle(color: Colors.green, fontSize: 25),
            ),
            // onPressed: () => counterBloc.add(CounterEvent.increment), // using enum
            onPressed: () => counterBloc.add(Increment()), // using class
          ),
          // BlocBuilder<CounterBloc, int>( // using enum
          BlocBuilder<CounterBloc, CounterState>(
            // using class
            // builder: (context, count) => // using enum
            builder: (context, counterState) => // using class
                Text(
              // '$count', // using enum
              '${counterState.count}', // using class
              style: const TextStyle(fontSize: 30),
            ),
          ),
          TextButton(
            child: const Text(
              '-1',
              style: TextStyle(color: Colors.green, fontSize: 25),
            ),
            // onPressed: () => counterBloc.add(CounterEvent.decrement), // using enum
            onPressed: () => counterBloc.add(Decrement()), // using class
          ),
          TextButton(
            child: const Text(
              'Undo',
              style: TextStyle(color: Colors.green, fontSize: 25),
            ),
            // onPressed: () => counterBloc.add(CounterEvent.decrement), // using enum
            onPressed: () => counterBloc.undo(), // using class
          ),
          TextButton(
            child: const Text(
              'Redo',
              style: TextStyle(color: Colors.green, fontSize: 25),
            ),
            // onPressed: () => counterBloc.add(CounterEvent.decrement), // using enum
            onPressed: () => counterBloc.redo(), // using class
          ),
        ],
      ),
    );
  }
}

class AniContainer extends StatelessWidget {
  const AniContainer();

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<CounterBloc, CounterState>(
      builder: (context, counterState) =>
      AnimatedContainer(
        height: counterState.count.toDouble() * 5,
        width: counterState.count.toDouble() * 5,
        color: counterState.count % 2 == 0 ? Colors.lightBlue : Colors.lime,
        alignment: counterState.count < 500 ? Alignment.center : Alignment.topCenter,
        curve: Curves.easeOut,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

