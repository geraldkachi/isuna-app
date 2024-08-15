import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:misau/app/theme/colors.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/back.svg',
                    height: 16,
                    color: const Color(0xff1B1C1E),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    "Preferences",
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
            // Row(
            //   children: [
            //     const Column(
            //       children: [
            //         Text(
            //           "Update Systems",
            //           style: TextStyle(
            //             fontWeight: FontWeight.w600,
            //             fontSize: 20,
            //             color: Color(0xff6C7278),
            //             letterSpacing: -.5,
            //           ),
            //         ),
            //         SizedBox(
            //           height: 10,
            //         ),
            //         Text(
            //           "let me now if there is a new\nproduct update",
            //           style: TextStyle(
            //             fontWeight: FontWeight.w500,
            //             fontSize: 13,
            //             height: 1.3,
            //             color: Color(0xffABB5BC),
            //             letterSpacing: -.5,
            //           ),
            //         ),
            //       ],
            //     ),
            //     const Spacer(),
            //     Switch(
            //       value: true,
            //       onChanged: (value) {},
            //       activeColor: const Color(0xFF34B77F),
            //       trackOutlineColor: MaterialStateProperty.resolveWith(
            //         (final Set<MaterialState> states) {
            //           if (states.contains(MaterialState.selected)) {
            //             return const Color(0xFF34B77F);
            //           }

            //           return const Color(0xff6C7278);
            //         },
            //       ),
            //       activeTrackColor: Colors.white,
            //       inactiveTrackColor: Colors.white,
            //       inactiveThumbColor: const Color(0xff6C7278),
            //     )
            //   ],
            // ),
            // const SizedBox(height: 26),
            // Row(
            //   children: [
            //     const Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "Transactions",
            //           style: TextStyle(
            //             fontWeight: FontWeight.w600,
            //             fontSize: 20,
            //             color: Color(0xff6C7278),
            //             letterSpacing: -.5,
            //           ),
            //         ),
            //         SizedBox(
            //           height: 10,
            //         ),
            //         Text(
            //           "tell me about the information\nafter making the transaction",
            //           style: TextStyle(
            //             fontWeight: FontWeight.w500,
            //             fontSize: 13,
            //             height: 1.3,
            //             color: Color(0xffABB5BC),
            //             letterSpacing: -.5,
            //           ),
            //         ),
            //       ],
            //     ),
            //     const Spacer(),
            //     Switch(
            //       value: true,
            //       onChanged: (value) {},
            //       activeColor: const Color(0xFF34B77F),
            //       trackOutlineColor: MaterialStateProperty.resolveWith(
            //         (final Set<MaterialState> states) {
            //           if (states.contains(MaterialState.selected)) {
            //             return const Color(0xFF34B77F);
            //           }

            //           return const Color(0xff6C7278);
            //         },
            //       ),
            //       activeTrackColor: Colors.white,
            //       inactiveTrackColor: Colors.white,
            //       inactiveThumbColor: const Color(0xff6C7278),
            //     )
            //   ],
            // ),
            // const SizedBox(height: 26),
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email Notification",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Color(0xff6C7278),
                        letterSpacing: -.5,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "notify me of all notifications\nvia email",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        height: 1.3,
                        color: Color(0xffABB5BC),
                        letterSpacing: -.5,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Switch(
                  value: true,
                  onChanged: (value) {},
                  activeColor: const Color(0xFF34B77F),
                  trackOutlineColor: MaterialStateProperty.resolveWith(
                    (final Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return const Color(0xFF34B77F);
                      }

                      return const Color(0xff6C7278);
                    },
                  ),
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white,
                  inactiveThumbColor: const Color(0xff6C7278),
                )
              ],
            ),
            const Spacer(),
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
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                        style: TextButton.styleFrom(
                          backgroundColor: red,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12.0), // border radius
                          ),
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
