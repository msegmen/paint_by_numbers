import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/random_image/bloc/random_image_bloc.dart';

class RandomImagePage extends StatelessWidget {
  const RandomImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RandomImageBloc, RandomImageState>(
      builder: (context, state) {
        return Container();
      },
    );
  }
}
