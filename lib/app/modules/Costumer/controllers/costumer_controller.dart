import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CostumerController extends GetxController {
  var makananList = <Map<String, dynamic>>[].obs;
  var minumanList = <Map<String, dynamic>>[].obs;
  var lainnyaList = <Map<String, dynamic>>[].obs;

  final CollectionReference ref = FirebaseFirestore.instance.collection('Menu');

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
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Widget buildTab(List<Map<String, dynamic>> dataList) {
    return Obx(() {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final data = dataList[index];
          return GestureDetector(
            onTap: () {},
            onLongPress: () {},
            child: Card(
              color: Colors.white,
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: data['imageURL'] != null
                          ? NetworkImage(data['imageURL'])
                              as ImageProvider<Object>
                          : const AssetImage('assets/images/Logo_Funtime.jpg')
                              as ImageProvider<Object>,
                      fit: BoxFit.cover,
                      width: 100.0.h,
                      height: 100.0.h,
                    ),
                    SizedBox(height: 10.0.h),
                    Text(
                      data['nama'],
                      style: TextStyle(fontSize: 12.0.sp),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 5.0.h),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
