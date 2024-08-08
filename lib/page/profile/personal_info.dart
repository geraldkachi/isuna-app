import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:misau/widget/outline_dropdown.dart';
import 'package:misau/widget/outline_textfield.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  XFile? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  void _deleteImage() {
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F7),
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/back.svg',
                      height: 16,
                      color: Color(0xff1B1C1E),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "Personal Information",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xff1B1C1E),
                        letterSpacing: -.5,
                      ),
                    ),
                  ],
                ),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 26),
              _buildLabel("Photo Profile"),
              Row(
                children: [
                  if (_imageFile != null)
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: FileImage(File(_imageFile!.path)),
                    )
                  else
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Color(0xffE9EAEB),
                      child: Icon(Icons.person,
                          size: 30, color: Color(0xff1B1C1E)),
                    ),
                  const SizedBox(width: 20),
                  SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: _pickImage,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        side: const BorderSide(color: Color(0xffDC1D3C)),
                      ),
                      child: const Text(
                        "Upload Image",
                        style: TextStyle(
                          color: Color(0xffDC1D3C),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xffDEE5E8),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        'assets/trash.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    onTap: _deleteImage,
                  )
                ],
              ),
              const SizedBox(height: 12),
              _buildLabelWithAsterisk("First Name"),
              OutlineTextField(
                controller: firstNameController,
                hintText: 'Enter First Name',
              ),
              const SizedBox(height: 12),
              _buildLabelWithAsterisk("Last Name"),
              OutlineTextField(
                controller: lastNameController,
                hintText: 'Enter Last Name',
              ),
              const SizedBox(height: 12),
              _buildLabelWithAsterisk("Email Address"),
              OutlineTextField(
                controller: emailController,
                hintText: 'Enter Email Address',
              ),
              const SizedBox(height: 12),
              _buildLabelWithAsterisk("Role"),
              OutlineTextField(
                controller: roleController,
                hintText: 'Enter Role',
              ),
              const SizedBox(height: 12),
              Text(
                "Permissions",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  color: Color(0xff1B1C1E),
                  letterSpacing: -.5,
                ),
              ),
              const SizedBox(height: 13),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xffE9EAEB), width: 1.5),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabelWithAsterisk("State"),
                    OutlineDropdown(['Osun', 'Justin']),
                    const SizedBox(height: 12),
                    _buildLabel("LGA"),
                    OutlineDropdown(['Boluwaduro']),
                    const SizedBox(height: 12),
                    _buildLabel("Facility"),
                    OutlineDropdown(['Afao Primary Health Clinic']),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * .4,
                      height: 55,
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            side: const BorderSide(
                              color: Color(0xff121827),
                              width: 1.5,
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Color(0xff121827),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ))),
                  const Spacer(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .4,
                    height: 55,
                    child: SizedBox(
                        width: double.infinity, // Make button full width
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12.0), // border radius
                            ),
                            // primary:  const Color(0xffDC1C3D), // background color
                          ),
                          child: const Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )),
                  )
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: Color(0xff1B1C1E),
          letterSpacing: -.5,
        ),
      ),
    );
  }

  Widget _buildLabelWithAsterisk(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Color(0xff1B1C1E),
              letterSpacing: -.5,
            ),
          ),
          const Text(
            "*",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Color(0xffE03137),
              letterSpacing: -.5,
            ),
          ),
        ],
      ),
    );
  }
}
