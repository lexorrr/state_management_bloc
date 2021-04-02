import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class DarkTheme extends ThemeEvent {
  const DarkTheme();
}

class LightTheme extends ThemeEvent {
  const LightTheme();
}

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeData> {
  ThemeBloc() : super(ThemeData.light());

  static final _lightTheme = ThemeData.light();
  static final _darkTheme = ThemeData.dark();

  @override
  Stream<ThemeData> mapEventToState(ThemeEvent event) async* {
    if (event is LightTheme) {
      yield _lightTheme;
    }

    if (event is DarkTheme) {
      yield _darkTheme;
    }
  }

  @override
  ThemeData fromJson(Map<String, dynamic> source) {
    try {
      if (source['light'] as bool) {
        return ThemeData.light();
      }

      return ThemeData.dark();
    } catch(_) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(ThemeData state) {
    try {
      return {
        'light': state != ThemeData.light()
      };
    } catch(_) {
      return null;
    }
  }
}