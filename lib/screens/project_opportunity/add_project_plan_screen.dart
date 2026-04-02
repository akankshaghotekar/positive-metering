import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:positive_metering/utils/app_colors.dart';
import 'package:positive_metering/utils/widgets/common_app_bar.dart';

class AddProjectPlanScreen extends StatefulWidget {
  const AddProjectPlanScreen({super.key});

  @override
  State<AddProjectPlanScreen> createState() => _AddProjectPlanScreenState();
}

class _AddProjectPlanScreenState extends State<AddProjectPlanScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? date;
  DateTime? startDate;

  final DateFormat _formatter = DateFormat('dd-MM-yyyy');

  final TextEditingController projectNameCtrl = TextEditingController();
  final TextEditingController productCtrl = TextEditingController();
  final TextEditingController commentsCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,

      /// APP BAR
      appBar: const CommonAppBar(
        showBack: true,
        showDrawer: false,
        showAdd: false,
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),

            /// TITLE
            Text(
              "Add Project Plan",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textDark,
              ),
            ),

            SizedBox(height: 20.h),

            /// FORM
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Date"),
                      _dateField(date, (d) => setState(() => date = d)),

                      SizedBox(height: 18.h),
                      _label("Project Name"),
                      _textField(projectNameCtrl, "Enter Name"),

                      SizedBox(height: 18.h),
                      _label("Product Applicable"),
                      _textField(productCtrl, "Enter the product applicable"),

                      SizedBox(height: 18.h),
                      _label("Start Date"),
                      _dateField(
                        startDate,
                        (d) => setState(() => startDate = d),
                      ),

                      SizedBox(height: 18.h),
                      _label("Comments"),
                      _commentField(),

                      SizedBox(height: 30.h),

                      /// ACTION BUTTONS
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Project Plan Saved",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: AppColor.primaryRed,
                                    ),
                                  );

                                  Navigator.pop(context);
                                }
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

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // UI HELPERS
  // --------------------------------------------------

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
    );
  }

  Widget _dateField(DateTime? value, Function(DateTime) onPicked) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
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
        if (picked != null) onPicked(picked);
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
            Text(
              value == null ? "Select Date" : _formatter.format(value),
              style: TextStyle(fontSize: 14.sp),
            ),
            const Icon(Icons.calendar_month),
          ],
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

  Widget _commentField() {
    return Container(
      height: 80.h,
      margin: EdgeInsets.only(top: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColor.grey),
      ),
      child: TextFormField(
        controller: commentsCtrl,
        maxLines: null,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Comments are required";
          }
          return null;
        },
        decoration: const InputDecoration(
          hintText: "Description",
          border: InputBorder.none,
          errorStyle: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
