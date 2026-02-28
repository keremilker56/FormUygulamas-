import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp burada en üstte durmalı
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FormSayfasi(), // Form sayfasını burada çağırıyoruz
    );
  }
}

final formKey = GlobalKey<FormState>();

class FormSayfasi extends StatefulWidget {
  const FormSayfasi({super.key});

  @override
  State<FormSayfasi> createState() => _FormSayfasiState();
}

Map<String, String> bilgiler = {};
String ad = "";
String email = "";
String sifre = "";
String durum = "Kaydol";

class _FormSayfasiState extends State<FormSayfasi> {
  bool _obscureText = true;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late FocusNode _nameFocusNode;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Sayfası", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: Column(
              children: [
                /// Ad alanı
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _nameController,
                    focusNode: _nameFocusNode,

                    decoration: InputDecoration(
                      icon: Icon(Icons.person, color: Colors.blue),
                      label: Text("Ad", style: TextStyle(color: Colors.blue)),

                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (bilgiler.length == 0) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 2) {
                          return "Lütfen Bir Ad Giriniz";
                        }
                        return null;
                      } else {
                        if (value != ad) {
                          return "Lütfen adınızı giriniz";
                        }
                        return null;
                      }
                    },
                  ),
                ),

                /// E-posta alanı
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email, color: Colors.blue),
                      label: Text(
                        "E-Posta Adresiniz",
                        style: TextStyle(color: Colors.blue),
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (bilgiler.length == 0) {
                        if (!EmailValidator.validate(value.toString())) {
                          return "Lütfen Geçerli Bir E-Posta Adresi Giriniz";
                        }
                        return null;
                      } else {
                        if (value != email) {
                          return "Lütfen geçerli bir email giriniz";
                        }
                        return null;
                      }
                    },
                  ),
                ),

                /// Şifre alanı
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock, color: Colors.blue),
                      label: Text(
                        "Şifreniz",
                        style: TextStyle(color: Colors.blue),
                      ),

                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    obscureText: _obscureText,
                    validator: (value) {
                      if (bilgiler.length == 0) {
                        if (value!.length < 8 ||
                            value == null ||
                            value.isEmpty) {
                          return "Lütfen Düzgün Bir Şifre Gir";
                        }
                      } else {
                        if (value != sifre) {
                          return "Bu şifre kayıtlı şifreyle aynı değil";
                        }
                        return null;
                      }
                    },
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 162, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(0),
                    ),
                  ),
                  onPressed: () {
                    bool sonuc = formKey.currentState!.validate();
                    if (sonuc) {
                      ad = _nameController.text;
                      email = _emailController.text;
                      sifre = _passwordController.text;
                      bilgiler = {"Ad:": ad, "Email": email, "Sifre": sifre};

                      setState(() {});
                      durum = "Giriş Yap";
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text(
                            "Başarılı Diğer Sayfasya Yönlendiriliyorsunuz",
                            style: TextStyle(color: Colors.green),
                          ),
                          backgroundColor: Colors.white,
                        ),
                      );
                      
                      Duration(seconds: 2);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AcilisSayfasi(
                            ad: _nameController.text,
                            email: _emailController.text,
                            sifre: _passwordController.text,
                            formkey: formKey,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text(
                            "Bir Şeyler Yanlış Gitti",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 17, 0),
                            ),
                          ),
                          backgroundColor: Colors.black,
                        ),
                      );
                    }
                  },
                  child: Text(durum, style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AcilisSayfasi extends StatefulWidget {
  final ad;
  final email;
  final sifre;
  final formkey;
  const AcilisSayfasi({
    super.key,
    required this.ad,
    required this.email,
    required this.sifre,
    required this.formkey,
  });

  @override
  State<AcilisSayfasi> createState() => _AcilisSayfasiState();
}

class _AcilisSayfasiState extends State<AcilisSayfasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            durum = "Giriş Yap";
            formKey.currentState!.reset();
            setState(() {});
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormSayfasi(),
              ),
            );
          },
          icon: Icon(Icons.arrow_back_outlined, color: Colors.white),
        ),
        title: Text("Açılış Sayfası", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(700),
                bottomRight: Radius.circular(700),
              ),
              border: Border(bottom: BorderSide(color: Colors.white, width: 2)),
              boxShadow: [BoxShadow(blurRadius: 30, color: Colors.black)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hoşgeldin $ad",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                Text(
                  "Email : $email",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
