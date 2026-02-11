import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:positive_metering/screens/plan/tour_plan/tour_plan_screen.dart';
import 'package:positive_metering/screens/plan/tour_plan_yearly/tour_plan_yearly_screen.dart';
import 'package:positive_metering/utils/animation_helper/animated_page_route.dart';
import 'package:positive_metering/utils/app_colors.dart';
import 'package:positive_metering/utils/widgets/add_customer_popup.dart';
import 'package:positive_metering/utils/widgets/common_app_bar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddTourPlanYearlyScreen extends StatefulWidget {
  const AddTourPlanYearlyScreen({super.key});

  @override
  State<AddTourPlanYearlyScreen> createState() =>
      _AddTourPlanYearlyScreenState();
}

class _AddTourPlanYearlyScreenState extends State<AddTourPlanYearlyScreen> {
  DateTime? selectedWeekDate;
  String? tourType;
  String? region;

  final List<String> customers = [
    "Add New",
    "Customer A",
    "Customer B",
    "Customer C",
    "Customer D",
  ];

  final Set<String> selectedCustomers = {};

  final DateFormat _formatter = DateFormat('dd MMM yyyy');

  // --------------------------------------------------
  String get weekText {
    if (selectedWeekDate == null) return "Select Week";

    final monday = selectedWeekDate!.subtract(
      Duration(days: selectedWeekDate!.weekday - 1),
    );
    final sunday = monday.add(const Duration(days: 6));

    return "${_formatter.format(monday)} - ${_formatter.format(sunday)}";
  }

  DateTime _nearestMonday(DateTime date) {
    return date.subtract(Duration(days: date.weekday - DateTime.monday));
  }

  // --------------------------------------------------
  void _pickWeek() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime? tempSelectedMonday = selectedWeekDate;

        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Select Week",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Divider(color: AppColor.grey, height: 1.h),
                    SizedBox(height: 12.h),

                    SizedBox(
                      height: 420.h, // ⬅️ Bigger calendar
                      child: SfDateRangePicker(
                        selectionMode: DateRangePickerSelectionMode.single,
                        navigationDirection:
                            DateRangePickerNavigationDirection.horizontal,
                        showNavigationArrow: true,
                        showTodayButton: false,

                        // 🔒 Only Mondays selectable
                        selectableDayPredicate: (date) {
                          return date.weekday == DateTime.monday;
                        },

                        onSelectionChanged: (args) {
                          if (args.value is DateTime) {
                            setDialogState(() {
                              tempSelectedMonday = args.value;
                            });
                          }
                        },

                        // 🗓 Real calendar look
                        headerStyle: DateRangePickerHeaderStyle(
                          textAlign: TextAlign.center,
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        viewSpacing: 10,

                        monthViewSettings: DateRangePickerMonthViewSettings(
                          dayFormat: 'EEE',
                          viewHeaderHeight: 36.h,

                          // 🎨 Highlight week
                          specialDates: tempSelectedMonday == null
                              ? []
                              : List.generate(
                                  7,
                                  (index) => tempSelectedMonday!.add(
                                    Duration(days: index),
                                  ),
                                ),
                        ),

                        selectionColor: AppColor.primaryRed,
                        todayHighlightColor: AppColor.primaryRed,

                        monthCellStyle: DateRangePickerMonthCellStyle(
                          textStyle: TextStyle(fontSize: 14.sp),

                          // Disabled days (non-Monday)
                          disabledDatesTextStyle: TextStyle(
                            color: const Color(0xFF8B8B8B),
                          ),

                          // Week highlight
                          specialDatesDecoration: BoxDecoration(
                            color: AppColor.primaryRed.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          specialDatesTextStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),

                          // Selected Monday
                          selectionTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedWeekDate = tempSelectedMonday;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Done",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // --------------------------------------------------
  void _openCustomerMultiSelect() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Select Customers",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  ...customers.map((customer) {
                    if (customer == "Add New") {
                      return ListTile(
                        leading: Icon(
                          Icons.add_circle,
                          color: AppColor.primaryRed,
                        ),
                        title: const Text("Add New"),
                        onTap: () async {
                          final result = await showModalBottomSheet<String>(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16.r),
                              ),
                            ),
                            builder: (_) => const AddCustomerPopup(),
                          );

                          if (result != null && result.isNotEmpty) {
                            setState(() {
                              selectedCustomers.add(result);
                            });
                            setModalState(() {});
                          }
                        },
                      );
                    }

                    return CheckboxListTile(
                      value: selectedCustomers.contains(customer),
                      title: Text(customer),
                      onChanged: (checked) {
                        setModalState(() {
                          checked!
                              ? selectedCustomers.add(customer)
                              : selectedCustomers.remove(customer);
                        });

                        setState(() {});
                      },
                    );
                  }).toList(),

                  SizedBox(height: 10.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryRed,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Done",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: const CommonAppBar(
        showBack: true,
        showDrawer: false,
        showAdd: false,
      ),

      bottomNavigationBar: _actionButtons(),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Text(
              "Add Tour Plan (Yearly)",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20.h),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Week"),
                    _weekField(),

                    SizedBox(height: 18.h),
                    _label("Tour Type"),
                    _dropdown(
                      "Select Tour Type",
                      tourType,
                      ["Tour", "Lean"],
                      (v) => setState(() => tourType = v),
                    ),

                    SizedBox(height: 18.h),
                    _label("Region"),
                    _dropdown("Select Region", region, [
                      "Region 1",
                      "Region 2",
                      "Region 3",
                      "Region 4",
                      "Region 5",
                      "Region 6",
                      "Region 7",
                    ], (v) => setState(() => region = v)),

                    SizedBox(height: 18.h),
                    _label("Customer"),
                    _multiSelectField(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
    );
  }

  Widget _weekField() {
    return InkWell(
      onTap: _pickWeek,
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
            Text(weekText, style: TextStyle(fontSize: 14.sp)),
            const Icon(Icons.calendar_month),
          ],
        ),
      ),
    );
  }

  Widget _dropdown(
    String hint,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
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

  Widget _multiSelectField() {
    return InkWell(
      onTap: _openCustomerMultiSelect,
      child: Container(
        height: 46.h,
        margin: EdgeInsets.only(top: 6.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColor.grey),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          selectedCustomers.isEmpty
              ? "Select Customers"
              : selectedCustomers.join(", "),
          style: TextStyle(fontSize: 14.sp),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  // --------------------------------------------------
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
                  AnimatedPageRoute(page: const TourPlanYearlyScreen()),
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
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedWeekDate = null;
                  tourType = null;
                  region = null;
                  selectedCustomers.clear();
                });
              },
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
          ),
        ],
      ),
    );
  }
}
