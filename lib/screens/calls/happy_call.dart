import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:positive_metering/utils/app_colors.dart';
import 'package:positive_metering/utils/widgets/common_app_bar.dart';
import 'package:positive_metering/utils/widgets/common_drawer.dart';

class HappyCallScreen extends StatefulWidget {
  const HappyCallScreen({super.key});

  @override
  State<HappyCallScreen> createState() => _HappyCallScreenState();
}

class _HappyCallScreenState extends State<HappyCallScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Static contacts (for now)
  final List<Map<String, String>> contacts = [
    {"name": "Akanksha Ghotekar", "mobile": "8767545099"},
    {"name": "Rahul Sharma", "mobile": "9876543210"},
    {"name": "Priya Singh", "mobile": "9123456780"},
    {"name": "Vikram Patel", "mobile": "9988776655"},
    {"name": "Sneha Kapoor", "mobile": "9876501234"},
  ];

  final TextEditingController searchCtrl = TextEditingController();

  List<Map<String, String>> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    filteredContacts = List.from(contacts);
    searchCtrl.addListener(_onSearch);
  }

  void _onSearch() {
    final query = searchCtrl.text.toLowerCase();
    setState(() {
      filteredContacts = contacts.where((c) {
        return c["name"]!.toLowerCase().contains(query) ||
            c["mobile"]!.toLowerCase().contains(query);
      }).toList();
    });
  }

  // ---------------------------------------------------------------
  Future<void> _makeCall(String number) async {
    final Uri uri = Uri(scheme: 'tel', path: number);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Unable to open dialer")));
    }
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CommonDrawer(onClose: () => Navigator.pop(context)),
      backgroundColor: AppColor.white,

      /// COMMON APP BAR
      appBar: CommonAppBar(
        scaffoldKey: _scaffoldKey,
        showDrawer: true,
        showAdd: false,
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 12.h),

            /// TITLE
            Text(
              "Happy Call",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 16.h),

            /// SEARCH BAR
            Container(
              height: 46.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColor.grey),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColor.grey),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      controller: searchCtrl,
                      onChanged: (_) => _onSearch(), // ensures live update
                      decoration: const InputDecoration(
                        hintText: "Search by name or mobile",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (searchCtrl.text.isNotEmpty)
                    InkWell(
                      onTap: () {
                        searchCtrl.clear();
                      },
                      child: const Icon(Icons.close, size: 18),
                    ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            /// CONTACT LIST
            Expanded(
              child: ListView.separated(
                itemCount: filteredContacts.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final data = filteredContacts[index];
                  return _contactCard(data);
                },
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------
  Widget _contactCard(Map<String, String> data) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColor.primaryBlue),
      ),
      child: Row(
        children: [
          /// DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["name"] ?? "",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textDark,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  data["mobile"] ?? "",
                  style: TextStyle(fontSize: 14.sp, color: AppColor.textDark),
                ),
              ],
            ),
          ),

          /// CALL ICON
          InkWell(
            onTap: () => _makeCall(data["mobile"] ?? ""),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(Icons.call, color: AppColor.white, size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }
}
