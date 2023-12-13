import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import '../utils/custom_route.dart';
import '../common/app_bar.dart';
import '../constants/constants.dart';
import 'search_page.dart';
import 'fullview_page.dart';

class HomePage extends StatefulWidget {
  static const id = "HomePage";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getWallpapers();
  }

  List images = [];
  int page = 1;
  final TextEditingController searchController = TextEditingController();

  getWallpapers() async {
    String url = "${Constants.baseUrl}curated?page=1&per_page=40";
    await http.get(Uri.parse(url),
        headers: {"Authorization": Constants.apikey}).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result["photos"];
      });
    });
  }

  loadMore() async {
    setState(() {
      page = page + 1;
    });
    String url = "${Constants.baseUrl}curated?page=1&per_page=40&page=$page";
    await http.get(Uri.parse(url),
        headers: {"Authorization": Constants.apikey}).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const MyAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 0, top: 8),
        child: Column(
          children: [
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.h, right: 10.h),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 2.w, color: Colors.black),
                    borderRadius: BorderRadius.circular(50.r),
                    color: Colors.deepPurpleAccent.shade100.withOpacity(0.5)),
                // height: 45.h,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 30.w, right: 15.w, top: 0.h, bottom: 0.h),
                  child: TextFormField(
                    onFieldSubmitted: (text) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      Navigator.push(
                          context,
                          customAnimation(
                              SearchPage(searchController: text.toString())));
                    },
                    onSaved: (text) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      Navigator.push(
                              context,
                              customAnimation(SearchPage(
                                  searchController: text.toString())))
                          .then((value) => searchController.clear());
                    },
                    decoration: InputDecoration(
                        hintText: "Search wallpaper",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        suffixIcon: IconButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              Navigator.push(
                                      context,
                                      customAnimation(SearchPage(
                                          searchController: searchController
                                              .text
                                              .toString())))
                                  .then((value) => searchController.clear());
                            },
                            icon: Icon(
                              Icons.search,
                              size: 22.sp,
                              color: Colors.black,
                            ))),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: Colors.black),
                    controller: searchController,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Expanded(
              child: Stack(
                children: [
                  GridView.builder(
                    itemCount: images.length,
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2.w,
                        childAspectRatio: 2 / 3,
                        mainAxisSpacing: 2.h),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Navigator.push(
                              context,
                              customAnimation(FullViewPage(
                                  imageUrl: images[index]["src"]["large2x"])));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Hero(
                              tag: 'image$index',
                              child: Image.network(
                                images[index]["src"]["tiny"],
                                height: 50.h,
                                width: 50.h,
                                fit: BoxFit.fill,
                                loadingBuilder: (context, child,
                                        loadingProgress) =>
                                    loadingProgress != null
                                        ? Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor:
                                                Colors.grey.shade100,
                                            enabled: true,
                                            child: Container(
                                              height: 50.h,
                                              width: 50.h,
                                              color: Colors.grey,
                                            ))
                                        : child,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        loadMore();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(50.r),
                            border:
                                Border.all(color: Colors.white, width: 2.w)),
                        padding: EdgeInsets.all(10.sp),
                        child: Text(
                          "Load more",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
