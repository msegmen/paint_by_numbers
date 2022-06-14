part of 'random_image_bloc.dart';

@immutable
abstract class RandomImageEvent extends Equatable {
  const RandomImageEvent();

  @override
  List<Object> get props => [];
}

class _RandomImageStarted extends RandomImageEvent {
  const _RandomImageStarted();
}
