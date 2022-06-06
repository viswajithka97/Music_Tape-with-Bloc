 import 'package:flutter/material.dart';
 import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavouriteList extends StatelessWidget {
  const FavouriteList({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:10.0.h,left: 10.0.w,right: 10.0.w),
      child: Container(
        height: 75.h,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color:const Color.fromARGB(255, 227, 194, 233)),
        child: ListTile(
          visualDensity: const VisualDensity(vertical: -3),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5.0), 
            // ignore: sized_box_for_whitespace
            child: Container(
              height: 70.0.h,
              width: 50.0.w,
              child: Image.asset(
                'asset/images/download.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          title:const Text('KGF Chapter 2'),
          subtitle:const Text('Unknown Artist'),
          trailing:const Icon(Icons.favorite_outlined,color: Colors.red,),
        ),
      ),
    );
  }
}