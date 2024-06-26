import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CostumerController extends GetxController {
  var makananList = <Map<String, dynamic>>[].obs;
  var minumanList = <Map<String, dynamic>>[].obs;
  var lainnyaList = <Map<String, dynamic>>[].obs;

  final CollectionReference ref = FirebaseFirestore.instance.collection('Menu');

  var isCheckedList = <RxBool>[].obs;
  var clickCountList = <RxInt>[].obs;
  var totalPriceList = <int>[].obs;
  var selectedPrice = 0.obs;
  var isReseller = false.obs;

  final AudioPlayer moeny = AudioPlayer();

  void moneySound() async {
    await moeny.setSource(AssetSource('sounds/ka_ching.mp3'));
    await moeny.resume();
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
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
      int totalItems =
          makananList.length + minumanList.length + lainnyaList.length;
      isCheckedList.value = List<RxBool>.generate(totalItems, (_) => false.obs);
      clickCountList.value = List<RxInt>.generate(totalItems, (_) => 0.obs);
      totalPriceList.value = List<int>.filled(totalItems, 0);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        Get.snackbar('Maaf',
            'Anda Mencurigakan!!\nBeritahu Pemilik Toko apabila ini kesalahan',
            backgroundColor: Colors.red);
      } else {
        Get.snackbar('Error', 'Error Tidak di ketahui: $e',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', 'Error Tidak di ketahui: $e',
          backgroundColor: Colors.red);
    }
  }

  Widget buildTab(List<Map<String, dynamic>> dataList, int startIndex) {
    return Obx(() {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 30.0.w,
          mainAxisSpacing: 30.0.h,
        ),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final data = dataList[index];
          final actualIndex = startIndex + index;
          var isChecked = isCheckedList[actualIndex];
          var clickCount = clickCountList[actualIndex];

          return GestureDetector(
            onTap: () {
              if (data['Banyak'] > 0 && clickCount.value < data['Banyak']) {
                isChecked.value = true;
                clickCount.value += 1;
                updateTotalPrice();
              } else {
                Get.snackbar(
                    "Stock Habis", "Maaf untuk ${data['nama']} tidak tersedia.",
                    backgroundColor: Colors.red);
              }
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
                                : const AssetImage(
                                        'assets/images/Logo_Funtime.jpg')
                                    as ImageProvider<Object>,
                            fit: BoxFit.cover,
                            width: 125.0.h,
                            height: 125.0.h,
                          ),
                        ),
                        SizedBox(height: 10.0.h),
                        Padding(
                          padding: EdgeInsets.only(right: 8.0.w, left: 8.0.w),
                          child: Obx(() {
                            final clickCountValue = clickCount.value;
                            final displayText = data['nama'].length > 50
                                ? '${data['nama'].substring(0, 50)}...'
                                : data['nama'];
                            final displayCount = clickCountValue > 99
                                ? '99+'
                                : clickCountValue.toString();
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

  int calculateTotalPrice(int pricePerItem, int clickCount) {
    return pricePerItem * clickCount;
  }

  void updateTotalPrice() {
    int totalPrice = 0;
    for (int i = 0; i < isCheckedList.length; i++) {
      if (isCheckedList[i].value) {
        Map<String, dynamic> data;
        if (i < makananList.length) {
          data = makananList[i];
        } else if (i < makananList.length + minumanList.length) {
          data = minumanList[i - makananList.length];
        } else {
          data = lainnyaList[i - makananList.length - minumanList.length];
        }
        var clickCount = clickCountList[i].value;
        int pricePerItem =
            isReseller.value ? data['Harga Reseller'] : data['Harga Biasa'];
        totalPrice += (clickCount * pricePerItem);
      }
    }
    selectedPrice.value = totalPrice;
  }

  void toggleReseller() {
    isReseller.value = !isReseller.value;
    updateTotalPrice();
  }

  Future<void> savePurchase() async {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final DateFormat timeFormat = DateFormat('HH:mm:ss.SSS');
    final now = DateTime.now();
    final dateStr = dateFormat.format(now);
    final timeStr = timeFormat.format(now);

    WriteBatch batch = FirebaseFirestore.instance.batch();

    List<Map<String, dynamic>> purchasedItems = [];

    for (int i = 0; i < clickCountList.length; i++) {
      if (isCheckedList[i].value) {
        final data = i < makananList.length
            ? makananList[i]
            : i < makananList.length + minumanList.length
                ? minumanList[i - makananList.length]
                : lainnyaList[i - makananList.length - minumanList.length];
        final docId = data['docId'] as String;
        final count = clickCountList[i].value;

        int hargaJual;
        if (isReseller.value) {
          hargaJual = data['Harga Reseller'];
        } else {
          hargaJual = data['Harga Biasa'];
        }

        purchasedItems.add({
          'Harga Awal': data['Harga Awal'],
          'Nama Barang': data['nama'],
          'Banyak Barang': count,
          'Harga Jual': hargaJual,
          'Jenis Barang': data['kategori'],
          'Waktu Pemesanan': timeStr
        });

        DocumentReference docRef = ref.doc(docId);
        batch.update(docRef, {
          'Banyak': FieldValue.increment(-count),
        });
      }
    }
    String typeTransaksi = isReseller.value ? 'Reseller' : 'Costumer';
    final purchaseRef = FirebaseFirestore.instance
        .collection('Purchases')
        .doc('$dateStr-$typeTransaksi');
    final purchaseSnapshot = await purchaseRef.get();

    if (purchaseSnapshot.exists) {
      batch.update(
        purchaseRef,
        {
          'items': FieldValue.arrayUnion(purchasedItems),
          'Total Harga': FieldValue.increment(selectedPrice.value),
        },
      );
      moneySound();
      await saveTotalTransaction();
      fetchData();
      selectedPrice.value = 0;
    } else {
      batch.set(
        purchaseRef,
        {
          'Date': dateStr,
          'Type Transaksi': typeTransaksi,
          'items': purchasedItems
              .map((item) => {
                    'Harga Awal': item['Harga Awal'],
                    'Nama Barang': item['Nama Barang'],
                    'Banyak Barang': item['Banyak Barang'],
                    'Harga Jual': item['Harga Jual'],
                    'Jenis Barang': item['Jenis Barang'],
                    'Waktu Pemesanan': timeStr
                  })
              .toList(),
          'Total Harga': selectedPrice.value,
        },
      );
      moneySound();
      await saveTotalTransaction();
      fetchData();
      selectedPrice.value = 0;
    }

    await batch.commit();
  }

  Future<void> saveTotalTransaction() async {
    final existingTotalTransaction = await getTotalTransaction();

    final newTotalTransaction = existingTotalTransaction + selectedPrice.value;

    final totalTransactionsRef = FirebaseFirestore.instance
        .collection('TotalTransactions')
        .doc('Transaksi');
    await totalTransactionsRef.set({
      'Date': DateTime.now(),
      'Total Transaksi': newTotalTransaction,
    });
  }

  Future<int> getTotalTransaction() async {
    final totalTransactionsRef = FirebaseFirestore.instance
        .collection('TotalTransactions')
        .doc('Transaksi');

    final snapshot = await totalTransactionsRef.get();
    int totalTransaction = 0;

    if (snapshot.exists) {
      totalTransaction = snapshot['Total Transaksi'];
    }

    return totalTransaction;
  }

  Future<void> showConfirmationDialog(
      BuildContext context, Function onConfirm) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content:
              const Text('Apakah Anda yakin ingin menyimpan pembelian ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Iya'),
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
