import 'file_saver_stub.dart'
    if (dart.library.html) 'file_saver_web.dart'
    if (dart.library.io) 'file_saver_io.dart';

class FileSaverService {
  static Future<String> saveAndDownloadFile({
    required List<int> bytes,
    required String fileName,
  }) => saveAndDownloadFileImpl(bytes: bytes, fileName: fileName);
}
