
// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_tape/core/db_model.dart';

// ignore: must_be_immutable
class EditPlaylist extends StatelessWidget {
  EditPlaylist({Key? key, required this.playlistName}) : super(key: key);
  final String playlistName;
  final _box = Songbox.getInstance();
  String? _title;
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
     
      title: Text(
              "Edit your playlist name.",
              style: TextStyle(
              
                fontSize: 18.h.w,
              ),
            ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          Padding(
            padding:  EdgeInsets.only(
              top: 10.h,
              left: 10.w,
              right: 10.w,
              bottom: 10.h,
            ),
            child: Form(
              key: formkey,
              child: TextFormField(
                initialValue: playlistName,
                cursorHeight: 25.h,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style:  TextStyle(
                  color: Colors.black,
                  fontSize: 20.h.w,
                ),
                onChanged: (value) {
                  _title = value.trim();
                },
                validator: (value) {
                  List keys = _box.keys.toList();
                  if (value!.trim() == "") {
                    return "name Required";
                  }
                  if (keys
                      .where((element) => element == value.trim())
                      .isNotEmpty) {
                    return "this name already exits";
                  }
                  return null;
                },
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:  EdgeInsets.only(
                    left: 15.0.w,
                    right: 15.w,
                    top: 5.h,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:  Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                       
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:  EdgeInsets.only(
                    left: 15.0.w,
                    right: 15.w,
                    top: 5,
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        List? playlists = _box.get(playlistName);
                        _box.put(_title, playlists!);
                        _box.delete(playlistName);
                        Navigator.pop(context);
                      }
                    },
                    child:  Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                         
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
