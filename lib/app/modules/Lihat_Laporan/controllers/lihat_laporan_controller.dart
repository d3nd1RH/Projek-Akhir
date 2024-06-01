import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LihatLaporanController extends GetxController {
  final Rx<DateTime?> selectedMonth = Rx<DateTime?>(null);
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxInt pilihyear = 0.obs;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
    );

    if (pickedDate != null) {
      selectedDate.value = pickedDate;
    }
  }

  Future<void> selectMonth(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (pickedDate != null) {
      selectedMonth.value = DateTime(pickedDate.year, pickedDate.month, 1);
    }
  }

  Future<int?> selectyear(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (pickedDate != null) {
      return pickedDate.year;
    } else {
      return null;
    }
  }

  Widget harianLaporan() {
    return Column(
      children: [
        SizedBox(
          height: 30.h,
        ),
        Row(
          children: [
            SizedBox(
              width: 20.w,
            ),
            const Text('Tanggal :'),
            SizedBox(
              width: 10.w,
            ),
            GestureDetector(
              onTap: () async {
                await selectDate(Get.context!);
              },
              child: Container(
                width: 160.w,
                height: 40.h,
                color: const Color.fromRGBO(217, 217, 217, 1),
                child: Row(
                  children: [
                    SizedBox(
                      width: 8.h,
                    ),
                    Obx(() => Text(
                          selectedDate.value != null
                              ? '${selectedDate.value!.year}/${selectedDate.value!.month.toString().padLeft(2, '0')}/${selectedDate.value!.day.toString().padLeft(2, '0')}'
                              : 'Pilih Tanggal',
                        )),
                    const Spacer(),
                    const Icon(Icons.calendar_month_outlined)
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          children: [
            SizedBox(
              width: 20.w,
            ),
            Container(
                width: 100.w,
                height: 40.h,
                color: const Color.fromRGBO(217, 217, 217, 1),
                child: const Center(child: Text("Print"))),
          ],
        )
      ],
    );
  }

  Widget bulananLaporan() {
    return Column(
      children: [
        SizedBox(
          height: 30.h,
        ),
        Row(
          children: [
            SizedBox(
              width: 20.w,
            ),
            const Text('Tanggal :'),
            SizedBox(
              width: 10.w,
            ),
            GestureDetector(
              onTap: () async {
                await selectMonth(Get.context!);
              },
              child: Container(
                width: 160.w,
                height: 40.h,
                color: const Color.fromRGBO(217, 217, 217, 1),
                child: Row(
                  children: [
                    SizedBox(
                      width: 8.h,
                    ),
                    Obx(() => Text(
                          selectedMonth.value != null
                              ? '${selectedMonth.value!.year}/${selectedMonth.value!.month.toString().padLeft(2, '0')}'
                              : 'Pilih Bulan',
                        )),
                    const Spacer(),
                    const Icon(Icons.calendar_month_outlined)
                  ],
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          children: [
            SizedBox(
              width: 20.w,
            ),
            Container(
                width: 100.w,
                height: 40.h,
                color: const Color.fromRGBO(217, 217, 217, 1),
                child: const Center(child: Text("Print"))),
          ],
        )
      ],
    );
  }

  Widget tahunLaporan() {
    return Column(
      children: [
        SizedBox(
          height: 30.h,
        ),
        Row(
          children: [
            SizedBox(
              width: 20.w,
            ),
            const Text('Tanggal :'),
            SizedBox(
              width: 10.w,
            ),
            GestureDetector(
              onTap: () async {
                int? year = await selectyear(Get.context!);
                if (year != null) {
                  pilihyear.value = year;
                }
              },
              child: Container(
                width: 160.w,
                height: 40.h,
                color: const Color.fromRGBO(217, 217, 217, 1),
                child: Row(
                  children: [
                    SizedBox(
                      width: 8.h,
                    ),
                    Obx(() => Text(
                          pilihyear.value != 0
                              ? pilihyear.value.toString()
                              : 'Pilih Tahun',
                        )),
                    const Spacer(),
                    const Icon(Icons.calendar_month_outlined)
                  ],
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          children: [
            SizedBox(
              width: 20.w,
            ),
            Container(
                width: 100.w,
                height: 40.h,
                color: const Color.fromRGBO(217, 217, 217, 1),
                child: const Center(child: Text("Print"))),
          ],
        )
      ],
    );
  }
}
