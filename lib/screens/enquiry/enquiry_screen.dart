import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:positive_metering/screens/enquiry/add_enquiry_screen.dart';
import 'package:positive_metering/utils/animation_helper/animated_page_route.dart';
import 'package:positive_metering/utils/app_colors.dart';
import 'package:positive_metering/utils/widgets/common_app_bar.dart';
import 'package:positive_metering/utils/widgets/common_drawer.dart';
import 'package:positive_metering/utils/widgets/enquiry_card.dart';

class EnquiryScreen extends StatefulWidget {
  const EnquiryScreen({super.key});

  @override
  State<EnquiryScreen> createState() => _EnquiryScreenState();
}

class _EnquiryScreenState extends State<EnquiryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      key: _scaffoldKey,
      drawer: CommonDrawer(onClose: () => Navigator.pop(context)),
      appBar: CommonAppBar(
        scaffoldKey: _scaffoldKey,
        showAdd: true,
        onAddTap: () {
          Navigator.push(context, AnimatedPageRoute(page: AddEnquiryScreen()));
        },
        showDrawer: true,
        onBack: null,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Order Enquiry",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
            ),

            SizedBox(height: 20.h),

            /// FILTER ROW
            Row(
              children: [
                _dateBox(
                  label: "From Date",
                  date: fromDate,
                  onTap: _pickFromDate,
                ),
                SizedBox(width: 12.w),
                _dateBox(label: "To Date", date: toDate, onTap: _pickToDate),
                SizedBox(width: 12.w),
                _viewButton(),
              ],
            ),

            SizedBox(height: 24.h),

            /// LIST
            Expanded(
              child: ListView(children: const [EnquiryCard(), EnquiryCard()]),
            ),
          ],
        ),
      ),
    );
  }

  /// DATE PICKERS ------------------------------------------------------

  Future<void> _pickFromDate() async {
    final selected = await _showDatePicker(
      initialDate: fromDate,
      firstDate: DateTime(2000),
    );

    if (selected != null) {
      setState(() {
        fromDate = selected;
        toDate = selected;
      });
    }
  }

  Future<void> _pickToDate() async {
    final selected = await _showDatePicker(
      initialDate: toDate,
      firstDate: fromDate,
    );

    if (selected != null) {
      setState(() {
        toDate = selected;
      });
    }
  }

  Future<DateTime?> _showDatePicker({
    required DateTime initialDate,
    required DateTime firstDate,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.primaryRed,
              onPrimary: AppColor.white,
              onSurface: AppColor.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  /// UI WIDGETS --------------------------------------------------------

  Widget _dateBox({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8.h),
          InkWell(
            onTap: onTap,
            child: Container(
              height: 46.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColor.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _dateFormat.format(date),
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  Icon(Icons.calendar_month, size: 20.sp),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _viewButton() {
    return Padding(
      padding: EdgeInsets.only(top: 26.h),
      child: Container(
        height: 46.h,
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        decoration: BoxDecoration(
          color: AppColor.primaryRed,
          borderRadius: BorderRadius.circular(8.r),
        ),
        alignment: Alignment.center,
        child: Text(
          "View",
          style: TextStyle(
            color: AppColor.white,
            fontSize: 15.sp, // 🔼 Increased
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
