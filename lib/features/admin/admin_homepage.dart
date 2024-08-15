import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:misau/features/admin/add_admin.dart';
import 'package:misau/features/admin/admin_view_model.dart';
import 'package:misau/features/health/health_details.dart';
import 'package:misau/features/home/homepage.dart';
import 'package:misau/utils/utils.dart';
import 'package:misau/widget/custom_dropdown.dart';
import 'package:misau/widget/custom_pie_chart.dart';
import 'package:misau/widget/shimmer.dart';
import 'package:misau/widget/user_avarta.dart';

class AdminHomePage extends ConsumerStatefulWidget {
  const AdminHomePage({
    super.key,
  });

  @override
  ConsumerState<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends ConsumerState<AdminHomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String> options = ['Monthly', 'Weekly', 'Daily'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final adminRead = ref.read(adminViewModelProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This will run after the build method is completed
      adminRead.fetchAdmins(context);
      adminRead.getRoles(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminWatch = ref.watch(adminViewModelProvider);
    final adminRead = ref.read(adminViewModelProvider.notifier);
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
                        firstName: adminWatch.userData?.firstName ?? '',
                        lastName: adminWatch.userData?.lastName ?? ''),
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
                          'assets/svg/filter.svg',
                          height: 20,
                        ),
                      ),
                      onTap: () {
                        Utils.showFilterBottomSheet(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 26,
                ),
                const Text(
                  "Admins",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white,
                    letterSpacing: -.5,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: adminWatch.searchController,
                        onChanged: (value) {
                          adminRead.getFilteredAdmins();
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Search admin',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(11.5),
                            child: SvgPicture.asset(
                              'assets/svg/search.svg',
                              color: Colors.black,
                              width: 16,
                              height: 16,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                        ),
                        style: const TextStyle(
                          fontSize: 15.0,
                          letterSpacing: -.5,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff313131),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        'assets/svg/export.svg',
                        height: 19,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    InkWell(
                      child: Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffDC1D3C),
                        ),
                        padding: const EdgeInsets.all(13),
                        child: SvgPicture.asset(
                          'assets/svg/add.svg',
                          height: 10,
                          width: 10,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddAdminPage()));
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Column(
                        children: [
                          adminWatch.isLoading
                              ? const ShimmerScreenLoading(
                                  height: 600.0,
                                  width: double.infinity,
                                  radius: 14.0,
                                )
                              : Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  child: ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      height: 25,
                                    ),
                                    itemCount: adminWatch.searchAdmins!.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        AdminCardItem(
                                      title:
                                          '${adminWatch.searchAdmins![index].firstName ?? ''} ${adminWatch.searchAdmins![index].lastName ?? ''}',
                                      role:
                                          adminWatch.searchAdmins![index].role,
                                      phoneNumber: adminWatch
                                          .searchAdmins![index].phoneNumber,
                                      isActive: adminWatch
                                              .searchAdmins![index].isActive!
                                          ? 'Active'
                                          : 'Inactive',
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 13,
                          ),
                        ],
                      ),
                    ),
                  ),
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

class AdminCardItem extends StatelessWidget {
  final String? title;
  final String? role;
  final String? phoneNumber;
  final String? isActive;
  final VoidCallback? onTap;
  const AdminCardItem(
      {super.key,
      this.title,
      this.role,
      this.isActive,
      this.phoneNumber,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? 'N/A',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xff1B1C1E),
                  letterSpacing: -.5,
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                role ?? 'N/A',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
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
              Text(
                phoneNumber ?? 'N/A',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
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
                  child: Text(
                    isActive ?? 'N/A',
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
      onTap: onTap,
    );
  }
}
