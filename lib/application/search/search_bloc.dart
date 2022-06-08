import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:music_tape/core/db_model.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchBlocInitial(fullSongs: [])) {
    on<SerachInputEvent>((event, emit) {
      
      final box = Songbox.getInstance();
      List<Songmodel> dbSongs = [];
      List<Audio> allSongs = [];
      dbSongs = box.get("musics") as List<Songmodel>;
      for (var element in dbSongs) {
        allSongs.add(
          Audio.file(
            element.songurl.toString(),
            metas: Metas(
              title: element.songname,
              id: element.id.toString(),
              artist: element.artist,
            ),
          ),
        );
      }
      List<Audio> searchTitle = allSongs.where((element) {
        return element.metas.title!.toLowerCase().startsWith(
              event.search.toLowerCase(),
            );
      }).toList();

      List<Audio> searchArtist = allSongs.where((element) {
        return element.metas.artist!.toLowerCase().startsWith(
              event.search.toLowerCase(),
            );
      }).toList();

      List<Audio> searchResult = allSongs;
      if (searchTitle.isNotEmpty) {
        searchResult = searchTitle;
      } else {
        searchResult = searchArtist;
      }

      emit(SearchBlocInitial(fullSongs: searchResult));

    });
  }
}
