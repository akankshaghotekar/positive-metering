import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:positive_metering/utils/app_colors.dart';
import 'package:positive_metering/utils/widgets/common_app_bar.dart';
import 'package:positive_metering/utils/widgets/common_drawer.dart';

class CustomerMasterScreen extends StatefulWidget {
  const CustomerMasterScreen({super.key});

  /// Static list for now
  static final List<Map<String, String>> customers = [
    {
      "company": "ABC Industries",
      "name": "Akanksha Ghotekar",
      "mobile": "9876543210",
      "type": "OEM",
      "group": "Water",
      "isLadle": "false",
      "dob": "09-01-2003",
    },
    {
      "company": "XYZ Solutions",
      "name": "Rahul Patil",
      "mobile": "9123456789",
      "type": "Consultant",
      "group": "Oil & Gas",
      "isLadle": "false",
      "dob": "15-03-1985",
    },
    {
      "company": "abc Solutions",
      "name": "Sneha Kulkarni",
      "mobile": "9988776655",
      "type": "User",
      "group": "Chemicals",
      "isLadle": "false",
      "dob": "22-07-1990",
    },
  ];

  @override
  State<CustomerMasterScreen> createState() => _CustomerMasterScreenState();
}

class _CustomerMasterScreenState extends State<CustomerMasterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController searchCtrl = TextEditingController();
  List<Map<String, String>> filteredCustomers = List.from(
    CustomerMasterScreen.customers,
  );

  void _showLadleConfirmDialog(
    BuildContext context,
    Map<String, String> data,
    bool isLadle,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: Text(
            isLadle ? "Remove Ladle Customer" : "Mark as Ladle Customer",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColor.textDark,
            ),
          ),
          content: Text(
            isLadle
                ? 'Do you want to remove this customer from "Ladle Customer"?'
                : 'Do you want to add this customer to "Ladle Customer"?',
            style: TextStyle(fontSize: 14.sp, color: AppColor.textDark),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "No",
                style: TextStyle(fontSize: 14.sp, color: AppColor.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              onPressed: () {
                setState(() {
                  data["isLadle"] = isLadle ? "false" : "true";
                });
                Navigator.pop(context);
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    searchCtrl.addListener(_onSearch);
  }

  void _onSearch() {
    final query = searchCtrl.text.toLowerCase();
    setState(() {
      filteredCustomers = CustomerMasterScreen.customers.where((customer) {
        return customer["company"]!.toLowerCase().contains(query) ||
            customer["name"]!.toLowerCase().contains(query) ||
            customer["mobile"]!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

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
              "Customer Master",
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
                      onChanged: (_) => _onSearch(),
                      decoration: const InputDecoration(
                        hintText: "Search customer...",
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

            /// CUSTOMER LIST
            Expanded(
              child: ListView.separated(
                itemCount: filteredCustomers.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final customer = filteredCustomers[index];
                  return _customerCard(customer);
                },
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  Widget _customerCard(Map<String, String> data) {
    bool isLadle = data["isLadle"] == "true";

    return Stack(
      children: [
        /// MAIN CARD
        Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColor.primaryBlue),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row("Company Name:", data["company"] ?? ""),
              SizedBox(height: 6.h),
              _row("Name:", data["name"] ?? ""),
              SizedBox(height: 6.h),
              _row("Mobile No:", data["mobile"] ?? ""),
              SizedBox(height: 6.h),
              _row("Date Of Birth:", data["dob"] ?? ""),
              SizedBox(height: 6.h),
              _row("Customer Type:", data["type"] ?? ""),
              SizedBox(height: 6.h),
              _row("Group:", data["group"] ?? ""),
              SizedBox(height: 12.h),

              /// VIEW BUTTON
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Icon(
                          Icons.call,
                          color: AppColor.white,
                          size: 18.sp,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_double_arrow_right_sharp,
                        color: Colors.green,
                        size: 20.sp,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 34.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "View History",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        /// HEART ICON (TOP RIGHT – FLOATING)
        Positioned(
          top: 8.h,
          right: 8.w,
          child: InkWell(
            onTap: () {
              _showLadleConfirmDialog(context, data, isLadle);
            },

            child: CircleAvatar(
              child: Icon(
                isLadle ? Icons.favorite : Icons.favorite_border,
                color: isLadle ? Colors.red : AppColor.primaryBlue,
                size: 22.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------------
  Widget _row(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.textDark,
            ),
          ),
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14.sp, color: AppColor.textDark),
          ),
        ),
      ],
    );
  }
}
