import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;

import '../../../utill/custom_text_field.dart';
import '../../../utill/formatindo.dart';

class StockBarangController extends GetxController {
  var sortColumnIndex = 0.obs;
  var sortAscending = true.obs;
  bool isUpdating = false;
  var selectedCategory = 'Makanan'.obs;
  var selectedImagePath = ''.obs;
  CollectionReference ref = FirebaseFirestore.instance.collection('Menu');

  var makananList = <Map<String, dynamic>>[].obs;
  var minumanList = <Map<String, dynamic>>[].obs;
  var lainnyaList = <Map<String, dynamic>>[].obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController hargamasukController = TextEditingController();
  final TextEditingController priceAController = TextEditingController();
  final TextEditingController priceBController = TextEditingController();
  final TextEditingController editstockController = TextEditingController();
  void setSelectedCategory(String value) {
    selectedCategory.value = value;
  }

  Future<File> convertImage(File file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image != null) {
      final resizedImage = img.copyResize(image, width: 600);

      final convertedBytes = img.encodeJpg(resizedImage, quality: 85);
      final convertedFile =
          File('${file.parent.path}/converted_${file.path.split('/').last}')
            ..writeAsBytesSync(convertedBytes);

      return convertedFile;
    } else {
      throw Exception('Unable to decode image');
    }
  }

  void sortData(
      String title, bool ascending, List<Map<String, dynamic>> dataList) {
    dataList.sort((a, b) {
      if (title == 'Stock') {
        if (a['Banyak'] == b['Banyak']) {
          return 0;
        } else if (sortAscending.value) {
          return a['Banyak'].compareTo(b['Banyak']);
        } else {
          return b['Banyak'].compareTo(a['Banyak']);
        }
      } else if (title == "Makanan" ||
          title == "Minuman" ||
          title == "Lainnya") {
        if (a["nama"] == b["nama"]) {
          return 0;
        } else if (sortAscending.value) {
          return a["nama"].compareTo(b["nama"]);
        } else {
          return b["nama"].compareTo(a["nama"]);
        }
      } else {
        if (a[title] == b[title]) {
          return 0;
        } else if (sortAscending.value) {
          return a[title].compareTo(b[title]);
        } else {
          return b[title].compareTo(a[title]);
        }
      }
    });
    update();
  }

  void toggleSort() {
    sortAscending.value = !sortAscending.value;
  }

  Widget buildDataTable(
      String title, List<Map<String, dynamic>> dataList, BuildContext context) {
    if (dataList.isEmpty) {
      return Container();
    }
    return Column(
      children: [
        SizedBox(height: 20.h),
        DataTable(
          sortAscending: sortAscending.value,
          sortColumnIndex: sortColumnIndex.value,
          border: TableBorder.all(color: Colors.black),
          columns: <DataColumn>[
            DataColumn(
              label: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onSort: (columnIndex, ascending) {
                sortColumnIndex.value = columnIndex;
                sortData(title, ascending, dataList);
                toggleSort();
              },
            ),
            DataColumn(
              label: const Text(
                'Stock',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onSort: (columnIndex, ascending) {
                sortColumnIndex.value = columnIndex;
                sortData("Stock", ascending, dataList);
                toggleSort();
              },
            ),
          ],
          rows: dataList.map((item) {
            return DataRow(
              color: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Colors.blue;
              }),
              cells: <DataCell>[
                DataCell(
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: item['imageURL'] != null &&
                                item['imageURL'] != ""
                            ? NetworkImage(item['imageURL'])
                            : const AssetImage("assets/images/Logo_Funtime.jpg")
                                as ImageProvider,
                      ),
                      SizedBox(width: 10.w),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['nama'].length <= 15
                                  ? item['nama']
                                  : item['nama'].substring(0, 15) + '...',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Row(
                              children: [
                                Text(
                                  formatRupiah(item['Harga Awal']).length <= 10
                                      ? formatRupiah(item['Harga Awal'])
                                      : '${formatRupiah(item['Harga Awal']).substring(0, 9)}...',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    editDeleteBarang(item['docId']);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                      width: 40,
                                      height: 20,
                                      color: Colors.orange,
                                      child: const Center(
                                          child: Text(
                                        "Edit",
                                        style: TextStyle(color: Colors.black),
                                      )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        updateStock(item['docId'], -1);
                      },
                      child: Container(
                        height: 30.h,
                        width: 30.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        tambahstockbanyak(
                            context, item['docId'], item['Banyak']);
                      },
                      child: Text(item['Banyak'] > 999
                          ? '999+'
                          : item['Banyak'].toString()),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        updateStock(item['docId'], 1);
                      },
                      child: Container(
                        height: 30.h,
                        width: 30.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: Icon(
                          Icons.add,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> tambahstockbanyak(
      BuildContext context, String docId, int currentStock) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tambah/Kurang Stock"),
          content: CustomTextField(
            labelText: 'Masukan Stock Banyak',
            controller: editstockController,
            isUseCustomKeyBoard: true,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                int changeInStock = int.tryParse(editstockController.text) ?? 0;
                await updateStock(docId, -changeInStock);
                Get.back();
              },
              child: const Text('Kurang'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                int changeInStock = int.tryParse(editstockController.text) ?? 0;
                await updateStock(docId, changeInStock);
                Get.back();
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> uploadData() async {
    if (selectedImagePath.value.isNotEmpty) {
      final file = File(selectedImagePath.value);
      final convertedFile = await convertImage(file);
      final storageRef = FirebaseStorage.instance.ref().child(
          'menu_images/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');

      try {
        final uploadTask = storageRef.putFile(convertedFile);
        final snapshot = await uploadTask;

        final downloadURL = await snapshot.ref.getDownloadURL();
        final int quantity = quantityController.text.isNotEmpty
            ? int.parse(quantityController.text)
            : 0;

        if (nameController.text.isNotEmpty) {
          final data = {
            "docid": nameController.text,
            "nama": nameController.text,
            "kategori": selectedCategory.value,
            "Banyak": quantity,
            "Harga Awal": hargamasukController.text.isNotEmpty
                ? int.parse(hargamasukController.text)
                : 0,
            "Harga Reseller": priceAController.text.isNotEmpty
                ? int.parse(priceAController.text)
                : 0,
            "Harga Biasa": priceBController.text.isNotEmpty
                ? int.parse(priceBController.text)
                : 0,
            "imageURL": downloadURL,
          };

          final refDoc = ref.doc(nameController.text);
          await refDoc.set(data);
          fetchData();
          await saveStock(nameController.text, quantity);
        } else {
          Get.snackbar("Error", 'Name is empty', backgroundColor: Colors.red);
        }
      } catch (e) {
        Get.snackbar("Error", 'Error uploading image: $e',
            backgroundColor: Colors.red);
      }
    } else {
      if (nameController.text.isNotEmpty) {
        final int quantity = quantityController.text.isNotEmpty
            ? int.parse(quantityController.text)
            : 0;
        final data = {
          "docid": nameController.text,
          "nama": nameController.text,
          "kategori": selectedCategory.value,
          "Banyak": quantity,
          "Harga Awal": hargamasukController.text.isNotEmpty
              ? int.parse(hargamasukController.text)
              : 0,
          "Harga Reseller": priceAController.text.isNotEmpty
              ? int.parse(priceAController.text)
              : 0,
          "Harga Biasa": priceBController.text.isNotEmpty
              ? int.parse(priceBController.text)
              : 0,
          "imageURL": null,
        };

        final refDoc = ref.doc(nameController.text);
        await refDoc.set(data);
        fetchData();
        await saveStock(nameController.text, quantity);
      } else {
        Get.snackbar("Error", 'Name is empty', backgroundColor: Colors.red);
      }
    }
  }

  Future<void> updatedData(String docId, int previousStock) async {
    if (selectedImagePath.value.isNotEmpty &&
        !selectedImagePath.value.startsWith('http')) {
      final file = File(selectedImagePath.value);
      final convertedFile = await convertImage(file);
      final storageRef = FirebaseStorage.instance.ref().child(
          'menu_images/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');
      try {
        final uploadTask = storageRef.putFile(convertedFile);
        final snapshot = await uploadTask;

        final downloadURL = await snapshot.ref.getDownloadURL();
        if (nameController.text.isNotEmpty) {
          final data = {
            "nama": nameController.text,
            "kategori": selectedCategory.value,
            "Banyak": quantityController.text.isNotEmpty
                ? int.parse(quantityController.text)
                : 0,
            "Harga Awal": hargamasukController.text.isNotEmpty
                ? int.parse(hargamasukController.text)
                : 0,
            "Harga Reseller": priceAController.text.isNotEmpty
                ? int.parse(priceAController.text)
                : 0,
            "Harga Biasa": priceBController.text.isNotEmpty
                ? int.parse(priceBController.text)
                : 0,
            "imageURL": downloadURL,
          };

          await updateDocumentAndStock(docId, data, previousStock);
        }
      } catch (e) {
        Get.snackbar("Error", 'Error uploading image: $e',
            backgroundColor: Colors.red);
      }
    } else {
      if (nameController.text.isNotEmpty) {
        final data = {
          "nama": nameController.text,
          "kategori": selectedCategory.value,
          "Banyak": quantityController.text.isNotEmpty
              ? int.parse(quantityController.text)
              : 0,
          "Harga Awal": hargamasukController.text.isNotEmpty
              ? int.parse(hargamasukController.text)
              : 0,
          "Harga Reseller": priceAController.text.isNotEmpty
              ? int.parse(priceAController.text)
              : 0,
          "Harga Biasa": priceBController.text.isNotEmpty
              ? int.parse(priceBController.text)
              : 0,
          "imageURL": selectedImagePath.value.isNotEmpty
              ? selectedImagePath.value
              : null,
        };

        await updateDocumentAndStock(docId, data, previousStock);
      }
    }
  }

  Future<void> updateDocumentAndStock(
      String docId, Map<String, dynamic> data, int previousStock) async {
    await ref.doc(docId).update(data);

    int newStock = int.parse(data['Banyak'].toString()) - previousStock;

    await saveStock(docId, newStock);

    fetchData();
  }

  Future<String> uploadAndRetrieveImageURL(File imageFile) async {
    final storageRef = FirebaseStorage.instance.ref().child(
        'menu_images/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}');

    final uploadTask = storageRef.putFile(imageFile);
    final snapshot = await uploadTask;

    final downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
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

  void tambahBarang() {
    Get.dialog(
      SingleChildScrollView(
        child: AlertDialog(
          title: const Text('Tambah Barang'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const Text("Gambar Barang"),
                    SizedBox(
                      height: 20.h,
                    ),
                    GestureDetector(
                      onTap: pickImage,
                      child: Obx(() => Container(
                            color: Colors.grey,
                            height: 150.h,
                            width: 150.h,
                            child: selectedImagePath.value.isEmpty
                                ? const Center(
                                    child: Icon(Icons.add, size: 50),
                                  )
                                : Image.file(
                                    File(selectedImagePath.value),
                                    fit: BoxFit.cover,
                                  ),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Obx(() => DropdownButton<String>(
                    value: selectedCategory.value,
                    items: <String>['Makanan', 'Minuman', 'Lainnya']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setSelectedCategory(newValue);
                      }
                    },
                  )),
              SizedBox(
                height: 20.h,
              ),
              CustomTextField(
                labelText: 'Nama Barang',
                controller: nameController,
                isUseCustomKeyBoard: false,
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomTextField(
                labelText: 'Jumlah',
                controller: quantityController,
                isUseCustomKeyBoard: true,
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomTextField(
                labelText: 'Harga Masuk',
                controller: hargamasukController,
                isUseCustomKeyBoard: true,
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomTextField(
                labelText: 'Harga Resaller',
                controller: priceAController,
                isUseCustomKeyBoard: true,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                labelText: 'Harga Regular',
                controller: priceBController,
                isUseCustomKeyBoard: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                selectedCategory = 'Makanan'.obs;
                selectedImagePath = ''.obs;
                nameController.clear();
                quantityController.clear();
                hargamasukController.clear();
                priceAController.clear();
                priceBController.clear();
                Get.back();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                await uploadData();
                selectedCategory = 'Makanan'.obs;
                selectedImagePath = ''.obs;
                nameController.clear();
                quantityController.clear();
                hargamasukController.clear();
                priceAController.clear();
                priceBController.clear();
                Get.back();
              },
              child: const Text('Tambah'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateStock(String docId, int changeInStock) async {
    if (isUpdating) {
      return;
    }
    isUpdating = true;
    final docRef = ref.doc(docId);
    final purchaseRef = FirebaseFirestore.instance.collection('Purchases');

    try {
      final menuDoc = await docRef.get();
      int lastMenuStock = 0;

      if (menuDoc.exists) {
        final Map<String, dynamic>? menuData =
            menuDoc.data() as Map<String, dynamic>?;

        if (menuData != null && menuData['Banyak'] != null) {
          lastMenuStock = menuData['Banyak'];
        }
      }

      int newMenuStock = lastMenuStock + changeInStock;

      if (newMenuStock < 0) {
        Get.snackbar("Maaf", 'Persediaan tidak dapat menjadi negatif.',
            backgroundColor: Colors.red);
        return;
      }

      final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final purchaseSnapshot =
          await purchaseRef.doc('$formattedDate-Stock').get();
      List<Map<String, dynamic>> updatedItems = [];
      bool itemFound = false;

      if (purchaseSnapshot.exists) {
        final menuData = menuDoc.data() as Map<String, dynamic>?;
        List<dynamic> items = purchaseSnapshot.data()?['items'] ?? [];
        for (var item in items) {
          if (item['Nama Barang'] == menuData?['nama'] &&
            item['Harga Modal'] == menuData?['Harga Awal']) {
            itemFound = true;
            item['Banyak Barang'] += changeInStock;
            item['Waktu Stock'] = Timestamp.now();
          }
          updatedItems.add(item);
        }
      }

      if (!itemFound) {
        final menuData = menuDoc.data() as Map<String, dynamic>?;
        updatedItems.add({
          'Nama Barang': menuData?['nama'],
          'Jenis Barang': menuData?['kategori'] ?? '',
          'Harga Modal': menuData?['Harga Awal'] ?? 0,
          'Banyak Barang': changeInStock,
          'Waktu Stock': Timestamp.now(),
        });
      }

      await purchaseRef.doc('$formattedDate-Stock').set({
        'Date': formattedDate,
        'Type Transaksi': 'Stok',
        'Last Update': Timestamp.now(),
        'items': updatedItems,
      });
      await docRef.update({'Banyak': newMenuStock});
      await saveTotalTransaction(docId, changeInStock);
    } finally {
      isUpdating = false;
    }
  }

  Future<void> saveStock(String docId, int changeInStock) async {
    if (isUpdating) {
      return;
    }
    final docRef = ref.doc(docId);
    final menuDoc = await docRef.get();
    final purchaseRef = FirebaseFirestore.instance.collection('Purchases');
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final purchaseSnapshot =
          await purchaseRef.doc('$formattedDate-Stock').get();
      List<Map<String, dynamic>> updatedItems = [];
      bool itemFound = false;

      if (purchaseSnapshot.exists) {
        final menuData = menuDoc.data() as Map<String, dynamic>?;
        List<dynamic> items = purchaseSnapshot.data()?['items'] ?? [];
        for (var item in items) {
          if (item['Nama Barang'] == menuData?['nama'] &&
              item['Harga Modal'] == menuData?['Harga Awal']) {
            itemFound = true;
            item['Banyak Barang'] += changeInStock;
            item['Waktu Stock'] = Timestamp.now();
          }
          updatedItems.add(item);
        }
      }

      if (!itemFound) {
        final menuData = menuDoc.data() as Map<String, dynamic>?;
        updatedItems.add({
          'Nama Barang': menuData?['nama'],
          'Jenis Barang': menuData?['kategori'] ?? '',
          'Harga Modal': menuData?['Harga Awal'] ?? 0,
          'Banyak Barang': changeInStock,
          'Waktu Stock': Timestamp.now(),
        });
      }
      await purchaseRef.doc('$formattedDate-Stock').set({
        'Date': formattedDate,
        'Type Transaksi': 'Stok',
        'Last Update': Timestamp.now(),
        'items': updatedItems,
      });
      await saveTotalTransaction(docId, changeInStock);
      fetchData();
    } finally {
      isUpdating = false;
    }
  }

  Future<void> saveTotalTransaction(String docId, int changeInStock) async {
    final docRef = FirebaseFirestore.instance.collection('Menu').doc(docId);
    final menuDoc = await docRef.get();
    final int hargaAwal = menuDoc.data()?['Harga Awal'] ?? 0;

    final int totalTransaction = hargaAwal * changeInStock;

    final existingTotalTransaction = await getTotalTransaction();

    final newTotalTransaction = existingTotalTransaction - totalTransaction;

    final totalTransactionsRef = FirebaseFirestore.instance
        .collection('TotalTransactions')
        .doc('Transaksi');
    await totalTransactionsRef.set({
      'Date': DateTime.now(),
      'Total Transaksi': newTotalTransaction,
    });
    fetchData();
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

  Future<void> editDeleteBarang(String docId) async {
    DocumentSnapshot docSnapshot = await ref.doc(docId).get();
    var item = docSnapshot.data() as Map<String, dynamic>;

    nameController.text = item['nama'];
    quantityController.text = item['Banyak'].toString();
    hargamasukController.text = item['Harga Awal'].toString();
    priceAController.text = item['Harga Reseller'].toString();
    priceBController.text = item['Harga Biasa'].toString();
    selectedCategory.value = item['kategori'];
    selectedImagePath.value = item['imageURL'] ?? '';

    Get.dialog(
      SingleChildScrollView(
        child: AlertDialog(
          title: const Text('Edit atau Hapus Barang'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const Text("Gambar Barang"),
                    SizedBox(height: 20.h),
                    GestureDetector(
                        onTap: pickImage,
                        child: Obx(() {
                          if (selectedImagePath.value.isEmpty) {
                            return Container(
                              color: Colors.grey,
                              height: 150.h,
                              width: 150.h,
                              child: Center(
                                child: Icon(Icons.add, size: 50.sp),
                              ),
                            );
                          } else {
                            final String imagePath = selectedImagePath.value;
                            if (imagePath.startsWith('http')) {
                              return Image.network(
                                imagePath,
                                fit: BoxFit.cover,
                                height: 150.h,
                                width: 150.h,
                              );
                            } else {
                              return Image.file(
                                File(imagePath),
                                fit: BoxFit.cover,
                                height: 150.h,
                                width: 150.h,
                              );
                            }
                          }
                        })),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Obx(() => DropdownButton<String>(
                    value: selectedCategory.value,
                    items: <String>['Makanan', 'Minuman', 'Lainnya']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setSelectedCategory(newValue);
                      }
                    },
                  )),
              SizedBox(height: 20.h),
              CustomTextField(
                labelText: 'Nama Barang',
                controller: nameController,
                isUseCustomKeyBoard: false,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                labelText: 'Jumlah',
                controller: quantityController,
                isUseCustomKeyBoard: true,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                labelText: 'Harga Masuk',
                controller: hargamasukController,
                isUseCustomKeyBoard: true,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                labelText: 'Harga Ressaler',
                controller: priceAController,
                isUseCustomKeyBoard: true,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                labelText: 'Harga Regullar',
                controller: priceBController,
                isUseCustomKeyBoard: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                selectedCategory = 'Makanan'.obs;
                selectedImagePath = ''.obs;
                nameController.clear();
                quantityController.clear();
                hargamasukController.clear();
                priceAController.clear();
                priceBController.clear();
                Get.back();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                await updatedData(docId, item['Banyak']);
                fetchData();
                selectedCategory = 'Makanan'.obs;
                selectedImagePath = ''.obs;
                nameController.clear();
                quantityController.clear();
                hargamasukController.clear();
                priceAController.clear();
                priceBController.clear();
                Get.back();
              },
              child: const Text('Simpan'),
            ),
            TextButton(
              onPressed: () async {
                await ref.doc(docId).delete();
                fetchData();
                selectedCategory = 'Makanan'.obs;
                selectedImagePath = ''.obs;
                nameController.clear();
                quantityController.clear();
                hargamasukController.clear();
                priceAController.clear();
                priceBController.clear();
                Get.back();
              },
              child: const Text('Hapus'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeSearchDelegate extends SearchDelegate<Map<String, dynamic>> {
  final StockBarangController controller;

  HomeSearchDelegate(this.controller);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showResults(context);
        },
        tooltip: 'Clear search query',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, {'action': 'back'});
      },
      tooltip: 'Go back',
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var filteredItems = <Map<String, dynamic>>[];
    final allItems = [
      ...controller.makananList,
      ...controller.minumanList,
      ...controller.lainnyaList
    ];

    filteredItems = allItems
        .where(
            (item) => item['nama'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return ListTile(
          leading: SizedBox(
            height: 50.h,
            width: 50.w,
            child: item['imageURL'] == null
                ? Image.asset('assets/images/Logo_Funtime.jpg')
                : Image.network(
                    item['imageURL'],
                    fit: BoxFit.cover,
                  ),
          ),
          title: Text(item['nama']),
          onTap: () {
            close(context, item);
            controller.editDeleteBarang(item['docid']);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('No suggestions yet'),
    );
  }
}
