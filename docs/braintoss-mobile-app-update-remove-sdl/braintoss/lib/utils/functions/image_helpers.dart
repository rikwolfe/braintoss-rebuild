import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'generators.dart';

Future<XFile> compressImage(String path, String newFilename) async {
  Directory targetDirectory = await getApplicationDocumentsDirectory();
  String targetPath = "${targetDirectory.path}/$newFilename";

  XFile? compressedImage = await FlutterImageCompress.compressAndGetFile(
      path, targetPath,
      quality: 90, format: CompressFormat.jpeg);

  if (compressedImage == null) {
    throw Exception("Could not compress image.");
  }
  return Future.value(compressedImage);
}

Future<String> downloadImage(String url) async {
  try {
    Directory targetDirectory = await getApplicationDocumentsDirectory();
    String filename = generateUUIDv1();
    String downloadPath = "${targetDirectory.path}/$filename.jpg";

    Dio dio = Dio();

    Response<dynamic> response = await dio.download(url, downloadPath);
    if (response.statusCode == 200) {
      return downloadPath;
    } else {
      throw Exception(response.statusMessage);
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}
