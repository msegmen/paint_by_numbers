import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:unsplash_client/unsplash_client.dart';

part 'random_image_event.dart';
part 'random_image_state.dart';

class RandomImageBloc extends Bloc<RandomImageEvent, RandomImageState> {
  RandomImageBloc({required UnsplashClient client})
      : _client = client,
        super(RandomImageInitial()) {
    on<_RandomImageStarted>(_onRandomImageStarted);

    add(const _RandomImageStarted());
  }

  FutureOr<void> _onRandomImageStarted(
    _RandomImageStarted event,
    Emitter<RandomImageState> emit,
  ) async {
    final photos = await _client.photos
        .random(
          count: 1,
          orientation: PhotoOrientation.landscape,
        )
        .goAndGet();

    final photo = photos.first;
  }

  final UnsplashClient _client;
}
