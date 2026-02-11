import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:positive_metering/screens/follow_up/view_add_follow_up_screen.dart';
import 'package:positive_metering/utils/animation_helper/animated_page_route.dart';
import 'package:positive_metering/utils/app_colors.dart';
import 'package:positive_metering/utils/widgets/common_app_bar.dart';
import 'package:positive_metering/utils/widgets/common_drawer.dart';

class FollowUpScreen extends StatefulWidget {
  const FollowUpScreen({super.key});

  @override
  State<FollowUpScreen> createState() => _FollowUpScreenState();
}

class _FollowUpScreenState extends State<FollowUpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  final DateFormat _formatter = DateFormat('dd-MM-yyyy');

  String status = "ALL";
  String salesPerson = "ALL";
  String showEntries = "10";

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
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Text(
              "Follow-Up",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 16.h),

            /// DATE FILTER
            Row(
              children: [
                _dateBox("From Date", fromDate, _pickFromDate),
                SizedBox(width: 12.w),
                _dateBox("To Date", toDate, _pickToDate),
              ],
            ),

            SizedBox(height: 16.h),

            /// STATUS + SALES PERSON
            Row(
              children: [
                _dropdownBox("Status", status, [
                  "ALL",
                  "Open",
                  "Closed",
                ], (val) => setState(() => status = val)),
                SizedBox(width: 12.w),
                _dropdownBox(
                  "Sales Person",
                  salesPerson,
                  ["ALL", "XYZ", "Ketan"],
                  (val) => setState(() => salesPerson = val),
                ),
                SizedBox(width: 12.w),
                _viewButton(),
              ],
            ),
            SizedBox(height: 10.h),

            Divider(height: 32.h, color: AppColor.black),

            SizedBox(height: 10.h),

            /// SHOW ENTRIES + SEARCH
            Row(
              children: [
                Row(
                  children: [
                    Text(
                      "Show ",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColor.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _smallDropdown(showEntries, [
                      "10",
                      "25",
                      "50",
                    ], (val) => setState(() => showEntries = val)),
                    Text(
                      " entries",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColor.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _searchBox(),
              ],
            ),

            SizedBox(height: 16.h),

            /// LIST
            Expanded(child: ListView(children: const [FollowUpCard()])),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------

  Widget _dateBox(String label, DateTime date, VoidCallback onTap) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColor.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          InkWell(
            onTap: onTap,
            child: Container(
              height: 46.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColor.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatter.format(date)),
                  Icon(Icons.calendar_month, size: 18.sp),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownBox(
    String label,
    String value,
    List<String> items,
    Function(String) onChanged,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColor.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            height: 46.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColor.grey),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                items: items
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => onChanged(val!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _viewButton() {
    return Padding(
      padding: EdgeInsets.only(top: 22.h),
      child: Container(
        height: 46.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColor.primaryRed,
          borderRadius: BorderRadius.circular(8.r),
        ),
        alignment: Alignment.center,
        child: Text(
          "View",
          style: TextStyle(color: AppColor.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _smallDropdown(
    String value,
    List<String> items,
    Function(String) onChanged,
  ) {
    return Container(
      height: 32.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColor.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => onChanged(val!),
        ),
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      height: 36.h,
      width: 130.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColor.grey),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 18.sp),
          SizedBox(width: 6.w),
          const Expanded(child: Text("Search")),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------

  Future<void> _pickFromDate() async {
    final picked = await _showPicker(fromDate, first: DateTime(2000));

    if (picked != null) {
      setState(() {
        fromDate = picked;
        toDate = picked;
      });
    }
  }

  Future<void> _pickToDate() async {
    final picked = await _showPicker(toDate, first: fromDate);
    if (picked != null) {
      setState(() => toDate = picked);
    }
  }

  Future<DateTime?> _showPicker(DateTime initial, {DateTime? first}) {
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first ?? DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColor.primaryRed),
          ),
          child: child!,
        );
      },
    );
  }
}

/// --------------------------------------------------------------------
/// FOLLOW UP CARD
/// --------------------------------------------------------------------

class FollowUpCard extends StatelessWidget {
  const FollowUpCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColor.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row("Follow-up Date :", "29-01-2026"),
          _row("Customer Name :", "Vinod Takekar"),
          _row("Customer Phone :", "9822090099"),
          _row("Products :", "Dosing Pump"),
          _row("Assign To :", "Ketan"),
          _row("Status :", "XYZ"),

          SizedBox(height: 12.h),

          InkWell(
            onTap: () {
              Navigator.push(
                context,
                AnimatedPageRoute(page: ViewAddFollowUpScreen()),
              );
            },
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColor.primaryRed,
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Text(
                "View and Add Follow-up",
                style: TextStyle(
                  color: AppColor.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
