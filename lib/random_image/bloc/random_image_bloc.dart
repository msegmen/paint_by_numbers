import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';
import 'package:my_app/bridge_generated.dart';
import 'package:my_app/utils/utils.dart';
import 'package:unsplash_client/unsplash_client.dart';

part 'random_image_event.dart';
part 'random_image_state.dart';

class RandomImageBloc extends Bloc<RandomImageEvent, RandomImageState> {
  RandomImageBloc({
    required UnsplashClient client,
    required NativeImpl imageApi,
  })  : _client = client,
        _imageApi = imageApi,
        super(RandomImageInitial()) {
    on<_RandomImageStarted>(_onRandomImageStarted);
    on<LoadARandomImage>(_onLoadARandomImage);

    add(const _RandomImageStarted());
  }

  final UnsplashClient _client;
  final NativeImpl _imageApi;
  StreamSubscription? _streamSubscription;

  FutureOr<void> _onRandomImageStarted(
    _RandomImageStarted event,
    Emitter<RandomImageState> emit,
  ) {
    add(const LoadARandomImage());
    return emit.forEach<String>(_imageApi.registerListener(), onData: (val) {
      log(val);
      return state;
    });
  }

  FutureOr<void> _onLoadARandomImage(
    LoadARandomImage event,
    Emitter<RandomImageState> emit,
  ) async {
    emit(const RandomImageLoading());
    try {
      final photos = await _client.photos
          .random(
            count: 1,
            orientation: PhotoOrientation.landscape,
          )
          .goAndGet();

      final photo = photos.first;
      final path = await downloadImageFromUrl(photo.urls.small);
      final imageBytes = await File.fromUri(Uri(path: path)).readAsBytes();
      final result = await _imageApi.tryReadImage(path: path, size: 96);

      emit(RandomImageLoaded(path));
    } catch (e) {
      emit(RandomImageError(e.toString()));
    }
  }
}
