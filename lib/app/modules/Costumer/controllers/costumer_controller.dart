import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class CostumerController extends GetxController {
  var makananList = <Map<String, dynamic>>[].obs;
  var minumanList = <Map<String, dynamic>>[].obs;
  var lainnyaList = <Map<String, dynamic>>[].obs;
  var selectedDevice = Rxn<BluetoothDevice>();

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
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
    List<Map<String, dynamic>> items = [];

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

        items.add({
          'nama': data['nama'],
          'banyak': clickCountList[i].value,
          'harga':
              isReseller.value ? data['Harga Reseller'] : data['Harga Biasa'],
        });
      }
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Apakah Anda yakin ingin menyimpan pembelian ini?'),
                SizedBox(height: 20.h),
                const Text('Detail Pembelian:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...items.map((item) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item['nama']),
                        Text(item['banyak'].toString()),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
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
                Navigator.of(context).pop();
                onConfirm();
                int totalPrice = items.fold(0, (acc, item) {
                  return acc +
                      ((item['banyak'] as int) * (item['harga'] as int));
                });
                showPrintConfirmationDialog(items, totalPrice);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showPrintConfirmationDialog(
      List<Map<String, dynamic>> items, int totalPrice) async {
    List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
    return Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Cetak Resi'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'FunTime Juice',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                'Alamat Toko',
                style: TextStyle(fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                '----------------------------------------------------',
                style: TextStyle(fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
              ...items.map((item) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(item['nama']),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['banyak'].toString(),
                            style: TextStyle(fontSize: 16.sp),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            item['harga'].toString(),
                            style: TextStyle(fontSize: 16.sp),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            (item['harga'] * item['banyak']).toString(),
                            style: TextStyle(fontSize: 16.sp),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(height: 10.h),
              Text(
                '----------------------------------------------------',
                style: TextStyle(fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(totalPrice.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              const Text(
                'Terima kasih atas pembelian Anda!',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              const Text('Pilih Perangkat Bluetooth:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Obx(() {
                return DropdownButton<BluetoothDevice>(
                  value: selectedDevice.value,
                  hint: const Text('Pilih Perangkat'),
                  onChanged: (BluetoothDevice? device) {
                    selectedDevice.value = device;
                  },
                  items: devices.map((device) {
                    return DropdownMenuItem<BluetoothDevice>(
                      value: device,
                      child: Text(device.name ?? "Perangkat Tidak Dikenal"),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Tidak Cetak'),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: const Text('Cetak'),
            onPressed: () async {
              if (selectedDevice.value != null) {
                printReceipt(
                  items,
                  totalPrice,
                  selectedDevice.value!,
                );
                Get.back();
                selectedDevice.value = null;
              } else {
                Get.snackbar(
                    'Error', 'Pilih perangkat Bluetooth terlebih dahulu',
                    backgroundColor: Colors.red);
              }
            },
          ),
        ],
      ),
    );
  }

  void printReceipt(List<Map<String, dynamic>> items, int totalPrice,
      BluetoothDevice device) async {
    try {
      await bluetooth.connect(device);
      bool? isConnected = await bluetooth.isConnected;

      if (isConnected == true) {
        bluetooth.printNewLine();
        bluetooth.printCustom("FunTime Juice", 2, 1);
        bluetooth.printCustom("Alamat Toko", 0, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom("--------------------------------", 0, 1);

        for (var item in items) {
          bluetooth.printCustom(item['nama'], 0, 0);
          bluetooth.print3Column(
              "  ${item['banyak']}  ",
              item['harga'].toString(),
              (item['harga'] * item['banyak']).toString(),
              1);
        }

        bluetooth.printCustom("--------------------------------", 0, 1);
        bluetooth.printLeftRight("Total", totalPrice.toString(), 1);
        bluetooth.printNewLine();
        bluetooth.printCustom("Terima kasih atas pembelian Anda", 1, 1);
        bluetooth.printNewLine();
        bluetooth.paperCut();
        await bluetooth.disconnect();
      } else {
        Get.snackbar('Error',
            'Tidak dapat terhubung ke printer Bluetooth. Pastikan perangkat yang dipilih adalah printer.',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      if (e.toString().contains('connect_error')) {
        Get.snackbar('Error',
            'Kesalahan koneksi: Gagal menyambung ke perangkat. Pastikan perangkat dalam jangkauan dan sudah dipasangkan.',
            backgroundColor: Colors.red);
      } else if (e.toString().contains('socket might closed or timeout')) {
        Get.snackbar('Error',
            'Kesalahan timeout: Tidak ada respons dari perangkat. Periksa kembali perangkat dan coba lagi.',
            backgroundColor: Colors.red);
      } else {
        Get.snackbar('Error', 'Terjadi kesalahan: $e',
            backgroundColor: Colors.red);
      }
    }
    try {
      await bluetooth.disconnect();
    } catch (disconnectError) {
      Get.snackbar('Error', 'Gagal memutuskan koneksi: $disconnectError',
          backgroundColor: Colors.red);
    }
  }
}
