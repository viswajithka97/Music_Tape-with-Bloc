
import 'package:flutter/material.dart';
import 'package:music_tape/presentation/Folders/foldersonglist.dart';
import 'package:music_tape/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Folderslist extends StatefulWidget {
  const Folderslist({Key? key}) : super(key: key);

  @override
  State<Folderslist> createState() => _FolderslistState();
}

class _FolderslistState extends State<Folderslist> {
  @override
  void initState() {
    getPath();
    super.initState();
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
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black, size: 35.h.w),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          title: Text(
            'Folders',
            style: TextStyle(fontSize: 25.sp, color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 146, 93, 199),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
                padding:
                    EdgeInsets.only(top: 10.0.h, left: 10.0.w, right: 10.0.w),
                child: Container(
                  height: 75.h,
                  width: double.infinity.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(106, 217, 197, 218)),
                  child: ListTile(
                    visualDensity: const VisualDensity(vertical: -3),
                      onTap: (() async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) =>
                                  listPathSongs(index: index)),
                            ));
                      }),
                      leading: Icon(
                        Icons.folder,
                        size: 60.h.w,
                      ),
                      title: Text(
                        gotPath[index],
                      ),
                      subtitle:const Text('')
                      //  Text('${pathSongList.length.toString()} Songs'),
                      ),
                ));
          },
          itemCount: gotPath.length,
        )),
      ),
    );
  }

  void getPath() {
    for (var i = 0; i < allSongs.length; i++) {
      String _path = allSongs[i].data;
      List<String> _getSplitPath;
      _getSplitPath = _path.split('/');
      gotPathset.add(_getSplitPath[_getSplitPath.length - 2]);
    }
    gotPath = gotPathset.toList();
  }
}
