import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:positive_metering/utils/app_colors.dart';

class EnquiryCard extends StatelessWidget {
  const EnquiryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 18.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColor.grey.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          /// LEFT RED BAR
          Container(
            width: 4.w,
            height: 110.h,
            decoration: BoxDecoration(
              color: AppColor.primaryRed,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "EnquirySrno:",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColor.grey,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "Action",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              _actionIcon(
                                Icons.remove_red_eye,
                                AppColor.primaryRed,
                              ),
                              SizedBox(width: 8.w),
                              _actionIcon(Icons.edit, AppColor.primaryBlue),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  Text("Date: 25-01-2026", style: TextStyle(fontSize: 14.sp)),

                  SizedBox(height: 6.h),

                  Text(
                    "Customer Name: Admin panel",
                    style: TextStyle(fontSize: 14.sp),
                  ),

                  SizedBox(height: 10.h),

                  /// VIEW DETAILS BUTTON (TEXT + ICON)
                  InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "View Details",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColor.primaryRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Icon(
                          Icons.keyboard_arrow_down_sharp,
                          size: 22.sp,
                          color: AppColor.primaryRed,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(7.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Icon(icon, size: 18.sp, color: AppColor.white),
    );
  }
}
