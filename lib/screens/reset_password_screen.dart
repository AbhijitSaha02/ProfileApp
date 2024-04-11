import 'package:flutter/material.dart';
import 'package:profile_app/user/user_data.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late var user;
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool showPasswordOld = false;
  bool showPasswordNew = false;
  bool showPasswordConfirm = false;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    user = UserData.getUser('user');
    super.initState();
  }

  void updatePassword(String passcode) {
    user.passcode = passcode;
  }

  void checkValues() {
    if (oldPasswordController.text != newPasswordController.text) {
      if (formKey.currentState!.validate() &&
          newPasswordController.text == confirmPasswordController.text) {
        updatePassword(confirmPasswordController.text);
      }
    }
    UserData.setUser(user, 'user');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(
          height: screenHeight,
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
              'Reset Password',
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
          body: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                      minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
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
                                  controller: oldPasswordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the previous password.';
                                    } else if (value.length > 6 ||
                                        value.length < 6) {
                                      return 'Please enter a password of 6 numbers only.';
                                    } else if (value != user.passcode) {
                                      return 'Please enter the old password';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  obscureText: !showPasswordOld,
                                  decoration: InputDecoration(
                                    labelText: 'Previous Password',
                                    labelStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    hintText: 'Enter Previous Password',
                                    hintStyle: const TextStyle(
                                      color: Colors.black38,
                                      fontSize: 16,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white70,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 1.2),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showPasswordOld = !showPasswordOld;
                                        });
                                      },
                                      child: Icon(
                                        showPasswordOld
                                            ? Icons.visibility_rounded
                                            : Icons.visibility_off_rounded,
                                        color: Colors.grey,
                                      ),
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
                                  controller: newPasswordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the new password.';
                                    } else if (value.length > 6 ||
                                        value.length < 6) {
                                      return 'Please enter a password of 6 numbers only.';
                                    } else if (value ==
                                        oldPasswordController.text) {
                                      return 'Please enter a different password.';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  obscureText: !showPasswordNew,
                                  decoration: InputDecoration(
                                    labelText: 'New Password',
                                    labelStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    hintText: 'Enter New Password',
                                    hintStyle: const TextStyle(
                                      color: Colors.black38,
                                      fontSize: 16,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white70,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 1.2),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showPasswordNew = !showPasswordNew;
                                        });
                                      },
                                      child: Icon(
                                        showPasswordNew
                                            ? Icons.visibility_rounded
                                            : Icons.visibility_off_rounded,
                                        color: Colors.grey,
                                      ),
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
                                  controller: confirmPasswordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password.';
                                    } else if (value.length > 6 ||
                                        value.length < 6) {
                                      return 'Please enter a password of 6 numbers only.';
                                    } else if (value !=
                                        newPasswordController.text) {
                                      return 'Please enter the same password as above.';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  obscureText: !showPasswordConfirm,
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    labelStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    hintText: 'Enter Password Again',
                                    hintStyle: const TextStyle(
                                      color: Colors.black38,
                                      fontSize: 16,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white70,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 1.2),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showPasswordConfirm =
                                              !showPasswordConfirm;
                                        });
                                      },
                                      child: Icon(
                                        showPasswordConfirm
                                            ? Icons.visibility_rounded
                                            : Icons.visibility_off_rounded,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                          child: SizedBox(
                            width: screenWidth * 0.5,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: (() {
                                if (formKey.currentState!.validate()) {
                                  checkValues();
                                  Fluttertoast.showToast(
                                    msg: 'Password Saved',
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
                                    if (states
                                        .contains(MaterialState.pressed)) {
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
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
