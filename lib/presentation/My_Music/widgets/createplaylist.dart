import 'package:flutter/material.dart';
import 'package:music_tape/core/db_model.dart';

// ignore: camel_case_types
class createPlaylist extends StatefulWidget {
  const createPlaylist({Key? key}) : super(key: key);

  @override
  State<createPlaylist> createState() => _createPlaylistState();
}

// ignore: camel_case_types
class _createPlaylistState extends State<createPlaylist> {
  List<Songmodel> playlists = [];
  final box = Songbox.getInstance();
  String? title;
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Playlist Name'),
      content: Form(
          key: formkey,
          child: TextFormField(
            onChanged: (value) {
              title = value.trim();
            },
            validator: (value) {
              List keys = box.keys.toList();
              if (value!.trim() == "") { 
                return "Name Required";
              }
              if (keys.where((element) => element == value.trim()).isNotEmpty) {
                return "This Name Already Exists";
              }
              return null;
            },
          )),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                )),
            TextButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    box.put(title, playlists);
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.black),
                )),
          ],
        ),
      ],
    );
  }
}
