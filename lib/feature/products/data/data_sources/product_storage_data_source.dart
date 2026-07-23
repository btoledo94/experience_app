import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class ProductStorageDataSource {
  final FirebaseStorage _storage;

  ProductStorageDataSource(this._storage);

  Future<String> uploadProductImage({
    required String productId,
    required Uint8List bytes,
    required String fileName,
  }) async {
    final safeFileName = fileName
        .trim()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '');

    final objectPath =
        'products/$productId/${DateTime.now().millisecondsSinceEpoch}_$safeFileName';

    final ref = _storage.ref().child(objectPath);
    final metadata = SettableMetadata(contentType: _inferContentType(fileName));

    await ref.putData(bytes, metadata);
    return ref.getDownloadURL();
  }

  String _inferContentType(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    return 'image/jpeg';
  }
}
