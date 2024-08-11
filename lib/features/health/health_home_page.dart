import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:misau/app/theme/colors.dart';
import 'package:misau/features/health/health_details.dart';
import 'package:misau/features/health/health_facilities_view_model.dart';
import 'package:misau/utils/utils.dart';
import 'package:misau/widget/shimmer.dart';

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
    final facilitiesRead = ref.read(healthFacilitiesViemodelProvider.notifier);

    facilitiesRead.onInit ? null : facilitiesRead.fetchFacilities(context);
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
                        'assets/svg/search.svg',
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
                        'assets/svg/notification.svg',
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
                  "Health Facilities",
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
                Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Search transactions',
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
                    const Spacer(),
                    Container(
                      width: 50.0,
                      height: 50.0,
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
                    Container(
                      width: 50.0,
                      height: 50.0,
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
                                    itemCount:
                                        facilitiesWatch.facilitiesModel.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        FacilityCardItem(
                                      facilityName: facilitiesWatch
                                          .facilitiesModel[index].name,
                                      lga: facilitiesWatch
                                          .facilitiesModel[index].lga,
                                      state: facilitiesWatch
                                          .facilitiesModel[index].state,
                                      isActive: facilitiesWatch
                                          .facilitiesModel[index].isActive,
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

class FacilityCardItem extends StatelessWidget {
  final String? facilityName;
  final String? lga;
  final String? state;
  final String? isActive;

  const FacilityCardItem({
    super.key,
    this.facilityName,
    this.lga,
    this.state,
    this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HealthDetails()),
        );
      },
    );
  }
}
