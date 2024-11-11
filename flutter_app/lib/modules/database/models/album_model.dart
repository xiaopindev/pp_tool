import 'package:flutter/foundation.dart';

class AlbumModel {
  int? uid;
  String name;
  Uint8List? imageDatas;
  int trackCounts;

  AlbumModel({
    this.uid,
    this.name = '',
    this.imageDatas,
    this.trackCounts = 0,
  });

  // 将 Album 对象转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'image_datas': imageDatas,
      'track_counts': trackCounts,
    };
  }

  // 从 Map 创建 Album 对象
  factory AlbumModel.fromMap(Map<String, dynamic> map) {
    return AlbumModel(
      uid: map['uid'],
      name: map['name'],
      imageDatas: map['image_datas'],
      trackCounts: map['track_counts'],
    );
  }
}
