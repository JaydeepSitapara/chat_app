import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:first_app/api/api.dart';
import 'package:first_app/main.dart';
import 'package:first_app/models/chat_user.dart';
import 'package:first_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:first_app/helper/dialogs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? _image;
  ChatUser? user;
  @override
  void initState() {
    super.initState();
    user = APIs.instance.me!;
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Profile'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                //for spaceing
                SizedBox(
                  width: mq.width,
                  height: mq.height * .03,
                ),
                Stack(
                  children: [
                    _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(mq.height * .1),
                            child: Image.file(
                              File(_image!),
                              fit: BoxFit.cover,
                              width: mq.height * .2,
                              height: mq.height * .2,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(mq.height * .1),
                            child: CachedNetworkImage(
                              imageUrl: user?.image ?? '',
                              fit: BoxFit.cover,
                              width: mq.height * .2,
                              height: mq.height * .2,
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                            ),
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: mq.width * .200,
                      child: MaterialButton(
                        shape: const CircleBorder(),
                        color: Colors.white,
                        onPressed: _showBottomSheet,
                        child: const Center(
                          child: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: mq.height * .03,
                ),

                Text(
                  user?.email ?? '',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16.0,
                  ),
                ),

                SizedBox(
                  height: mq.height * .03,
                ),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: user!.name,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
                          label: const Text('Name'),
                          hintText: 'John Wick',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Please Enter Name';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          APIs.instance.me?.name = newValue!;
                        },
                      ),
                      SizedBox(
                        height: mq.height * .03,
                      ),
                      TextFormField(
                        initialValue: user!.about,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.info,
                            color: Colors.blue,
                          ),
                          label: const Text('About'),
                          hintText: 'Feeling Happy',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Please Enter ABout';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          APIs.instance.me?.about = newValue!;
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: mq.height * .05,
                ),

                //update button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(mq.width * .05, mq.height * .06)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      APIs.instance.updateProfileInfo();
                      Dialogs.showSnackbar(context, 'Profile Updated !');
                    }
                  },
                  label: const Text(
                    'Update',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            Dialogs.showProgressBar(context);

            await APIs.instance.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value) {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              });
            });
          },
          label: const Text('Logout'),
          icon: const Icon(Icons.logout),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      )),
      context: context,
      builder: (_) {
        return ListView(
          padding: EdgeInsets.only(top: mq.height * .03),
          shrinkWrap: true,
          children: [
            const Text(
              'Select Photo',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: mq.height * .03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      setState(() {
                        _image = image.path;
                      });
                      APIs.instance.updateProfilePicture(File(_image!));
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Galary'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      setState(() {
                        _image = image.path;
                      });
                      APIs.instance.updateProfilePicture(File(_image!));
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Camara'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
