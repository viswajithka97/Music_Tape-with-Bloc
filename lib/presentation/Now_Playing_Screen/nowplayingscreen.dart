import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_tape/application/FavIcon/favicon_bloc.dart';
import 'package:music_tape/core/db_model.dart';
import 'package:music_tape/presentation/Playlist/playlistlist.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class NowPlayingScreen extends StatelessWidget {
  int index;
  List<Audio> fullSongs = [];
  NowPlayingScreen({
    Key? key,
    required this.index,
    required this.fullSongs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    bool isLooping = false;
    bool isShuffle = false;
    Songmodel? music;

    final AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');

    Audio find(List<Audio> source, String fromPath) {
      return source.firstWhere((element) => element.path == fromPath);
    }

    final box = Songbox.getInstance();
    List<Songmodel> dbSongs = [];
    List<dynamic>? likedSongs = [];
    dbSongs = box.get("musics") as List<Songmodel>;

    //final temp = databaseSongs(dbSongs, songId);
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
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Now Playing',
            style: TextStyle(fontSize: 25.sp, color: Colors.black),
          ),
          backgroundColor: const Color.fromARGB(255, 146, 93, 199),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 30.sp,
                  color: Colors.black,
                ))
          ],
        ),
        body: player.builderCurrent(builder: (context, Playing? playing) {
          final myAudio = find(fullSongs, playing!.audio.assetAudioPath);
          final currentSong = dbSongs.firstWhere((element) =>
              element.id.toString() == myAudio.metas.id.toString());

          likedSongs = box.get("favourites");

          return Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(50.0.h.w),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        height: 380.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)),
                        child: QueryArtworkWidget(
                            id: int.parse(myAudio.metas.id!),
                            artworkQuality: FilterQuality.high,
                            quality: 100,
                            size: 2000,
                            artworkFit: BoxFit.cover,
                            artworkBorder: BorderRadius.circular(20.0.r),
                            nullArtworkWidget: ClipRRect(
                                borderRadius: BorderRadius.circular(20.r),
                                child:
                                    Image.asset('asset/images/musicgif.gif')),
                            type: ArtworkType.AUDIO),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 152, 113, 214)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: const BorderSide(
                                              color: Colors.white)))),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        PlaylistList(song: currentSong));
                              },
                              icon: const Icon(Icons.queue_music),
                              label: const Text('Add to Playlist'))
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      player.builderRealtimePlayingInfos(
                          builder: (context, RealtimePlayingInfos infos) {
                        return ProgressBar(
                            onSeek: (slide) {
                              player.seek(slide);
                            },
                            timeLabelPadding: 15,
                            progressBarColor:
                                const Color.fromARGB(255, 171, 112, 226),
                            baseBarColor:
                                const Color.fromARGB(255, 210, 180, 223),
                            barHeight: 10.h,
                            thumbRadius: 15.h.w,
                            thumbColor: const Color.fromARGB(255, 126, 73, 150),
                            timeLabelTextStyle:
                                TextStyle(color: Colors.black, fontSize: 17.sp),
                            progress: infos.currentPosition,
                            total: infos.duration);
                      }),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          BlocBuilder<FaviconBloc, FaviconState>(
                              builder: (context, state) {
                              return !isShuffle
                                  ? IconButton(
                                      onPressed: () {
                                       
                                          isShuffle = true;
                                          player.toggleShuffle();
                                       context.read<FaviconBloc>().add(
                                              FaviconChangeEvent(
                                                  iconData: Icons.shuffle));
                                      },
                                      icon: Icon(
                                        Icons.shuffle,
                                        size: 35.w.h,
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                    
                                          isShuffle = false;
                                          player.setLoopMode(LoopMode.playlist);
                                    context.read<FaviconBloc>().add(
                                              FaviconChangeEvent(
                                                  iconData: Icons.cached));
                                      },
                                      icon: Icon(
                                        Icons.cached,
                                        size: 35.h.w,
                                      ),
                                    );
                            },
                          ),
                          Container(
                            height: 50.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xFFAB76E0),
                            ),
                            child: BlocBuilder<FaviconBloc, FaviconState>(
                              builder: (context, state) {
                                return likedSongs!
                                        .where((element) =>
                                            element.id.toString() ==
                                            currentSong.id.toString())
                                        .isEmpty
                                    ? IconButton(
                                        onPressed: () async {
                                          likedSongs?.add(currentSong);
                                          box.put("favourites", likedSongs!);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                currentSong.songname! +
                                                    " Added to Favourites",
                                              ),
                                            ),
                                          );
                                          likedSongs = box.get("favourites");
                                          context.read<FaviconBloc>().add(
                                              FaviconChangeEvent(
                                                  iconData: Icons.favorite));
                                        },
                                        icon: Icon(
                                          Icons.favorite_border,
                                          size: 35.h.w,
                                        ))
                                    : IconButton(
                                        onPressed: () async {
                                          likedSongs?.removeWhere((elemet) =>
                                              elemet.id.toString() ==
                                              currentSong.id.toString());
                                          box.put("favourites", likedSongs!);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                currentSong.songname! +
                                                    " Removed from Favourites",
                                              ),
                                            ),
                                          );
                                          context.read<FaviconBloc>().add(
                                              FaviconChangeEvent(
                                                  iconData: Icons
                                                      .favorite_outline_outlined));
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                          color: const Color.fromARGB(
                                              255, 189, 69, 61),
                                          size: 35.h.w,
                                        ),
                                      );
                              },
                            ),
                          ),
                          BlocBuilder<FaviconBloc, FaviconState>(
                            builder: (context, state) {
                              return !isLooping
                                  ? IconButton(
                                      onPressed: () {
                                        isLooping = true;
                                        player.setLoopMode(
                                          LoopMode.single,
                                        );
                                        context.read<FaviconBloc>().add(
                                            FaviconChangeEvent(
                                                iconData:
                                                    Icons.repeat_rounded));
                                      },
                                      icon: Icon(
                                        Icons.repeat,
                                        size: 35.h.w,
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        isLooping = false;
                                        player.setLoopMode(LoopMode.playlist);
                                        context.read<FaviconBloc>().add(
                                            FaviconChangeEvent(
                                                iconData: Icons.repeat_one));
                                      },
                                      icon: Icon(
                                        Icons.repeat_one,
                                        size: 35.h.w,
                                      ),
                                    );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          player.previous();
                        },
                        icon: Icon(Icons.skip_previous,
                            size: 40.h.w, color: Colors.white)),
                    Container(
                      height: 80.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: Colors.white),
                      child: PlayerBuilder.isPlaying(
                          player: player,
                          builder: (context, isPlaying) {
                            return IconButton(
                              onPressed: () async {
                                await player.playOrPause();
                              },
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 50.h.w,
                              ),
                            );
                          }),
                    ),
                    IconButton(
                        onPressed: () {
                          player.next();
                        },
                        icon: Icon(Icons.skip_next,
                            size: 40.h.w, color: Colors.white)),
                     
                  ],
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
