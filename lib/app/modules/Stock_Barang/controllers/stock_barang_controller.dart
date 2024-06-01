import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class StockBarangController extends GetxController {
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

  void setSelectedCategory(String value) {
    selectedCategory.value = value;
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
      final storageRef = FirebaseStorage.instance.ref().child(
          'menu_images/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');

      try {
        final uploadTask = storageRef.putFile(file);
        final snapshot = await uploadTask;

        final downloadURL = await snapshot.ref.getDownloadURL();
        if (nameController.text.isNotEmpty) {
          final data = {
            "nama": nameController.text,
            "kategori": selectedCategory.value,
            "Banyak": quantityController.text.isNotEmpty
                ? int.parse(quantityController.text)
                : 0,
            "Harga Awal": hargamasukController.text.isNotEmpty? double.parse(hargamasukController.text)
                : 0.0,
            "Harga Reseller": priceAController.text.isNotEmpty
                ? double.parse(priceAController.text)
                : 0.0,
            "Harga Biasa": priceBController.text.isNotEmpty
                ? double.parse(priceBController.text)
                : 0.0,
            "imageURL": downloadURL,
          };

          final refDoc = ref.doc(nameController.text);
          await refDoc.set(data);
          fetchData();
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
          "Harga Awal": hargamasukController.text.isNotEmpty? double.parse(hargamasukController.text)
                : 0.0,
          "Harga Reseller":
              priceAController.text.isNotEmpty 
              ? double.parse(priceAController.text)
              : 0.0,
          "Harga Biasa": priceBController.text.isNotEmpty
              ? double.parse(priceBController.text)
              : 0.0,
          "imageURL": null,
        };

        final refDoc = ref.doc();
        await refDoc.set(data);
        fetchData();
      }
    }
  }

  Future<void> updatedData(String docId) async {
  if (selectedImagePath.value.isNotEmpty && !selectedImagePath.value.startsWith('http')) {
    final file = File(selectedImagePath.value);
    final storageRef = FirebaseStorage.instance.ref().child(
        'menu_images/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');

    try {
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;

      final downloadURL = await snapshot.ref.getDownloadURL();
      if (nameController.text.isNotEmpty) {
        final data = {
          "nama": nameController.text,
          "kategori": selectedCategory.value,
          "Banyak": quantityController.text.isNotEmpty
              ? int.parse(quantityController.text)
              : 0,
          "Harga Awal": hargamasukController.text.isNotEmpty? double.parse(hargamasukController.text)
                : 0.0,
          "Harga Reseller": priceAController.text.isNotEmpty
              ? double.parse(priceAController.text)
              : 0.0,
          "Harga Biasa": priceBController.text.isNotEmpty
              ? double.parse(priceBController.text)
              : 0.0,
          "imageURL": downloadURL,
        };

        await ref.doc(docId).update(data);
        fetchData();
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
        "Harga Awal": hargamasukController.text.isNotEmpty? double.parse(hargamasukController.text)
                : 0.0,
        "Harga Reseller":
            priceAController.text.isNotEmpty ? double.parse(priceAController.text)
            : 0.0,
        "Harga Biasa": priceBController.text.isNotEmpty
            ? double.parse(priceBController.text)
            : 0.0,

        "imageURL": selectedImagePath.value.isNotEmpty ? selectedImagePath.value : null,
      };

      await ref.doc(docId).update(data);
      fetchData();
    }
  }
}


  void fetchData() async {
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
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20.h,
              ),
              TextField(
                controller: hargamasukController,
                decoration: const InputDecoration(
                  labelText: 'Harga Masuk',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20.h,
              ),
              TextField(
                controller: priceAController,
                decoration: const InputDecoration(
                  labelText: 'Harga Reseller',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: priceBController,
                decoration: const InputDecoration(
                  labelText: 'Harga Regular',
                ),
                keyboardType: TextInputType.number,
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

  Future<void> updateStock(String docId, int newStock) async {
    await ref.doc(docId).update({'Banyak': newStock});
    fetchData();
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
                      }
                      )
                    ),
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
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                ),
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: hargamasukController,
                decoration: const InputDecoration(
                  labelText: 'Harga Masuk',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: priceAController,
                decoration: const InputDecoration(
                  labelText: 'Harga Reseller',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: priceBController,
                decoration: const InputDecoration(
                  labelText: 'Harga Regular',
                ),
                keyboardType: TextInputType.number,
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
                await updatedData(docId);
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
