import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wallpaperApp/data/data.dart';
import 'package:wallpaperApp/widgets/slider_tile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  List<SliderModel> slides = List<SliderModel>();

  @override
  void initState() {
    super.initState();

    slides = getSlides();
  }

  Widget pageIndexIndicator(bool isCurrent) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrent ? 10.0 : 6,
      width: isCurrent ? 10.0 : 6,
      decoration: BoxDecoration(
          color: isCurrent ? Colors.grey : Colors.grey[300],
          borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
          controller: pageController,
          onPageChanged: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          itemCount: slides.length,
          itemBuilder: (context, index) {
            return SliderTile(
              imageAssetPath: slides[index].imagePath,
              title: slides[index].title,
              desc: slides[index].desc,
            );
          }),
      bottomSheet: currentIndex != slides.length - 1
          ? Container(
              height: Platform.isIOS ? 70 : 60,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      pageController.animateToPage(slides.length - 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.linear);
                    },
                    child: Text('SKIP'),
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < slides.length; i++)
                        currentIndex == i
                            ? pageIndexIndicator(true)
                            : pageIndexIndicator(false)
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      pageController.animateToPage(currentIndex + 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.linear);
                    },
                    child: Text('NEXT'),
                  ),
                ],
              ),
            )
          : InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
              child: Container(
                color: Colors.blue,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: Platform.isIOS ? 70 : 60,
                child: Text(
                  'GET STARTED NOW',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
    );
  }
}
