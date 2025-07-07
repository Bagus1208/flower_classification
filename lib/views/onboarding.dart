import 'package:flutter/material.dart';
import 'package:flower_classification/views/welcome.dart';
import '../classes/colors.dart';

List onboardingData = [
  {
    "image": "assets/images/Group 26.png",
    "title": "Selamat datang di Classification Flowers",
    "desc":
        "Aplikasi pintar untuk menentukan jenis bunga dengan sekali upload foto",
  },
  {
    "image": "assets/images/Group 29.png",
    "title": "Unggah Foto, Dapatkan Hasil",
    "desc":
        "Gunakan kamera atau galeri untuk menganalisis jenis bunga secara otomatis dan akurat.",
  },
  {
    "image": "assets/images/Group 30.png",
    "title": "Pantau dan Pelajari",
    "desc":
        "Lihat riwayat klasifikasi Anda dan pelajari jenis bunga. ",
  },
];

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController pageController = PageController();
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (v) {
                // ignore: avoid_print
                print(v.toString());
                setState(() {
                  currentPage = v;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (_, i) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(onboardingData[i]['image']),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              onboardingData[i]['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "InterBold",
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              onboardingData[i]['desc'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "InterMedium",
                                fontSize: 14,
                                color: fontGraycolor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Wrap(
                  spacing: 6,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: currentPage == 0 ? greencolor : Graycolor,
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      height: 8,
                      width: currentPage == 0 ? 20 : 8,
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: currentPage == 1 ? greencolor : Graycolor,
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      height: 8,
                      width: currentPage == 1 ? 20 : 8,
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: currentPage == 2 ? greencolor : Graycolor,
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      height: 8,
                      width: currentPage == 2 ? 20 : 8,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    if (currentPage == 2) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) => const WelcomView(),
                        ),
                      );
                    } else {
                      pageController.animateToPage(
                        currentPage + 1,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                    // ignore: avoid_print
                    print("lanjutkan");
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 13.5),
                    decoration: BoxDecoration(
                      color: greencolor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      currentPage == 2 ? "Mulai Sekarang" : "Lanjutkan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "InterSemiBold",
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              currentPage == 2
                  ? const SizedBox(height: 47)
                  : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.pushNamed(context, '/login');
                        pageController.animateToPage(
                          2,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                        // ignore: avoid_print
                        print("lewati");
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 13.5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Lewati",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "InterSemiBold",
                            fontSize: 14,
                            color: greencolor,
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
