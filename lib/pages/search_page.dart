import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import '../utils/custom_route.dart';
import '../constants/constants.dart';
import 'fullview_page.dart';

class SearchPage extends StatefulWidget {
  static const id = "SearchPage";
  const SearchPage({Key? key, required this.searchController})
      : super(key: key);

  final String searchController;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    searchQuery = widget.searchController;
    getWallpapers();
  }

  late String searchQuery;
  List images = [];
  int page = 1;
  bool loading = false;

  getWallpapers() async {
    setState(() {
      loading = true;
    });

    String url =
        "${Constants.baseUrl}search?query=${searchQuery.toString()}&per_page=40";
    await http.get(Uri.parse(url),
        headers: {"Authorization": Constants.apikey}).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        loading = false;
        images = result["photos"];
      });
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Get.snackbar(
        "",
        "",
        titleText: Text(error.toString(),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        messageText: const Text("Try Some another query, Thankyou!!"),
      );
    });
  }

  loadMore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        "${Constants.baseUrl}search?query=${searchQuery.toString()}&per_page=40&page=$page";
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
        title: Row(
          children: [
            Text(
              "${widget.searchController} ",
              style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent),
            ),
            const Text(
              "Wallpapers",
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.deepPurpleAccent,
            ))
          : images.isEmpty
              ? Center(
                  child: Text(
                    "No Images Available for ${widget.searchController}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              : Stack(children: [
                  GridView.builder(
                    itemCount: images.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2,
                            childAspectRatio: 2 / 3,
                            mainAxisSpacing: 2),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
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
                                fit: BoxFit.fill,  loadingBuilder:
                                          (context, child, loadingProgress) =>
                                              loadingProgress != null
                                                  ? Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey.shade300,
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
                        padding: EdgeInsets.all(8.sp),
                        child: Text(
                          "Load more",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  )
                ]),
    );
  }
}
