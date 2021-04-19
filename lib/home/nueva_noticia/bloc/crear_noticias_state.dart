part of 'crear_noticias_bloc.dart';

abstract class CrearNoticiasState extends Equatable {
  const CrearNoticiasState();
  
  @override
  List<Object> get props => [];
}

class CrearNoticiasInitial extends CrearNoticiasState {}

class LoadingState extends CrearNoticiasState {}

class PickedImageState extends CrearNoticiasInitial {
  final File image;

  PickedImageState({@required this.image});
  @override
  List<Object> get props => [image];
}

class SavedNewState extends CrearNoticiasInitial {
  List<Object> get props => [];
}

class ErrorMessageState extends CrearNoticiasInitial {
  final String errorMsg;

  ErrorMessageState({@required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
