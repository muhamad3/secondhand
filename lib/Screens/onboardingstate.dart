import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondhand/classes/sharedpreferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingState extends StatefulWidget {
  OnboardingState({Key? key}) : super(key: key);

  @override
  _OnboardingStateState createState() => _OnboardingStateState();
}

class _OnboardingStateState extends State<OnboardingState> {
  final controller = PageController();
  bool isLastPage = false;
  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildPage(
          {required Color color,
          required String urlImage,
          required String title,
          required String subtitle}) =>
      Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              urlImage,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                subtitle,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (value) {
            setState(() {
              isLastPage = value == 2;
            });
          },
          children: [
            buildPage(
                color: Colors.cyan,
                urlImage: 'lib/assets/buy.png',
                title: 'Buy',
                subtitle:
                    'Buy second hand items from all around your country without leaving your house'),
            buildPage(
                color: Colors.cyan,
                urlImage: 'lib/assets/sell.jpg',
                title: 'Sell',
                subtitle:
                    'sell second hand items all around your country without leaving your house'),
            buildPage(
                color: Colors.cyan,
                urlImage: 'lib/assets/sell.png',
                title: 'Buy',
                subtitle:
                    'Buy second hand items from all around your country without leaving your house'),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                  minimumSize: Size.fromHeight(80),
                  primary: Colors.cyan,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () async {
                Sharedpreference.isfirsttime();
                Navigator.popAndPushNamed(context, '/login');
              },
              child: Text(
                'Get Started',
                style: TextStyle(fontSize: 24),
              ))
          : Container(
              height: 80,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        controller.jumpToPage(3);
                      },
                      child: Text('SKIP')),
                  Center(
                      child: SmoothPageIndicator(
                          controller: controller,
                          count: 3,
                          onDotClicked: (index) {
                            controller.animateToPage(index,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          })),
                  TextButton(
                      onPressed: () {
                        controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      child: Text('NEXT'))
                ],
              ),
            ),
    );
  }
  
}
