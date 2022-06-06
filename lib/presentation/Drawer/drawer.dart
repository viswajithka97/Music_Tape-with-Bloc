import 'package:flutter/material.dart';
import 'package:music_tape/presentation/Drawer/privacypolicy.dart';
import 'package:music_tape/presentation/Drawer/terms&conditions.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: camel_case_types
class drawer extends StatelessWidget {
  const drawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 171, 126, 180),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          AppBar(
            title: const Text(
              'Music Tape',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.share, size: 35.h.w),
            title: const Text('Share'),
            onTap: () {
              Share.share('Hey Check out This App');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.verified,
              size: 35.h.w,
            ),
            title: const Text('Version'),
            subtitle: const Text('1.0.1'),
          ),
          ListTile(
            leading: const Icon(Icons.verified_user_outlined, size: 35),
            title: const Text('Terms & Conditions'),
            subtitle: const Text('All the Information you need to know'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Terms_Conditions()));
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip_outlined, size: 35.h.w),
            title: const Text('Privacy Policy'),
            subtitle: const Text('Important for both of us'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Privacy_Policy()));
            },
          ),
          ListTile(
            leading: Icon(Icons.info, size: 35.h.w),
            title: const Text('About'),
            onTap: () {
              showAboutDialog(
                  context: context,
                  applicationName: 'Music_Tape',
                  applicationVersion: '1.0.1',
                  applicationIcon: const CircleAvatar(
                    backgroundImage: AssetImage('asset/images/logo.png'),
                  ),
                  children: [
                    const Text(
                        'Music_ Tape is an Offline Music Player created by Viswajith K A'),
                  ]);
            },
          ),
        ],
      ),
    );
  }
}
