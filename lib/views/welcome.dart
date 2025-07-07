import 'package:flutter/material.dart';
import 'package:flower_classification/classes/colors.dart';
import 'package:flower_classification/views/login.dart';
import 'package:flower_classification/views/register.dart';

class WelcomView extends StatefulWidget {
  const WelcomView({super.key});

  @override
  State<WelcomView> createState() => _WelcomViewState();
}

class _WelcomViewState extends State<WelcomView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 69),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              "Nikmati Aktifitas Dengan Pengalaman Terbaik",
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
                              "Buat akun atau masuk untuk mendapatkan pengalaman memprediksi jenis bunga.",
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(55,0,55,78),
                      child: Image.asset("assets/images/Group 31.png"),
                    ),

                    
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterView()));
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 13.5),
                    decoration: BoxDecoration(
                      color: greencolor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Buat Akun",
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

            Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.pushNamed(context, "/login");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginView()));  
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 13.5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Masuk",
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
      )
    );
  }
}