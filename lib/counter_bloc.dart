import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:replay_bloc/replay_bloc.dart';
import 'package:state_management_bloc/states.dart';

// using enum
// enum CounterEvent { increment, decrement }
//
// class CounterBloc extends Bloc<CounterEvent, int> {
//   CounterBloc() : super(0);
//
//   @override
//   Stream<int> mapEventToState(CounterEvent event) async* {
//     switch (event) {
//       // 'state' is a getter defined inside Bloc<E,S> which
//       // represents the current state of the bloc
//       case CounterEvent.increment:
//         // yield ++state not working
//         yield state + 1;
//         break;
//       case CounterEvent.decrement:
//       // yield --state not working
//         yield state - 1;
//     }
//   }
// }

// using class (migrated to states.dart)
// abstract class CounterEvent extends Equatable {
//   const CounterEvent();
//
//   @override
//   List<Object> get props => [];
// }
//
// class Increment extends CounterEvent {
//   const Increment();
// }
//
// class Decrement extends CounterEvent {
//   const Decrement();
// }

class CounterState extends Equatable {
  final int count;

  const CounterState(this.count);

  @override
  List<Object> get props => [count];
}

class CounterBloc extends ReplayBloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(0));

  @override
  Stream<CounterState> mapEventToState(CounterEvent event) async* {
    if (event is Increment) {
      final newCount = state.count + 1;
      yield CounterState(newCount);
    } else if (event is Decrement) {
      final newCount = state.count - 1;
      yield CounterState(newCount);
    }
  }
}

