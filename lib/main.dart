// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:my_app/app/app.dart';
import 'package:my_app/bootstrap.dart';
import 'package:provider/provider.dart';
import 'package:unsplash_client/unsplash_client.dart';

void main() async {
  final client = UnsplashClient(
    settings: const ClientSettings(
      credentials: AppCredentials(
        accessKey: 'QuF6mmEYCPe-RarU8SGilqOGyJYi7wYa1PJ5pvvlNKY',
        secretKey: 'LP2whHcwscOXY0fOzUt4XKb_EDQ4gjpbJDsmdAu1P0w',
      ),
    ),
  );
  await bootstrap(
    () => Provider.value(
      value: client,
      child: const App(),
    ),
  );
}
