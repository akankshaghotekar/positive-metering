import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:positive_metering/api/api_service.dart';
import 'package:positive_metering/model/customer_model.dart';
import 'package:positive_metering/shared_pref/app_pref.dart';
import 'package:positive_metering/utils/app_colors.dart';
import 'package:positive_metering/utils/widgets/common_app_bar.dart';
import 'package:positive_metering/utils/widgets/common_drawer.dart';

class CustomerMasterScreen extends StatefulWidget {
  const CustomerMasterScreen({super.key});

  @override
  State<CustomerMasterScreen> createState() => _CustomerMasterScreenState();
}

class _CustomerMasterScreenState extends State<CustomerMasterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController searchCtrl = TextEditingController();
  List<CustomerModel> customerList = [];
  List<CustomerModel> filteredCustomers = [];

  bool isLoading = true;
  Map<String, String> regionMap = {};

  void _showLadleConfirmDialog(
    BuildContext context,
    CustomerModel data,
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
                  data.isLadle = !isLadle;
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

  Future<void> loadCustomers() async {
    setState(() => isLoading = true);

    final user = await AppPref.getUser();

    /// CUSTOMER API
    final customerData = await ApiService.getCustomerList(
      userSrNo: user?['usersrno'] ?? "",
      regionSrNo: user?['region_srno'] ?? "",
      subregionSrNo: user?['subregion_srno'] ?? "",
    );

    /// REGION API
    final regions = await ApiService.getRegion();

    /// CREATE MAP
    regionMap = {for (var region in regions) region.id: region.name};

    setState(() {
      customerList = customerData;
      filteredCustomers = customerData;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    searchCtrl.addListener(_onSearch);

    loadCustomers();
  }

  void _onSearch() {
    final query = searchCtrl.text.toLowerCase();

    setState(() {
      filteredCustomers = customerList.where((customer) {
        return customer.companyName.toLowerCase().contains(query) ||
            customer.customerName.toLowerCase().contains(query) ||
            customer.mobileNo.toLowerCase().contains(query);
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
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
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
  Widget _customerCard(CustomerModel data) {
    bool isLadle = data.isLadle;
    final regionName = regionMap[data.regionSrNo] ?? "N/A";

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
              _row("Company Name:", data.companyName),
              SizedBox(height: 6.h),

              _row("Name:", data.customerName),
              SizedBox(height: 6.h),

              _row("Mobile No:", data.mobileNo),
              SizedBox(height: 6.h),

              _row("Customer Type:", data.customerType),
              SizedBox(height: 6.h),

              _row("Group:", data.groupName),
              SizedBox(height: 6.h),

              _row("Region:", regionName),
              SizedBox(height: 15.h),

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
