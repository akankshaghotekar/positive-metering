import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:positive_metering/utils/app_colors.dart';
import 'package:positive_metering/utils/widgets/common_app_bar.dart';
import 'package:positive_metering/utils/widgets/common_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      key: _scaffoldKey,
      drawer: CommonDrawer(onClose: () => Navigator.pop(context)),
      appBar: CommonAppBar(
        scaffoldKey: _scaffoldKey,
        showDrawer: true,
        showAdd: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 100.h),

          /// LOGO
          Image.asset('assets/images/Positive-Logo.png', width: 200.w),

          /// WELCOME TEXT
          Text(
            "Welcome to",
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColor.grey,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 6.h),

          Text(
            "Positive Metering",
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textDark,
            ),
          ),

          SizedBox(height: 14.h),

          /// SUBTEXT
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              "Manage enquiries, tour plans, attendance and follow-ups easily from one place.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColor.grey,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
