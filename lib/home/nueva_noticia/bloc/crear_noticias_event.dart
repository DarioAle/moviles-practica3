part of 'crear_noticias_bloc.dart';

abstract class CrearNoticiasEvent extends Equatable {
  const CrearNoticiasEvent();

  @override
  List<Object> get props => [];
}

class SaveNewElementEvent extends CrearNoticiasEvent {
  final New noticia;

  SaveNewElementEvent({@required this.noticia});
  @override
  List<Object> get props => [noticia];
}

class PickImageEvent extends CrearNoticiasEvent {
  @override
  List<Object> get props => [];
}
