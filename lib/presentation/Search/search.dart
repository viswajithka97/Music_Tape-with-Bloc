import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_tape/core/db_model.dart';
import 'package:music_tape/presentation/Player/openplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class Search extends StatefulWidget {
  List<Audio> fullSongs = [];
  Search({Key? key, required this.fullSongs}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final box = Songbox.getInstance();
  String search = "";

  List<Songmodel> dbSongs = [];
  List<Audio> allSongs = [];

  searchSongs() {
    dbSongs = box.get("musics") as List<Songmodel>;
    // ignore: avoid_function_literals_in_foreach_calls
    dbSongs.forEach(
      (element) {
        allSongs.add(
          Audio.file(
            element.songurl.toString(),
            metas: Metas(
                title: element.songname,
                id: element.id.toString(),
                artist: element.artist),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    searchSongs();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    List<Audio> searchTitle = allSongs.where((element) {
      return element.metas.title!.toLowerCase().startsWith(
            search.toLowerCase(),
          );
    }).toList();

    List<Audio> searchArtist = allSongs.where((element) {
      return element.metas.artist!.toLowerCase().startsWith(
            search.toLowerCase(),
          );
    }).toList();

    List<Audio> searchResult = [];
    if (searchTitle.isNotEmpty) {
      searchResult = searchTitle;
    } else {
      searchResult = searchArtist;
    }

    return SafeArea(
      child: Container(
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
            iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              'Search',
              style: TextStyle(color: Colors.black),
            ),
          ),
          // ignore: sized_box_for_whitespace
          body: Container(
            height: height,
            width: width,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: MediaQuery.of(context).size.height * .07,
                  width: MediaQuery.of(context).size.width * .9,
                  child: TextField(
                    cursorHeight: 18.h,
                    cursorColor: Colors.black,
                    decoration:  InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(top: 14.h, right: 10.w, left: 10.w),
                      suffixIcon:const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      hintText: ' Search a song',
                      filled: true,
                      fillColor: const
                      Color(0xFFAB76E0),
                    ),
                    onChanged: (value) {
                      setState(
                        () {
                          search = value.trim();
                        },
                      );
                    },
                  ),
                ),
                search.isNotEmpty
                    ? searchResult.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: searchResult.length,
                              itemBuilder: (context, index) {
                                return FutureBuilder(
                                  future: Future.delayed(
                                    const Duration(microseconds: 0),
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return GestureDetector(
                                        onTap: () {
                                          OpenPlayer(
                                                  fullSongs: searchResult,
                                                  index: index, SongId: widget.fullSongs[index].metas.id.toString(), 
                                                  
                                                  )
                                              .openAssetPlayer(
                                                  index: index,
                                                  songs: searchResult);
                                        },
                                        child: ListTile(
                                          leading: SizedBox(
                                            height: 50.h,
                                            width: 50.w,
                                            child: QueryArtworkWidget(
                                              id: int.parse(searchResult[index]
                                                  .metas
                                                  .id!),
                                              type: ArtworkType.AUDIO,
                                              artworkBorder:
                                                  BorderRadius.circular(15),
                                              artworkFit: BoxFit.cover,
                                              nullArtworkWidget: Container(
                                                height: 50.h,
                                                width: 50.w,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/logodefault.jpg"),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            searchResult[index].metas.title!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style:  TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          subtitle: Text(
                                            searchResult[index].metas.artist!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style:  TextStyle(
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return Container();
                                  },
                                );
                              },
                            ),
                          )
                        :  Padding(
                            padding: EdgeInsets.all(30.h.w),
                            child: Text(
                              "No Result Found",
                              style: TextStyle(
                                
                                fontSize: 20.sp,
                              ),
                            ),
                          )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
