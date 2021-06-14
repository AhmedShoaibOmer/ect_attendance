import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocaleInitialState());

  void switchLocale(Locale locale) {
    if (locale == Locale('ar')) {
      emit(LocaleChangedState(Locale('en')));
    } else {
      emit(LocaleChangedState(Locale('ar')));
    }
  }
}

abstract class LocaleState {
  final Locale locale;

  const LocaleState(this.locale);
}

class LocaleInitialState extends LocaleState {
  LocaleInitialState() : super(null);
}

class LocaleChangedState extends LocaleState {
  LocaleChangedState(Locale locale) : super(locale);
}
