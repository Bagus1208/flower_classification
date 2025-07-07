import 'package:flutter/material.dart';
import 'package:flower_classification/classes/colors.dart';
import 'package:flower_classification/views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool isHide = true;

  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController konfirmPassController = TextEditingController();

Future<void> registerUser() async {
  if (passController.text != konfirmPassController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password tidak cocok')),
    );
    return;
  }

  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passController.text.trim(),
    );

    await userCredential.user!.updateDisplayName(namaController.text);
    await userCredential.user!.reload();

    // Simpan data ke Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'namaLengkap': namaController.text,
      'email': emailController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Cek apakah user berhasil reload
    User? updatedUser = FirebaseAuth.instance.currentUser;
    if (updatedUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    }
  } on FirebaseAuthException catch (e) {
    String errorMsg = "Terjadi kesalahan";
    if (e.code == 'email-already-in-use') {
      errorMsg = 'Email sudah digunakan';
    } else if (e.code == 'invalid-email') {
      errorMsg = 'Email tidak valid';
    } else if (e.code == 'weak-password') {
      errorMsg = 'Password terlalu lemah';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMsg)),
    );
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
                    "Daftar Sekarang",
                    style: TextStyle(fontFamily: "InterSemiBold", fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 32),
                  child: Text(
                    "Masukkan data diri anda untuk menikmati fitur kami.",
                    style: TextStyle(
                      fontFamily: "InterRegular",
                      color: fontGraycolor,
                      fontSize: 14,
                    ),
                  ),
                ),

                Text(
                  "Nama Lengkap",
                  style: TextStyle(fontFamily: "InterRegular", fontSize: 14),
                ),
                TextFormField(
                  onChanged: (v) {
                    setState(() {});
                  },
                  cursorColor: greencolor,
                  controller: namaController,
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
                    hintText: "Masukkan Nama Lengkap",
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
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Email",
                    style: TextStyle(fontFamily: "InterRegular", fontSize: 14),
                  ),
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
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Konfirmasi Password",
                    style: TextStyle(fontFamily: "InterRegular", fontSize: 14),
                  ),
                ),

                TextFormField(
                  onChanged: (v) {
                    setState(() {});
                  },
                  cursorColor: greencolor,
                  controller: konfirmPassController,
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
                    hintText: "Konfirmasi Password",
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
                      // print("Email: ${emailController.text}");
                      // print("Password: ${passController.text}");
                      registerUser();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 13.5),
                      decoration: BoxDecoration(
                        color:
                            namaController.text != "" &&
                                    emailController.text != "" &&
                                    passController.text != "" && 
                                    konfirmPassController.text != ""
                                ? greencolor
                                 // ignore: deprecated_member_use
                                : greencolor.withOpacity(0.28),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "Daftar",
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
                        "Sudah punya akun? ",
                        style: TextStyle(fontFamily: "InterRegular"),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginView(),
                            ),
                          );
                        },
                        child: Text(
                          "Masuk Sekarang",
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
