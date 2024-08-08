import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:misau/features/admin/add_admin.dart';
import 'package:misau/features/health/health_details.dart';
import 'package:misau/features/home/homepage.dart';
import 'package:misau/features/profile/personal_info.dart';
import 'package:misau/features/profile/preferences.dart';
import 'package:misau/widget/custom_dropdown.dart';
import 'package:misau/widget/custom_pie_chart.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String> options = ['Monthly', 'Weekly', 'Daily'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final appSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F7),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 350,
            color: const Color(0xff1A1A1A),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 43.0,
                      height: 43.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xff313131), // Border color
                          width: 5, // Border width
                        ),
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            'https://gravatar.com/avatar/0d6eff6c107827ccf1a5dd478d540700?s=400&d=robohash&r=x', // Replace with your image URL
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 43.0,
                      height: 43.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff313131),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        'assets/search.svg',
                        height: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 43.0,
                      height: 43.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff313131),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        'assets/notification.svg',
                        height: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      child: Container(
                        width: 43.0,
                        height: 43.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff313131),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset(
                          'assets/filter.svg',
                          height: 20,
                        ),
                      ),
                      onTap: () {
                        showFilterBottomSheet(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 26,
                ),
                const Text(
                  "Profile",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 23,
                    color: Colors.white,
                    letterSpacing: -.5,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  child: Column(children: [
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        width: double.infinity,
                        height: 65,
                        decoration: BoxDecoration(
                          color: const Color(0xffDC1D3D),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.all(9),
                              child: SvgPicture.asset(
                                'assets/user.svg',
                                height: 24,
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            const Text(
                              "Personal Information",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: Colors.white,
                                letterSpacing: -.5,
                              ),
                            ),
                            Spacer(),
                            SvgPicture.asset(
                              'assets/arrow-right.svg',
                              height: 20,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PersonalInfoPage()));
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffECF1F3),
                              ),
                              padding: const EdgeInsets.all(9),
                              child: SvgPicture.asset(
                                'assets/devices.svg',
                                height: 24,
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            const Text(
                              "Preferences",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: Color(0xff1B1C1E),
                                letterSpacing: -.5,
                              ),
                            ),
                            Spacer(),
                            SvgPicture.asset(
                              'assets/arrow-right.svg',
                              height: 20,
                              color: const Color(0xffABB5BC),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PreferencesPage()));
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffECF1F3),
                            ),
                            padding: const EdgeInsets.all(9),
                            child: SvgPicture.asset(
                              'assets/lock.svg',
                              height: 24,
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          const Text(
                            "Change Password",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Color(0xff1B1C1E),
                              letterSpacing: -.5,
                            ),
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            'assets/arrow-right.svg',
                            height: 20,
                            color: const Color(0xffABB5BC),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text) {
    return Tab(
      text: text,
      height: 38,
    );
  }
}

class FacilityCardItem extends StatelessWidget {
  const FacilityCardItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ayodele General Hos.",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: Color(0xff1B1C1E),
                  letterSpacing: -.5,
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                "Ori-Ade . Osun State",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xffABB5BC),
                  letterSpacing: -.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "100,000.00",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: Color(0xff1B1C1E),
                  letterSpacing: -.5,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                  decoration: BoxDecoration(
                    color: Color(0xffF0F9F3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: const Text(
                    "ACTIVE",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xff31AF99),
                      letterSpacing: -.5,
                    ),
                  ))
            ],
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HealthDetails()),
        );
      },
    );
  }
}
