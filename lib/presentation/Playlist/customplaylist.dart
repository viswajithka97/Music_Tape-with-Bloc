import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPlayList extends StatelessWidget {
  final String? titleNew;
  final IconData leadingNew;
  final String? subtitileNew;
  final PopupMenuButton? trailingNew;
  final Function()? ontapNew;
  const CustomPlayList(
      {Key? key,
      required this.titleNew,
      required this.leadingNew,
      this.subtitileNew,
      this.trailingNew,
      this.ontapNew})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: 10.0.h, left: 10.0.w, right: 10.0.w),
      child: Container(
        height: 75.h,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color.fromARGB(106, 217, 197, 218)),
        child: ListTile(
          title: Text(
            titleNew!,
            style:  TextStyle(
              fontSize: 18.sp,
            ),
          ),
          leading: Icon(
            leadingNew,
            color: Colors.black,
            size: 35.sp,
          ),
          subtitle: Text('${subtitileNew!} Songs'),
          trailing: trailingNew,
          onTap: ontapNew,
        ),
      ),
    );
  }
}
