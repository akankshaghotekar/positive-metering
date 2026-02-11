import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:positive_metering/screens/enquiry/enquiry_screen.dart';
import 'package:positive_metering/utils/app_colors.dart';
import 'package:positive_metering/utils/widgets/add_customer_popup.dart';
import 'package:positive_metering/utils/widgets/common_app_bar.dart';

class AddEnquiryScreen extends StatefulWidget {
  const AddEnquiryScreen({super.key});

  @override
  State<AddEnquiryScreen> createState() => _AddEnquiryScreenState();
}

class _AddEnquiryScreenState extends State<AddEnquiryScreen> {
  DateTime? selectedDate;
  final DateFormat _formatter = DateFormat('dd-MM-yyyy');

  String? selectedCustomer;
  String? selectedSector;

  final List<String> customers = [
    "Add New",
    "Customer A",
    "Customer B",
    "Customer C",
  ];

  final List<String> sectors = ["Pharma", "Water Treatment", "Chemical"];

  final List<String> products = [
    "Dosing Pumps",
    "SC Pumps",
    "ED Pumps",
    "Agitators",
    "Spares",
    "Dosing System",
  ];

  final Set<String> selectedProducts = {};

  final TextEditingController commentCtrl = TextEditingController();
  Future<void> _openAddCustomerPopup() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => const AddCustomerPopup(),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        selectedCustomer = result;

        // if (!customers.contains(result)) {
        //   customers.add(result);
        // }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CommonAppBar(showBack: true, showDrawer: false, showAdd: false),

      /// 🔒 FIXED BUTTONS
      bottomNavigationBar: _actionButtons(),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 12.h),

            Text(
              "Add Enquiry",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 20.h),

            /// 🔽 ONLY FORM SCROLLS
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Date"),
                    _dateField(),

                    SizedBox(height: 22.h),
                    _label("Customer Name"),
                    _dropdownField(
                      hint: "Select Customer",
                      value: selectedCustomer,
                      items: customers,
                      onChanged: (val) {
                        if (val == "Add New") {
                          _openAddCustomerPopup();
                        } else {
                          setState(() => selectedCustomer = val);
                        }
                      },
                    ),

                    SizedBox(height: 22.h),

                    _label("Sector"),
                    _dropdownField(
                      hint: "Select the Sector",
                      value: selectedSector,
                      items: sectors,
                      onChanged: (val) {
                        setState(() => selectedSector = val);
                      },
                    ),

                    SizedBox(height: 22.h),
                    _label("Product"),
                    _productGrid(),

                    SizedBox(height: 22.h),
                    _label("Comments"),
                    _textField(),

                    SizedBox(height: 30.h),
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
      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
    );
  }

  Widget _dateField() {
    return InkWell(
      onTap: _pickDate,
      child: Container(
        height: 50.h,
        margin: EdgeInsets.only(top: 8.h),
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

  Widget _dropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 50.h,
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColor.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : null,
          hint: Text(
            value ?? hint,
            style: TextStyle(fontSize: 14.sp, color: AppColor.grey),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e, style: TextStyle(fontSize: 14.sp)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _textField() {
    return Container(
      height: 90.h,
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColor.grey),
      ),
      child: TextField(
        controller: commentCtrl,
        maxLines: null,
        decoration: const InputDecoration(
          hintText: "Description",
          border: InputBorder.none,
        ),
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
        mainAxisSpacing: 14.h,
        crossAxisSpacing: 14.w,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (_, index) {
        final item = products[index];
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
                  MaterialPageRoute(builder: (_) => EnquiryScreen()),
                  (route) => false,
                );
              },
              child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColor.primaryRed,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColor.primaryBlue,
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Text(
                "Reset",
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
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

  void _openSelection({
    required String title,
    required List<String> list,
    required Function(String) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16.h),
              ...list.map(
                (item) => ListTile(
                  title: Text(item),
                  onTap: () {
                    onSelect(item);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
