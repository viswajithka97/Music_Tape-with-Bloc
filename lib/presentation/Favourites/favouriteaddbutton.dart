// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:music_tape/core/db_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavouriteAddSong extends StatefulWidget {
  
 const FavouriteAddSong({Key? key,}) : super(key: key);

  @override
  State<FavouriteAddSong> createState() => _FavouriteAddSongState();
}

class _FavouriteAddSongState extends State<FavouriteAddSong> {
  final box = Songbox.getInstance();

  List<Songmodel> dbSongs = [];
  List<Songmodel> playlistSongs = [];
  @override
  void initState() {
    super.initState();
    fullSongs();
  }

  fullSongs() {
    dbSongs = box.get("musics") as List<Songmodel>;

   
  }

  @override
  Widget build(BuildContext context) {
    var likedSongs = box.get("favourites");
    return ListView.builder(
      itemCount: dbSongs.length,
      itemBuilder: (context, index) {
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: SizedBox(
              height: 50.h,
              width: 50.w,
              child: QueryArtworkWidget(
                id: dbSongs[index].id!,
                type: ArtworkType.AUDIO,
                artworkBorder: BorderRadius.circular(15),
                artworkFit: BoxFit.cover,
                nullArtworkWidget: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    image: DecorationImage(
                      image: AssetImage("asset/images/new3.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              dbSongs[index].songname!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              dbSongs[index].artist!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: likedSongs!
                    .where((element) =>
                        element.id.toString() == dbSongs[index].id.toString())
                    .isEmpty
                ? IconButton(
                    onPressed: () async {
                     likedSongs.add(dbSongs[index]);
                      await box.put('favourites', likedSongs);

                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ))
                : IconButton(
                    onPressed: () async {
                      likedSongs.removeWhere((elemet) =>
                          elemet.id.toString() == dbSongs[index].id.toString());

                      await box.put('favourites', likedSongs);
                      setState(() {});
                    },
                    icon: const Icon(Icons.check_box, color: Colors.black),
                  ),
          ),
        );
      },
    );
  }
}
