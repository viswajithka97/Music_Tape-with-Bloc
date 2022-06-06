// ignore_for_file: file_names, implementation_imports

import 'package:assets_audio_player/assets_audio_player.dart';
// ignore: unnecessary_import
import 'package:assets_audio_player/src/playable.dart';
import 'package:flutter/material.dart';
import 'package:music_tape/core/db_model.dart';
import 'package:music_tape/presentation/My_Music/widgets/popupmenu.dart';
import 'package:music_tape/presentation/Player/openplayer.dart';
import 'package:music_tape/presentation/Search/search.dart';
import 'package:music_tape/presentation/Home/home.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
class MyMusic extends StatefulWidget {
  List<Audio> fullsongs = [];
  MyMusic({
    Key? key,
    required this.fullsongs,
  }) : super(key: key);

  List<SongModel> songs = [];
  @override
  State<MyMusic> createState() => _MyMusicState();
}

class _MyMusicState extends State<MyMusic> {
  final _audioQuery = OnAudioQuery();
  final box = Songbox.getInstance();

  List<Audio> fullSongs = [];
  List<SongModel> fetchedSongs = [];
  List<SongModel> allSongs = [];
  List<Songmodel> dbSongs = [];
  List<Songmodel> mappedSongs = [];
  final OnAudioQuery audio = OnAudioQuery();

  List<SongModel> songs = [];

  @override
  initState() {
    super.initState();
  }

  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId('0');

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.6, -0.10),
          colors: [
            Color(0xFFAD78E1),
            Color(0xFFB59CDA),
            Color(0xFFC28ADC),
            Color(0xFFAA8BE5),
            Color(0xFFAD78E1),
            Color(0xFFAB76E0),
          ],
          radius: 1.5,
          focalRadius: 15.5,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //  drawer: drawer(),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 146, 93, 199),
          iconTheme: IconThemeData(color: Colors.black, size: 35.h.w),
          title: Text(
            'Music Tape',
            style: TextStyle(fontSize: 25.sp, color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0.w),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            Search(fullSongs: widget.fullsongs)));
                  },
                  icon: const Icon(Icons.search)),
            )
          ],
        ),
        body: FutureBuilder<List<SongModel>>(
          future: _audioQuery.querySongs(
              sortType: null,
              orderType: OrderType.ASC_OR_SMALLER,
              uriType: UriType.EXTERNAL,
              ignoreCase: true),
          builder: (context, item) {
            if (item.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (item.data!.isEmpty) {
              return const Center(child: Text('No Songs Found'));
            }
            return RefreshIndicator(
              onRefresh: requestStoragePermission,
              child: ListView.builder(
                itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                        top: 10.0.h, left: 10.0.w, right: 10.0.w),
                    child: Container(
                      height: 75.h,
                      width: double.infinity.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(106, 217, 197, 218)),
                      child: ListTile(
                          visualDensity: const VisualDensity(
                            vertical: -3
                          ),
                          onTap: (() async {
                            final songid =
                                widget.fullsongs[index].metas.id.toString();

                            await OpenPlayer(
                                    fullSongs: [], index: index, SongId: songid)
                                .openAssetPlayer(
                              index: index,
                              songs: widget.fullsongs,
                            );
                           
                          }),
                          // ignore: sized_box_for_whitespace
                          leading: Container(
                            height: 50.h,
                            width: 50.w,
                            child: QueryArtworkWidget(
                                // artworkBlendMode: BlendMode.clear,
                                id: int.parse(widget.fullsongs[index].metas.id
                                    .toString()),
                                artworkBorder: BorderRadius.circular(5),
                                quality: 100,
                                artworkScale: 2000,
                                nullArtworkWidget: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child:
                                        Image.asset('asset/images/new3.png')),
                                // artworkClipBehavior: clip,
                                type: ArtworkType.AUDIO),
                          ),
                          title: Text(
                            widget.fullsongs[index].metas.title!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            widget.fullsongs[index].metas.artist!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: MusicListMenu(
                              songId:
                                  widget.fullsongs[index].metas.id.toString())),
                    )),
                itemCount: widget.fullsongs.length,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> requestStoragePermission() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
    setState(() {});

    fetchedSongs = await _audioQuery.querySongs();

    for (var element in fetchedSongs) {
      if (element.fileExtension == "mp3") {
        allSongs.add(element);
      }
    }
    mappedSongs = allSongs
        .map(
          (audio) => Songmodel(
              songname: audio.title,
              artist: audio.artist,
              songurl: audio.uri,
              duration: audio.duration,
              id: audio.id),
        )
        .toList();

    await box.put("musics", mappedSongs);
    dbSongs = box.get("musics") as List<Songmodel>;

    for (var element in dbSongs) {
      fullSongs.add(
        Audio.file(
          element.songurl.toString(),
          metas: Metas(
              title: element.songname,
              id: element.id.toString(),
              artist: element.artist),
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home(allsongs: fullSongs)),
          (route) => false);
    }
    setState(() {});
  }

  Songmodel findwatchlaterSongs(List<Songmodel> recently, String id) {
    return recently
        .firstWhere((element) => element.songurl.toString().contains(id));
  }
}
