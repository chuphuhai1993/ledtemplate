import 'package:flutter/services.dart';
import 'dart:convert';

/// Helper class to automatically discover frames from assets
class FrameAssets {
  static Future<List<String>> getAvailableFrames() async {
    try {
      // Load the asset manifest
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Filter for frame JSON files
      final frames =
          manifestMap.keys
              .where(
                (String key) =>
                    key.startsWith('assets/frames/') && key.endsWith('.json'),
              )
              .toList();

      // Sort alphabetically
      frames.sort();

      return frames;
    } catch (e) {
      // Fallback to empty list if manifest loading fails
      return [];
    }
  }

  /// Get thumbnail path for a frame
  /// Converts frame_1.json -> frame_1.jpg
  static String getFrameThumbnail(String framePath) {
    return framePath.replaceAll('.json', '.jpg');
  }
}
