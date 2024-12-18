import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../widgets/constants.dart';

class SliderWidget extends StatefulWidget {
  final bool isWeb;
  const SliderWidget({Key? key, this.isWeb = false}) : super(key: key);

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  final pageController = PageController();

  List sliderList = [
    "assets/images/cons1.jpg",
    "assets/images/cons2.jpg",
    "assets/images/cons3.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return widget.isWeb
        ? buildWebView()
        : Column(
            children: [
              SizedBox(
                height: 35.h,
                child: PageView(
                  controller: pageController,
                  children: [
                    buildFeedbackList("assets/images/cons1.jpg"),
                    buildFeedbackList("assets/images/cons2.jpg"),
                    buildFeedbackList("assets/images/cons3.jpg"),
                  ],
                ),
              ),
              SizedBox(height: 1.h),
              SmoothPageIndicator(
                controller: pageController,
                count: 3,
                axisDirection: Axis.horizontal,
                effect: WormEffect(
                  dotColor: gsecondaryColor.withOpacity(0.3),
                  activeDotColor: gsecondaryColor,
                  // jumpScale: 2,
                ),
              ),
            ],
          );
  }

  buildFeedbackList(String assetName) {
    return Center(
      child: IntrinsicWidth(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
          margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 0.w),
          // width: double.maxFinite,
          decoration: BoxDecoration(
            color: gWhiteColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: gGreyColor.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: gBlackColor.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(2, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: AssetImage(assetName),
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      ),
    );
  }

  buildMainView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor's Profile Section
          Center(
            child: Column(
              children: [
                // Doctor's Image
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://example.com/doctor_image.jpg'), // Replace with actual image URL
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Doctor's Name and Details
                const Text(
                  "Dr. Albertson Cooper",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Los Angeles, California",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildInfoChip(Icons.star, "4.5", "Review"),
                    const SizedBox(width: 10),
                    _buildInfoChip(Icons.work, "7y", "Experience"),
                    const SizedBox(width: 10),
                    _buildInfoChip(Icons.people, "110+", "Patients"),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Doctor Biography Section
          const Text(
            "Doctor Biography",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Dr. Albertson Cooper has over 7 years of experience in the field of medicine. He is one of the best oncologists and is well renowned.",
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 20),

          // Available Dates Section
          const Text(
            "Available Dates",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDateChip("14", "Sun"),
                _buildDateChip("16", "Tue"),
                _buildDateChip("18", "Thu"),
                _buildDateChip("20", "Sat"),
                _buildDateChip("22", "Mon"),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Location Section
          const Text(
            "Location",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(Icons.map, size: 100, color: Colors.grey),
            ),
          ),

          const Spacer(),

          // Book Appointment Button
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                "Book Appointment",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String subLabel) {
    return Chip(
      label: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.blueAccent),
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(subLabel, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildDateChip(String date, String day) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            date,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            day,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  buildWebView() {
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
          physics: const ScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: sliderList.length,
          itemBuilder: (_, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 2.h,horizontal: 1.5.w),
              padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 1.5.w),
              decoration: BoxDecoration(
                color: gWhiteColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: NetworkImage(
                    sliderList[index],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
