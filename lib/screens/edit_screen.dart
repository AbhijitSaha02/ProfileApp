import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:profile_app/widgets/display_image_widget.dart';
import 'package:string_validator/string_validator.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profile_app/user/user_data.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late var user;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final aboutController = TextEditingController();
  RegExp rex = RegExp(r"^[A-Za-z ]*$");

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    emailController.dispose();
    contactController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    user = UserData.getUser('user');
    nameController.text = user.name;
    ageController.text = user.age;
    emailController.text = user.email;
    contactController.text = user.contact;
    aboutController.text = user.aboutDescription;
    super.initState();
  }

  void updateUserValue(
      {String? name,
      String? age,
      String? email,
      String? contact,
      String? about}) {
    user.name = name ?? user.name;
    user.age = age ?? user.age;
    user.email = email ?? user.email;
    user.contact = contact ?? user.contact;
    user.aboutDescription = about ?? user.aboutDescription;
  }

  void updateValues() {
    if (user.name != nameController.text) {
      if (formKey.currentState!.validate() &&
          rex.hasMatch(nameController.text)) {
        updateUserValue(name: nameController.text);
      }
    }
    if (user.age != ageController.text) {
      if (formKey.currentState!.validate() && isNumeric(ageController.text)) {
        updateUserValue(age: ageController.text);
      }
    }
    if (user.email != emailController.text) {
      if (formKey.currentState!.validate() &&
          EmailValidator.validate(emailController.text)) {
        updateUserValue(email: emailController.text);
      }
    }
    if (user.contact != contactController.text) {
      if (formKey.currentState!.validate() &&
          isNumeric(contactController.text)) {
        updateUserValue(contact: contactController.text);
      }
    }
    if (user.aboutDescription != aboutController.text) {
      if (formKey.currentState!.validate()) {
        updateUserValue(about: aboutController.text);
      }
    }
    UserData.setUser(user, 'user');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 215, 0, 1),
                Color.fromRGBO(255, 165, 0, 1),
                Color.fromRGBO(255, 62, 50, 1),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.25, 0.5, 0.75],
              tileMode: TileMode.repeated,
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'Edit Profile',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            leading: GestureDetector(
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
                    child: SizedBox(
                      width: 0.4 * screenWidth,
                      child: InkWell(
                        onTap: () async {
                          final image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);

                          if (image == null) {
                            return;
                          }

                          final location =
                              await getApplicationDocumentsDirectory();
                          final name = basename(image.path);
                          final imageFile = File('${location.path}/$name');
                          final newImage =
                              await File(image.path).copy(imageFile.path);
                          setState(() {
                            user.image = newImage.path;
                            UserData.setUser(user, 'user');
                          });
                        },
                        child: DisplayImage(
                          imagePath: user.image,
                          onPressed: () {},
                          edit: true,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 30, 5, 0),
                        child: SizedBox(
                          height: 100,
                          width: 0.8 * screenWidth,
                          child: TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name.';
                              } else if (!rex.hasMatch(value)) {
                                return 'Name pattern not matched.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              filled: true,
                              fillColor: Colors.white70,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1.2),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: SizedBox(
                          height: 100,
                          width: 0.8 * screenWidth,
                          child: TextFormField(
                            controller: ageController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your age.';
                              } else if (!isNumeric(value)) {
                                return 'Only numbers please';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Age',
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              filled: true,
                              fillColor: Colors.white70,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1.2),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: SizedBox(
                          height: 100,
                          width: 0.8 * screenWidth,
                          child: TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your e-mail.';
                              } else if (!EmailValidator.validate(value)) {
                                return 'Please enter a valid E-mail Id.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'E-mail Id',
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              filled: true,
                              fillColor: Colors.white70,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1.2),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: SizedBox(
                          height: 100,
                          width: 0.8 * screenWidth,
                          child: TextFormField(
                            controller: contactController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your contact number.';
                              } else if (!isNumeric(value)) {
                                return 'Only numbers please';
                              } else if (value.length < 10) {
                                return 'Please enter a valid phone number.';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Contact No.',
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              filled: true,
                              fillColor: Colors.white70,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1.2),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: SizedBox(
                          height: 100,
                          width: 0.8 * screenWidth,
                          child: TextFormField(
                            controller: aboutController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length > 200) {
                                return 'Please enter your description but keep it under 200 characters.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'About Myself',
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              filled: true,
                              fillColor: Colors.white70,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1.2),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 30),
                        child: SizedBox(
                          height: 50,
                          width: 0.6 * screenWidth,
                          child: ElevatedButton(
                            onPressed: (() {
                              if (formKey.currentState!.validate()) {
                                updateValues();
                                Fluttertoast.showToast(
                                  msg: 'Profile Saved',
                                  toastLength: Toast.LENGTH_SHORT,
                                  textColor: Colors.white,
                                  backgroundColor:
                                      const Color.fromRGBO(255, 62, 50, 1),
                                  gravity: ToastGravity.BOTTOM,
                                );
                                Navigator.pop(context, true);
                              }
                            }),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.redAccent;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
