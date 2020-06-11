import 'dart:math';

import 'package:flutter_map/flutter_map.dart';

class MapTileUtils {
  ///
  /// Default TileMap
  ///
  static final TileLayerOptions defaultTile = cyberJapanPale;
  //static final TileLayerOptions defaultTile = osm;

  static final TileLayerOptions osm = TileLayerOptions(
    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
    subdomains: ['a', 'b', 'c'],
  );

  static final TileLayerOptions cyberJapanPale = TileLayerOptions(
    urlTemplate: "https://cyberjapandata.gsi.go.jp/xyz/pale/{z}/{x}/{y}.png",
  );

  static TileLayerOptions getDefaultTileMap() {
    Random random = Random();

    if (defaultTile.subdomains != null) {
      return TileLayerOptions(
        urlTemplate: defaultTile.urlTemplate + "?uuu=${random.nextInt(999)}",
        subdomains: defaultTile.subdomains,
      );
    } else {
      return TileLayerOptions(
        urlTemplate: defaultTile.urlTemplate + "?uuu=${random.nextInt(999)}",
      );
    }
  }
}
