import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:infinite_list/infinite_list_observer.dart';

import 'app.dart';


void main() {
  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: InfiniteListObserver(),
  );
}