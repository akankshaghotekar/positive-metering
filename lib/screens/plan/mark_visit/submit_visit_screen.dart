import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:positive_metering/screens/enquiry/enquiry_screen.dart';
import 'package:positive_metering/screens/home/home_screen.dart';

import 'package:positive_metering/utils/animation_helper/animated_page_route.dart';
import 'package:positive_metering/utils/app_colors.dart';
import 'package:positive_metering/utils/widgets/common_app_bar.dart';

class SubmitVisitScreen extends StatefulWidget {
  const SubmitVisitScreen({super.key});

  @override
  State<SubmitVisitScreen> createState() => _SubmitVisitScreenState();
}

class _SubmitVisitScreenState extends State<SubmitVisitScreen> {
  final _formKey = GlobalKey<FormState>();

  String? enquiryGenerated;
  final TextEditingController commentsCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? issueImage;

  final Set<String> selectedProducts = {};

  final List<String> productVerticalList = [
    "Dosing Pumps",
    "Screw Pumps",
    "Systems",
    "AT Pumps",
    "Agitators",
  ];

  Future<void> _openCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        issueImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: const CommonAppBar(
        showBack: true,
        showDrawer: false,
        showAdd: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 12.h),

            Text(
              "Submit Visit",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 24.h),

            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// IMAGE PICKER BOX
                      _imageBox(),

                      SizedBox(height: 20.h),

                      _label("Comments"),
                      _textField(commentsCtrl, "Description"),

                      SizedBox(height: 20.h),

                      _label("Enquiry Generated"),
                      _dropdown(
                        "Select the type",
                        enquiryGenerated,
                        (v) => setState(() => enquiryGenerated = v),
                      ),

                      if (enquiryGenerated == "Yes") ...[
                        SizedBox(height: 20.h),
                        _label("Product"),
                        _productGrid(),
                      ],

                      SizedBox(height: 30.h),

                      SizedBox(height: 30.h),

                      _submitButton(),
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

  Widget _productGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 10.h),
      itemCount: productVerticalList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14.h,
        crossAxisSpacing: 14.w,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (_, index) {
        final item = productVerticalList[index];
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
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              item,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: isSelected ? AppColor.primaryRed : AppColor.textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  // UI WIDGETS

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
    );
  }

  Widget _imageBox() {
    return InkWell(
      onTap: _openCamera,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        height: 120.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.lightGrey,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColor.grey.withOpacity(0.4)),
        ),
        child: issueImage == null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Text(
                      "Click the photo of an\nIssues",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColor.textDark,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20.w),
                    child: Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: AppColor.primaryBlue,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: AppColor.white,
                        size: 28.sp,
                      ),
                    ),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.file(
                  issueImage!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }

  Widget _textField(TextEditingController controller, String hint) {
    return Container(
      height: 80.h,
      margin: EdgeInsets.only(top: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColor.grey),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: null,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Comments are required";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          errorStyle: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget _dropdown(String hint, String? value, Function(String?) onChanged) {
    final items = ["Yes", "No"];

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

  // SUBMIT BUTTON

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 46.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryRed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: _onSubmit,
        child: const Text(
          "Submit",
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.white),
        ),
      ),
    );
  }

  // NAVIGATION LOGIC

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (enquiryGenerated == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please select Enquiry Generated"),
          backgroundColor: AppColor.primaryRed,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16.w),
        ),
      );
      return;
    }

    if (enquiryGenerated == "Yes") {
      Navigator.pushAndRemoveUntil(
        context,
        AnimatedPageRoute(page: EnquiryScreen()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        AnimatedPageRoute(page: HomeScreen()),
        (route) => false,
      );
    }
    if (enquiryGenerated == "Yes" && selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please select at least one Product"),
          backgroundColor: AppColor.primaryRed,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16.w),
        ),
      );
      return;
    }
  }
}
