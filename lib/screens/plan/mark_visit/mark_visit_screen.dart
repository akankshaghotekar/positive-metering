import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:positive_metering/screens/plan/mark_visit/submit_visit_screen.dart';
import 'package:positive_metering/utils/animation_helper/animated_page_route.dart';
import 'package:positive_metering/utils/app_colors.dart';
import 'package:positive_metering/utils/widgets/common_app_bar.dart';

class MarkVisitScreen extends StatefulWidget {
  const MarkVisitScreen({super.key});

  @override
  State<MarkVisitScreen> createState() => _MarkVisitScreenState();
}

class _MarkVisitScreenState extends State<MarkVisitScreen> {
  DateTime? selectedDate;
  final DateFormat _formatter = DateFormat('dd-MM-yyyy');

  String? customerName;
  String? tourType;
  String? visitCall;
  String? region;
  String? customerType;
  String? group;

  final TextEditingController companyCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController mobileCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: const CommonAppBar(
        showBack: true,
        showDrawer: false,
        showAdd: false,
      ),

      /// FIXED BUTTON
      bottomNavigationBar: _markVisitButton(),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 12.h),

            Text(
              "Mark Visit",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 16.h),

            /// FORM
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Date"),
                    _dateField(),

                    SizedBox(height: 18.h),
                    _label("Customer Name"),
                    _dropdown(
                      "Select the Customer Name",
                      customerName,
                      (v) => setState(() => customerName = v),
                    ),

                    SizedBox(height: 18.h),
                    _label("Tour Type"),
                    _dropdown(
                      "Select the Tour Type",
                      tourType,
                      (v) => setState(() => tourType = v),
                      items: const ["Tour", "Lean"],
                    ),

                    SizedBox(height: 18.h),
                    _label("Visit/Call"),
                    _dropdown(
                      "Select the Visit/Call",
                      visitCall,
                      (v) => setState(() => visitCall = v),
                    ),

                    SizedBox(height: 18.h),
                    _label("Company Name"),
                    _textField(companyCtrl, "Enter Company Name"),

                    SizedBox(height: 18.h),
                    _label("Name"),
                    _textField(nameCtrl, "Enter Name"),

                    SizedBox(height: 18.h),
                    _label("Mobile No"),
                    _textField(mobileCtrl, "Enter Mobile No."),

                    SizedBox(height: 18.h),
                    _label("Region"),
                    _dropdown(
                      "Select the Region",
                      region,
                      (v) => setState(() => region = v),
                    ),

                    SizedBox(height: 18.h),
                    _label("Customer Type"),
                    _dropdown(
                      "Select the type",
                      customerType,
                      (v) => setState(() => customerType = v),
                    ),

                    SizedBox(height: 18.h),
                    _label("Group"),
                    _dropdown(
                      "Select the Group",
                      group,
                      (v) => setState(() => group = v),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // UI HELPERS

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
    );
  }

  Widget _dateField() {
    return InkWell(
      onTap: _pickDate,
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
            Text(
              selectedDate == null
                  ? "Select Date"
                  : _formatter.format(selectedDate!),
              style: TextStyle(fontSize: 14.sp),
            ),
            const Icon(Icons.calendar_month),
          ],
        ),
      ),
    );
  }

  Widget _dropdown(
    String hint,
    String? value,
    Function(String?) onChanged, {
    List<String>? items,
  }) {
    final dropdownItems = items ?? ["Option 1", "Option 2", "Option 3"];

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
          items: dropdownItems
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _textField(TextEditingController controller, String hint) {
    return Container(
      height: 46.h,
      margin: EdgeInsets.only(top: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColor.grey),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
      ),
    );
  }

  // DATE PICKER

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  // MARK VISIT BUTTON

  Widget _markVisitButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 35.h),
      child: SizedBox(
        width: double.infinity,
        height: 46.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryRed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              AnimatedPageRoute(page: SubmitVisitScreen()),
            );
          },
          child: const Text(
            "Mark Visit",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColor.white,
            ),
          ),
        ),
      ),
    );
  }
}
