import 'package:flutter/material.dart';
import 'package:flower_classification/views/home_page.dart';
import 'package:flower_classification/classes/colors.dart';
import 'package:flower_classification/views/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_app/predict_page.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isHide = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  // Fungsi login menggunakan Firebase
  Future<void> loginWithEmail() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login berhasil")));

      // Navigasi ke halaman lain jika login berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => HomePage(),
              
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'user-not-found') {
        message = "Pengguna tidak ditemukan";
      } else if (e.code == 'wrong-password') {
        message = "Password salah";
      } else {
        message = e.message ?? "Terjadi kesalahan";
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image.asset("assets/images/logo.png", width: 44, height: 44),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Selamat Datang",
                    style: TextStyle(fontFamily: "InterSemiBold", fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 32),
                  child: Text(
                    "Masukkan email dan password untuk melanjutkan.",
                    style: TextStyle(
                      fontFamily: "InterRegular",
                      color: fontGraycolor,
                      fontSize: 14,
                    ),
                  ),
                ),

                Text(
                  "Email",
                  style: TextStyle(fontFamily: "InterRegular", fontSize: 14),
                ),
                TextFormField(
                  onChanged: (v) {
                    setState(() {});
                  },
                  cursorColor: greencolor,
                  controller: emailController,
                  style: TextStyle(fontFamily: "InterRegular", fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 13.5,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
                    ),
                    hintText: "Masukkan Email",
                    hintStyle: TextStyle(
                      fontFamily: "InterRegular",
                      fontSize: 14,
                      color: hintColor,
                    ),
                    filled: true,
                    fillColor: formColor,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: greencolor, width: 2),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Password",
                    style: TextStyle(fontFamily: "InterRegular", fontSize: 14),
                  ),
                ),

                TextFormField(
                  onChanged: (v) {
                    setState(() {});
                  },
                  cursorColor: greencolor,
                  controller: passController,
                  obscureText: isHide,
                  style: TextStyle(fontFamily: "InterRegular", fontSize: 14),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        isHide = !isHide;
                        setState(() {});
                      },
                      icon: Icon(
                        isHide
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 18,
                        color: hintColor,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 13.5,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
                    ),
                    hintText: "Masukkan Password",
                    hintStyle: TextStyle(
                      fontFamily: "InterRegular",
                      fontSize: 14,
                      color: hintColor,
                    ),
                    filled: true,
                    fillColor: formColor,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: greencolor, width: 2),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 32),
                  child: GestureDetector(
                    onTap: () {
                      if (emailController.text.isNotEmpty &&
                          passController.text.isNotEmpty) {
                        loginWithEmail(); // Ganti dari print ke login
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Mohon isi email dan password"),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 13.5),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color:
                            emailController.text != "" &&
                                    passController.text != ""
                                ? greencolor
                                : greencolor.withOpacity(0.28),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "Masuk",
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
                  padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum punya akun? ",
                        style: TextStyle(fontFamily: "InterRegular"),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterView(),
                            ),
                          );
                        },
                        child: Text(
                          "Daftar Sekarang",
                          style: TextStyle(
                            fontFamily: "InterSemiBold",
                            color: greencolor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
