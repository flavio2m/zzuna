import 'dart:io';

Future<String> saveAndDownloadFileImpl({
  required List<int> bytes,
  required String fileName,
}) async {
  final home = Platform.environment['HOME'];
  String downloadsDirPath;
  if (home != null &&
      home.isNotEmpty &&
      Directory('$home/Downloads').existsSync()) {
    downloadsDirPath = '$home/Downloads';
  } else {
    downloadsDirPath = Directory.current.path;
  }

  final filePath = '$downloadsDirPath/$fileName';
  final file = File(filePath);
  await file.writeAsBytes(bytes);
  return filePath;
}
