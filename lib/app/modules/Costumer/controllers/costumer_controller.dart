import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CostumerController extends GetxController {
  var makananList = <Map<String, dynamic>>[].obs;
  var minumanList = <Map<String, dynamic>>[].obs;
  var lainnyaList = <Map<String, dynamic>>[].obs;

  final CollectionReference ref = FirebaseFirestore.instance.collection('Menu');

  var isCheckedList = <RxBool>[].obs;
  var clickCountList = <RxInt>[].obs;
  var totalPriceList = <double>[].obs;
   var selectedPrice = 0.0.obs;
  var isReseller = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    try {
      var makananSnapshot =
          await ref.where('kategori', isEqualTo: 'Makanan').get();
      var minumanSnapshot =
          await ref.where('kategori', isEqualTo: 'Minuman').get();
      var lainnyaSnapshot =
          await ref.where('kategori', isEqualTo: 'Lainnya').get();

      makananList.value = makananSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['docId'] = doc.id;
        return data;
      }).toList();
      minumanList.value = minumanSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['docId'] = doc.id;
        return data;
      }).toList();
      lainnyaList.value = lainnyaSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['docId'] = doc.id;
        return data;
      }).toList();
      // Inisialisasi isCheckedList, clickCountList, dan totalPriceList
    int totalItems = makananList.length + minumanList.length + lainnyaList.length;
    isCheckedList.value = List<RxBool>.generate(totalItems, (_) => false.obs);
    clickCountList.value = List<RxInt>.generate(totalItems, (_) => 0.obs);
    totalPriceList.value = List<double>.filled(totalItems, 0.0); // Inisialisasi dengan nilai awal 0.0
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

    Widget buildTab(List<Map<String, dynamic>> dataList, int startIndex) {
    return Obx(() {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 30.0,
          mainAxisSpacing: 30.0, 
        ),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final data = dataList[index];
          final actualIndex = startIndex + index;
          var isChecked = isCheckedList[actualIndex];
          var clickCount = clickCountList[actualIndex];

          return GestureDetector(
            onTap: () {
              isChecked.value = true;
              clickCount.value += 1;
              updateTotalPrice();
            },
            onLongPress: () {
              if (clickCount.value > 0) {
                clickCount.value -= 1;
                if (clickCount.value == 0) {
                  isChecked.value = false;
                  updateTotalPrice();
                }
                updateTotalPrice();
              }
            },
            child: Container(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Center(
                    
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image(
                            image: data['imageURL'] != null
                                ? NetworkImage(data['imageURL'])
                                    as ImageProvider<Object>
                                : const AssetImage('assets/images/Logo_Funtime.jpg')
                                    as ImageProvider<Object>,
                            fit: BoxFit.cover,
                            width: 125.0.h,
                            height: 125.0.h,
                          ),
                        ),
                        SizedBox(height: 10.0.h),
                        Padding(
                          padding: const EdgeInsets.only(right:8.0,left:8.0),
                          child: Obx(() {
                            final clickCountValue = clickCount.value;
                            final displayText = data['nama'].length > 50
                                ? '${data['nama'].substring(0, 50)}...' 
                                : data['nama'];
                            final displayCount = clickCountValue > 99 ? '99+' : clickCountValue.toString();
                            return Text.rich(
                              TextSpan(
                                text: displayText,
                                style: TextStyle(fontSize: 12.0.sp),
                                children: clickCount.value > 0
                                    ? [
                                        TextSpan(
                                          text: ' ($displayCount)',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]
                                    : [],
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            );
                          }),
                        ),
                        SizedBox(height: 5.0.h),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 20,
                    child: Obx(() => isChecked.value
                        ? const Icon(
                            Icons.check_circle_outline,
                            color: Colors.black,
                          )
                        : Container()),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
  double calculateTotalPrice(double pricePerItem, int clickCount) {
    return pricePerItem * clickCount;
  }

  void updateTotalPrice() {
  double totalPrice = 0.0;
  for (int i = 0; i < isCheckedList.length; i++) {
    if (isCheckedList[i].value) {
      Map<String, dynamic> data;
      int index;
      if (i < makananList.length) {
        data = makananList[i];
        index = i;
      } else if (i < makananList.length + minumanList.length) {
        data = minumanList[i - makananList.length]; // Perbaikan indeks minuman
        index = i; // Gunakan indeks asli karena minuman dimulai dari indeks makananList.length
      } else {
        data = lainnyaList[i - makananList.length - minumanList.length];
        index = i;
      }
      var clickCount = clickCountList[index].value;
      double pricePerItem = isReseller.value ? data['Harga Reseller'] : data['Harga Biasa'];
      totalPrice += (clickCount * pricePerItem);
    }
  }
  selectedPrice.value = totalPrice;
}
}
