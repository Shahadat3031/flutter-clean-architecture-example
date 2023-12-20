part of 'character_page_bloc.dart';

class CharacterPageEvent extends Equatable {
  const CharacterPageEvent();

  @override
  List<Object?> get props => [];
}

class FetchNextPageEvent extends CharacterPageEvent {
  const FetchNextPageEvent();
}
