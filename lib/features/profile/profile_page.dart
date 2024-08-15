import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:misau/features/health/health_details.dart';
import 'package:misau/features/profile/personal_info.dart';
import 'package:misau/features/profile/preferences.dart';
import 'package:misau/features/profile/profile_view_model.dart';
import 'package:misau/utils/utils.dart';
import 'package:misau/widget/user_avarta.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
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
    final profileWatch = ref.watch(profileViewModelProvider);
    final profileRead = ref.read(profileViewModelProvider.notifier);

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
                    UserAvarta(
                        firstName: profileRead.userData.firstName ?? '-',
                        lastName: profileRead.userData.lastName ?? '-'),
                    const Spacer(),
                    // Container(
                    //   width: 43.0,
                    //   height: 43.0,
                    //   decoration: const BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     color: Color(0xff313131),
                    //   ),
                    //   padding: const EdgeInsets.all(10),
                    //   child: SvgPicture.asset(
                    //     'assets/svg/search.svg',
                    //     height: 20,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    // Container(
                    //   width: 43.0,
                    //   height: 43.0,
                    //   decoration: const BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     color: Color(0xff313131),
                    //   ),
                    //   padding: const EdgeInsets.all(10),
                    //   child: SvgPicture.asset(
                    //     'assets/svg/notification.svg',
                    //     height: 20,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    // InkWell(
                    //   child: Container(
                    //     width: 43.0,
                    //     height: 43.0,
                    //     decoration: const BoxDecoration(
                    //       shape: BoxShape.circle,
                    //       color: Color(0xff313131),
                    //     ),
                    //     padding: const EdgeInsets.all(10),
                    //     child: SvgPicture.asset(
                    //       'assets/svg/filter.svg',
                    //       height: 20,
                    //     ),
                    //   ),
                    //   onTap: () {
                    //     Utils.showFilterBottomSheet(context);
                    //   },
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 26,
                ),
                const Text(
                  "Profile",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
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
                                'assets/svg/user.svg',
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
                            const Spacer(),
                            SvgPicture.asset(
                              'assets/svg/arrow-right.svg',
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
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                'assets/svg/devices.svg',
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
                            const Spacer(),
                            SvgPicture.asset(
                              'assets/svg/arrow-right.svg',
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
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              'assets/svg/lock.svg',
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
                          const Spacer(),
                          SvgPicture.asset(
                            'assets/svg/arrow-right.svg',
                            height: 20,
                            color: const Color(0xffABB5BC),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
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
                    color: const Color(0xffF0F9F3),
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
          MaterialPageRoute(builder: (context) => const HealthDetails()),
        );
      },
    );
  }
}
