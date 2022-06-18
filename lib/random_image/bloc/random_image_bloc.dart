import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_app/bridge_generated.dart';
import 'package:unsplash_client/unsplash_client.dart';

part 'random_image_event.dart';
part 'random_image_state.dart';

class RandomImageBloc extends Bloc<RandomImageEvent, RandomImageState> {
  RandomImageBloc({required UnsplashClient client, required ImageCrateImpl imageApi,})
      : _client = client,
      _imageApi = imageApi,
        super(RandomImageInitial()){
    on<_RandomImageStarted>(_onRandomImageStarted);


    add(const _RandomImageStarted());
  }

  final UnsplashClient _client;
  final ImageCrateImpl _imageApi;

  FutureOr<void> _onRandomImageStarted(
    _RandomImageStarted event,
    Emitter<RandomImageState> emit,
  ) async {
    final result = await _imageApi.greet();
    log(result);
    // final photos = await _client.photos
    //     .random(
    //       count: 1,
    //       orientation: PhotoOrientation.landscape,
    //     )
    //     .goAndGet();

    // final photo = photos.first;
  }

}
