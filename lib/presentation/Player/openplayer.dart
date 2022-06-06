import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_tape/core/db_model.dart';

class OpenPlayer {
  List<Audio> fullSongs;
  int index;
  bool? notify;
  // ignore: non_constant_identifier_names
  final String SongId;
  final box = Songbox.getInstance();

  List<Songmodel> recentSongs = [];

  OpenPlayer(
      // ignore: non_constant_identifier_names
      {required this.fullSongs, required this.index, required this.SongId});

  final AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');

  openAssetPlayer({
    List<Audio>? songs,
    required int index,
  }) async {
    player.open(
      Playlist(audios: songs, startIndex: index),
      showNotification: notify == null || notify == true ? true : false,
      notificationSettings: const NotificationSettings(
        stopEnabled: false,
      ),
      autoStart: true,
      loopMode: LoopMode.playlist,
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      playInBackground: PlayInBackground.enabled,
    );

    recentSongs = box.get("musics") as List<Songmodel>;

    final temp = findwatchlaterSongs(recentSongs, SongId);

    List? recentplay = box.get("Recently_Played");
    recentplay!.where((element) => element.id.toString() == temp.id.toString()).isEmpty  ?
     addtorecent(recentplay,temp)
      :  null;

  }

  Songmodel findwatchlaterSongs(List<Songmodel> recently, String id) {
    return recently
        .firstWhere((element) => element.songurl.toString().contains(id));
  }
   addtorecent(List recentplay,temp) {
   if(recentplay.length<10){
     recentplay.add(temp);
     box.put('Recently_Played', recentplay);
   }else{
     recentplay.removeAt(0);
     recentplay.add(temp);
     box.put('Recently_Played', recentplay);
   }
    } 

}
