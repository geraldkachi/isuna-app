import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:isuna/app/theme/colors.dart';
import 'package:isuna/features/health/health_details.dart';
import 'package:isuna/features/health/health_facilities_view_model.dart';
import 'package:isuna/utils/utils.dart';
import 'package:isuna/widget/shimmer.dart';
import 'package:isuna/widget/user_avarta.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HealthHomePage extends ConsumerStatefulWidget {
  const HealthHomePage({
    super.key,
  });

  @override
  ConsumerState<HealthHomePage> createState() => _HealthHomePageState();
}

class _HealthHomePageState extends ConsumerState<HealthHomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String> options = ['Monthly', 'Weekly', 'Daily'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This will run after the build method is completed
      final facilitiesRead =
          ref.read(healthFacilitiesViemodelProvider.notifier);

      facilitiesRead.onInit
          ? null
          : facilitiesRead.fetchFacilitiesPagnated(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesWatch = ref.watch(healthFacilitiesViemodelProvider);
    final facilitiesRead = ref.read(healthFacilitiesViemodelProvider.notifier);

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
                    Row(
                      children: [
                        Image.asset(
                          'assets/png/isuna_logo.png',
                          scale: 2.5,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'Isuna',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22.0,
                              color: white100),
                        )
                      ],
                    ),
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
                    //     Utils.showFacilitiesFilterBottomSheet(context);
                    //   },
                    // ),
                    SizedBox(
                      width: 10.0,
                    ),
                    GestureDetector(
                      onTap: facilitiesRead.logout,
                      child: Container(
                        width: 43.0,
                        height: 43.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff313131),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset(
                          'assets/svg/logout.svg',
                          height: 20,
                          colorFilter:
                              ColorFilter.mode(white100, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    UserAvarta(
                        firstName: facilitiesRead.userData.firstName ?? '-',
                        lastName: facilitiesRead.userData.lastName ?? '-'),
                  ],
                ),
                const SizedBox(
                  height: 26,
                ),
                const Text(
                  "Health Facilities",
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
                        controller: facilitiesWatch.searchController,
                        onChanged: (value) {
                          facilitiesRead.getFilteredFacilities();
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Search Facilities',
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
                    const SizedBox(
                      width: 15,
                    ),
                    InkWell(
                      onTap: () {
                        facilitiesWatch.searchController.text.isEmpty
                            ? null
                            : facilitiesRead.searchFacilitiesName(context);
                      },
                      child: Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff313131),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset(
                          'assets/svg/search.svg',
                          height: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
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
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: WaterDropHeader(),
                    footer: ClassicFooter(),
                    controller: facilitiesWatch.facilitiesController,
                    onRefresh: () =>
                        facilitiesRead.onRefreshHealthFacilities(context),
                    onLoading: () =>
                        facilitiesRead.onLoadingHealthFacilities(context),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: Column(
                          children: [
                            facilitiesWatch.isLoading
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
                                      itemCount: facilitiesWatch
                                          .searchFacilities!.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) =>
                                          FacilityCardItem(
                                        onTap: () {
                                          facilitiesWatch.selectedFacility =
                                              facilitiesWatch
                                                  .searchFacilities![index];
                                          context.go(
                                              '/main_screen/health_details');
                                        },
                                        facilityName: facilitiesWatch
                                            .searchFacilities![index].name,
                                        lga: facilitiesWatch
                                            .searchFacilities![index].lga,
                                        state: facilitiesWatch
                                            .searchFacilities![index].state,
                                        isActive: facilitiesWatch
                                            .searchFacilities![index].isActive,
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
  final String? facilityName;
  final String? lga;
  final String? state;
  final String? isActive;
  final VoidCallback? onTap;
  const FacilityCardItem(
      {super.key,
      this.facilityName,
      this.lga,
      this.state,
      this.isActive,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 200.0,
                child: Text(
                  facilityName!,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xff1B1C1E),
                    letterSpacing: -.5,
                  ),
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  Text(
                    "$lga  ",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                      color: Color(0xffABB5BC),
                      letterSpacing: -.5,
                    ),
                  ),
                  Icon(
                    Icons.circle,
                    size: 8.0,
                    color: grey100,
                  ),
                  Text(
                    "  $state",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                      color: Color(0xffABB5BC),
                      letterSpacing: -.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // const Text(
              //   "100,000.00",
              //   style: TextStyle(
              //     fontWeight: FontWeight.w600,
              //     fontSize: 17,
              //     color: Color(0xff1B1C1E),
              //     letterSpacing: -.5,
              //   ),
              // ),
              // const SizedBox(
              //   height: 3,
              // ),
              Container(
                  decoration: BoxDecoration(
                    color: Color(0xffF0F9F3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text(
                    isActive ?? "ACTIVE",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xff31AF99),
                      letterSpacing: -.5,
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
