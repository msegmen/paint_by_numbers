import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

Future<String> downloadImageFromUrl(Uri url) async {
  final response = await http.get(url);

  // Get the image name
  final imageName = path.basename(url.path);
  // Get the document directory path
  final appDir = await path_provider.getApplicationDocumentsDirectory();

  // This is the saved image path
  // You can use it to display the saved image later
  final localPath = path.join(appDir.path, imageName);

  // Downloading
  final imageFile = File(localPath);
  await imageFile.writeAsBytes(response.bodyBytes);

  return localPath;
}
