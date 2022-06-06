import 'package:hive/hive.dart';
part 'db_model.g.dart';

@HiveType(typeId: 0)
class Songmodel {
  Songmodel(
      {required this.songname,
      required this.artist,
      required this.songurl,
      required this.duration,
      required this.id});

  @HiveField(0)
  String? songname;
  @HiveField(1)
  String? artist;
  @HiveField(2)
  String? songurl;
  @HiveField(3)
  int? duration;
  @HiveField(4)
  int? id;
}

String boxname = "songs";

class Songbox {
  static Box<List>? _box;

  static Box<List> getInstance() {
    return _box ??= Hive.box(boxname);
  }
}
