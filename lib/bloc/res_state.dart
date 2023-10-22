import 'package:flutter_ais_bottombar/bloc/res_bloc.dart';

abstract class ResState {}

class ResInitialState extends ResState {}

class ResLoadingState extends ResState {}

class ResLoadedState extends ResState {
  final List<Photo> photos;

  ResLoadedState(this.photos);
}

class ResErrorState extends ResState {
  final String message;

  ResErrorState(this.message);
}
