import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:positive_metering/screens/follow_up/follow_up_screen.dart';
import 'package:positive_metering/utils/app_colors.dart';
import 'package:positive_metering/utils/widgets/common_app_bar.dart';

class ViewAddFollowUpScreen extends StatefulWidget {
  const ViewAddFollowUpScreen({super.key});

  @override
  State<ViewAddFollowUpScreen> createState() => _ViewAddFollowUpScreenState();
}

class _ViewAddFollowUpScreenState extends State<ViewAddFollowUpScreen> {
  DateTime? enquiryDate;
  DateTime? followUpDate;

  final DateFormat _formatter = DateFormat('dd-MM-yyyy');

  String? customer;
  String? sector;
  String? status;
  String? lostReason;
  String? followUpDoneBy;

  final Set<String> selectedProducts = {};

  final List<String> products = ["Dosing Pumps", "SC Pumps", "ED Pumps"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CommonAppBar(showBack: true, showDrawer: false, showAdd: false),

      /// FIXED BUTTONS
      bottomNavigationBar: _actionButtons(),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 12.h),

            Text(
              "View and Add Follow-up",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 16.h),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Date"),
                    _dateField(enquiryDate, (d) => enquiryDate = d),

                    SizedBox(height: 20.h),
                    _label("Customer Name"),
                    _dropdown("Customer Name", customer, (v) {
                      setState(() => customer = v);
                    }),

                    SizedBox(height: 20.h),
                    _label("Sector"),
                    _dropdown("Select the Sector", sector, (v) {
                      setState(() => sector = v);
                    }),

                    SizedBox(height: 20.h),
                    _label("Product"),
                    _productGrid(),

                    SizedBox(height: 20.h),
                    _label("Comments"),
                    _textField("Description"),

                    SizedBox(height: 24.h),

                    /// FOLLOW-UP HISTORY
                    _followUpHistory(),

                    SizedBox(height: 24.h),
                    _label("Status"),
                    _dropdown("Select Status", status, (v) {
                      setState(() => status = v);
                    }),

                    SizedBox(height: 20.h),
                    _label("Lost Reason"),
                    _dropdown("Select", lostReason, (v) {
                      setState(() => lostReason = v);
                    }),

                    SizedBox(height: 20.h),
                    _label("Follow-up Done By"),
                    _dropdown("Select", followUpDoneBy, (v) {
                      setState(() => followUpDoneBy = v);
                    }),

                    SizedBox(height: 20.h),
                    _label("Date"),
                    _dateField(followUpDate, (d) => followUpDate = d),

                    SizedBox(height: 20.h),
                    _label("Comments"),
                    _textField("Description"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
    );
  }

  Widget _dateField(DateTime? date, Function(DateTime) onPicked) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
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
        if (picked != null) setState(() => onPicked(picked));
      },
      child: Container(
        height: 46.h,
        margin: EdgeInsets.only(top: 6.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColor.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date == null ? "Select Date" : _formatter.format(date)),
            const Icon(Icons.calendar_month),
          ],
        ),
      ),
    );
  }

  Widget _dropdown(String hint, String? value, Function(String?) onChanged) {
    final items = ["Option 1", "Option 2", "Option 3"];
    return Container(
      height: 46.h,
      margin: EdgeInsets.only(top: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColor.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _textField(String hint) {
    return Container(
      height: 80.h,
      margin: EdgeInsets.only(top: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColor.grey),
      ),
      child: TextField(
        maxLines: null,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
      ),
    );
  }

  Widget _productGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 10.h),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (_, i) {
        final item = products[i];
        final isSelected = selectedProducts.contains(item);
        return InkWell(
          onTap: () {
            setState(() {
              isSelected
                  ? selectedProducts.remove(item)
                  : selectedProducts.add(item);
            });
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isSelected ? AppColor.primaryRed : AppColor.grey,
              ),
            ),
            child: Text(
              item,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? AppColor.primaryRed : AppColor.textDark,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _followUpHistory() {
    // dummy data (later this will come from API)
    final List<Map<String, String>> historyData = [
      {
        "date": "29-01-2026",
        "comments": "Called customer",
        "status": "Open",
        "nextDate": "01-02-2026",
      },
      {
        "date": "01-02-2026",
        "comments": "Meeting scheduled",
        "status": "Pending",
        "nextDate": "05-02-2026",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Follow-up History",
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.textDark,
          ),
        ),
        SizedBox(height: 10.h),

        /// HORIZONTAL SCROLL WRAPPER
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColor.grey),
            ),
            child: DataTable(
              border: TableBorder(
                horizontalInside: BorderSide(color: AppColor.grey),
                verticalInside: BorderSide(color: AppColor.grey),
              ),
              headingRowColor: MaterialStateProperty.all(AppColor.primaryRed),
              columnSpacing: 24.w,

              columns: const [
                DataColumn(
                  label: Text(
                    "Followup Date",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Comments",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DataColumn(
                  label: Text("Status", style: TextStyle(color: Colors.white)),
                ),
                DataColumn(
                  label: Text(
                    "Next Followup Date",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],

              rows: historyData.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item["date"] ?? "")),
                    DataCell(
                      SizedBox(
                        width: 160.w,
                        child: Text(
                          item["comments"] ?? "",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(Text(item["status"] ?? "")),
                    DataCell(Text(item["nextDate"] ?? "")),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButtons() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 35.h),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => FollowUpScreen()),
                  (route) => false,
                );
              },
              child: Container(
                height: 46.h,
                decoration: BoxDecoration(
                  color: AppColor.primaryRed,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: AppColor.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Container(
              height: 46.h,
              decoration: BoxDecoration(
                color: AppColor.primaryBlue,
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Text(
                "Reset",
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
}
