part of 'random_image_bloc.dart';

@immutable
abstract class RandomImageState {
  const RandomImageState();
}

class RandomImageInitial extends RandomImageState {
  const RandomImageInitial();
}

class RandomImageLoading extends RandomImageState {
  const RandomImageLoading();
}

class RandomImageError extends RandomImageState {
  const RandomImageError(this.errorMessage);

  final String errorMessage;
}

class RandomImageLoaded extends RandomImageState {
  const RandomImageLoaded(this.imagePath);

  final String imagePath;
}
