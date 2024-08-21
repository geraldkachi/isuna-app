import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:isuna/app/theme/colors.dart';
import 'package:isuna/features/admin/admin_view_model.dart';
import 'package:isuna/utils/utils.dart';
import 'package:isuna/widget/outline_datepicker.dart';
import 'package:isuna/widget/outline_dropdown.dart';
import 'package:isuna/widget/outline_textfield.dart';

class AddAdminPage extends ConsumerStatefulWidget {
  const AddAdminPage({super.key});

  @override
  ConsumerState<AddAdminPage> createState() => _AddAdminPageState();
}

class _AddAdminPageState extends ConsumerState<AddAdminPage> {
  @override
  Widget build(BuildContext context) {
    final adminWatch = ref.watch(adminViewModelProvider);
    final adminRead = ref.read(adminViewModelProvider.notifier);

    final appSize = MediaQuery.of(context).size;
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
                      'assets/svg/back.svg',
                      height: 16,
                      color: Color(0xff1B1C1E),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "Add Admin",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xff1B1C1E),
                        letterSpacing: -.5,
                      ),
                    ),
                  ],
                ),
                onTap: () => context.pop(),
              ),
              const SizedBox(height: 26),
              _buildLabelWithAsterisk("First Name"),
              OutlineTextField(
                controller: adminRead.firstNameController,
                hintText: 'Enter First Name',
                obscureText: false,
              ),
              const SizedBox(height: 12),
              _buildLabelWithAsterisk("Last Name"),
              OutlineTextField(
                controller: adminRead.lastNameController,
                hintText: 'Enter Last Name',
                obscureText: false,
              ),
              const SizedBox(height: 12),
              _buildLabelWithAsterisk("Email Address"),
              OutlineTextField(
                controller: adminRead.emailController,
                hintText: 'Enter Email Address',
                obscureText: false,
              ),
              const SizedBox(height: 12),
              _buildLabelWithAsterisk("Password"),
              OutlineTextField(
                controller: adminRead.passwordController,
                hintText: 'Enter Password',
                obscureText: adminWatch.obscurePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    adminRead.togglePassword();
                  },
                  icon: adminWatch.obscurePassword
                      ? SvgPicture.asset(
                          'assets/svg/view-off-slash-stroke-rounded.svg',
                          height: 25.0,
                          width: 25.0,
                        )
                      : Column(
                          children: [
                            SvgPicture.asset(
                              'assets/svg/view-stroke-rounded.svg',
                              height: 25.0,
                              width: 25.0,
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 12),
              _buildLabelWithAsterisk("Role"),
              Container(
                height: 54.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xffE9EAEB), width: 1.5),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: adminWatch.role,
                    icon: SvgPicture.asset(
                      'assets/svg/arrow_dropdown.svg',
                      width: 13,
                      height: 13,
                      color: const Color(0xff121827),
                    ),
                    items: adminRead.roleModel?.map((value) {
                      return DropdownMenuItem(
                        value: value.id,
                        child: Text(
                          value.name!,
                          style: TextStyle(
                              color: Color(0xff121827),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        onTap: () {
                          setState(() {});
                        },
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        adminWatch.role = value;
                      });
                    },
                  ),
                ),
              ),
              // OutlineDropdown(
              //   options: adminRead.roleList,
              //   onChanged: (value) {
              //     adminWatch.role = value;
              //   },
              // ),

              const SizedBox(height: 12),
              // Text(
              //   "Permissions",
              //   style: TextStyle(
              //     fontWeight: FontWeight.w900,
              //     fontSize: 20,
              //     color: Color(0xff1B1C1E),
              //     letterSpacing: -.5,
              //   ),
              // ),
              // SizedBox(
              //   height: 13,
              // ),
              // Container(
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       border:
              //           Border.all(color: const Color(0xffE9EAEB), width: 1.5),
              //       borderRadius: BorderRadius.circular(15.0),
              //     ),
              //     padding: const EdgeInsets.symmetric(
              //         horizontal: 12.0, vertical: 8.0),
              //     child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           _buildLabelWithAsterisk("State"),
              //           OutlineDropdown( ['Osun', 'Justin']),
              //           const SizedBox(height: 12),
              //           _buildLabel("LGA"),
              //           OutlineDropdown(['Boluwaduro']),
              //           const SizedBox(height: 12),
              //           _buildLabel("Facility"),
              //           OutlineDropdown(['Afao Primary Health Clinic']),
              //         ])),
              const SizedBox(height: 30),
              SizedBox(
                  height: 48.0,
                  width: double.infinity, // Make button full width
                  child: TextButton(
                    onPressed: () {
                      adminRead.addAdmin(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: red,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12.0), // border radius
                      ),
                    ),
                    child: const Text(
                      "Create Admin",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xff1B1C1E),
            letterSpacing: -.5,
          ),
        ));
  }

  Widget _buildLabelWithAsterisk(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
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
