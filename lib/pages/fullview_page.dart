import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class FullViewPage extends StatefulWidget {
  static const id = "FullViewPage";

  final String imageUrl;
  const FullViewPage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<FullViewPage> createState() => _FullViewPageState();
}

class _FullViewPageState extends State<FullViewPage> {
  Future<bool> setWallpaper() async {
    try {
      int location = WallpaperManager.HOME_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
      bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
      return result;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "WALL ",
              style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent),
            ),
            Text(
              "SCAPE",
              style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )
          ],
        ),
      ),
      body: Stack(children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Hero(
            tag: 'image',
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.fill,
              loadingBuilder: (context, child, loadingProgress) =>
                  loadingProgress != null
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          enabled: true,
                          child: Container(
                            height: 90.h,
                            width: 90.w,
                            color: Colors.grey,
                          ))
                      : child,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: InkWell(
            onTap: () async {
              final wallpaperSet = await setWallpaper();

              Get.snackbar("", "",
                  messageText: Text(wallpaperSet
                      ? "Thankyou for using Wall Scape"
                      : "Something Went Wrong"),
                  margin: EdgeInsets.only(top: 100.h),
                  titleText: Text(
                    wallpaperSet
                        ? "wallpaper is set"
                        : "Unable to set wallpaper",
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
                  ));

              Timer(const Duration(seconds: 1), () {
                Navigator.pop(context);
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(50.r),
                  border: Border.all(color: Colors.white, width: 2.w)),
              padding: const EdgeInsets.all(8),
              child: Text(
                "Set Wallpaper",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                    color: Colors.black),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
