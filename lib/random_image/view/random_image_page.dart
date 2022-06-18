import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/random_image/bloc/random_image_bloc.dart';

class RandomImagePage extends StatelessWidget {
  const RandomImagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RandomImageBloc, RandomImageState>(
      builder: (context, state) {
        if (state is RandomImageError) {
          return Center(
            child: Text('Error: ${state.errorMessage}'),
          );
        } else if (state is RandomImageLoaded) {
          return Column(
            children: [
              Expanded(
                child: Image.file(
                  File(state.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<RandomImageBloc>().add(const LoadARandomImage());
                },
                child: const Text('Fetch Random Image'),
              ),
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
