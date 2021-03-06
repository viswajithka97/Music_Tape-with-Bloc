import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_tape/application/search/search_bloc.dart';
import 'package:music_tape/presentation/Player/openplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class Search extends StatelessWidget {
  List<Audio> fullSongs = [];
  Search({Key? key, required this.fullSongs}) : super(key: key);

  String search = "";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
                  child: TextField(
                    cursorHeight: 18.h,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(top: 14.h, right: 10.w, left: 10.w),
                      suffixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      hintText: ' Search a song',
                      filled: true,
                      fillColor: const Color(0xFFAB76E0),
                    ),
                    onChanged: (value) async {
                      search = value.trim();
                      context
                          .read<SearchBloc>()
                          .add(SerachInputEvent(search: value));
                    },
                  ),
                ),
                BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                                      List<Audio> searchResult = state.props as List<Audio>;

                    return   search.isNotEmpty
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
                                            index: index,
                                            SongId: fullSongs[index].metas.id
                                                .toString(),
                                          ).openAssetPlayer(
                                              index: index,
                                              songs: searchResult);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 10.0.h,
                                              left: 10.0.w,
                                              right: 10.0.w),
                                          child: Container(
                                            height: 75,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: const Color.fromARGB(
                                                    106, 217, 197, 218)),
                                            child: ListTile(
                                              leading: Container(
                                                height: 50,
                                                width: 50,
                                                child: QueryArtworkWidget(
                                                  id: int.parse(
                                                      searchResult[index]
                                                          .metas
                                                          .id!),
                                                  type: ArtworkType.AUDIO,
                                                  artworkBorder:
                                                      BorderRadius.circular(5),
                                                  artworkFit: BoxFit.cover,
                                                  nullArtworkWidget: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Image.asset(
                                                        "asset/images/new3.png"),
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                searchResult[index]
                                                    .metas
                                                    .title!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              subtitle: Text(
                                                searchResult[index]
                                                    .metas
                                                    .artist!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              trailing: Icon(
                                                Icons.play_circle_fill,
                                                size: 30,
                                              ),
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
                        : Padding(
                            padding: EdgeInsets.all(30.h.w),
                            child: Text(
                              "No Result Found",
                              style: TextStyle(
                                fontSize: 20.sp,
                              ),
                            ),
                          )
                    : const SizedBox();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
