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
  final TextEditingController priceController = TextEditingController();

  void setSelectedCategory(String value) {
    selectedCategory.value = value;
  }
  
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('menu_images/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');
      
      try {
        final uploadTask = storageRef.putFile(file);
        final snapshot = await uploadTask;
        
        final downloadURL = await snapshot.ref.getDownloadURL();
        if(
          nameController.text.isNotEmpty &&
          quantityController.text.isNotEmpty &&
          priceController.text.isNotEmpty
        ){
        final data = {
          "nama": nameController.text,
          "kategori": selectedCategory.value,
          "Banyak": int.parse(quantityController.text),
          "Harga": priceController.text,
          "imageURL": downloadURL,
        };
        final refDoc = ref.doc();
        await refDoc.set(data);
        fetchData(); 
        }else if(
          nameController.text.isNotEmpty &&
          quantityController.text.isEmpty &&
          priceController.text.isNotEmpty
        ){
          final data = {
          "nama": nameController.text,
          "kategori": selectedCategory.value,
          "Banyak": 0,
          "Harga": priceController.text,
          "imageURL": downloadURL,
        };
        final refDoc = ref.doc();
        await refDoc.set(data);
        fetchData(); 
        }else if(
          nameController.text.isNotEmpty &&
          quantityController.text.isNotEmpty &&
          priceController.text.isEmpty
        ){
          final data = {
          "nama": nameController.text,
          "kategori": selectedCategory.value,
          "Banyak": int.parse(quantityController.text),
          "Harga": 0,
          "imageURL": downloadURL,
        };
        final refDoc = ref.doc();
        await refDoc.set(data);
        fetchData(); 
        }else if(
          nameController.text.isNotEmpty &&
          quantityController.text.isEmpty &&
          priceController.text.isEmpty
        ){
          final data = {
          "nama": nameController.text,
          "kategori": selectedCategory.value,
          "Banyak": 0,
          "Harga": 0,
          "imageURL": downloadURL,
        };
        final refDoc = ref.doc();
        await refDoc.set(data);
        fetchData(); 
        }
      } catch (e) {
        Get.snackbar("Error",'Error uploading image: $e',backgroundColor: Colors.red);
      }
    } else {
      if(
          nameController.text.isNotEmpty &&
          quantityController.text.isNotEmpty &&
          priceController.text.isNotEmpty
        ){
        final data = {
          "nama": nameController.text,
          "kategori": selectedCategory.value,
          "Banyak": int.parse(quantityController.text),
          "Harga": priceController.text,
          "imageURL": null,
        };
        final refDoc = ref.doc();
        await refDoc.set(data);
        fetchData(); 
        }else if(
          nameController.text.isNotEmpty &&
          quantityController.text.isEmpty &&
          priceController.text.isNotEmpty
        ){
          final data = {
          "nama": nameController.text,
          "kategori": selectedCategory.value,
          "Banyak": 0,
          "Harga": priceController.text,
          "imageURL": null,
        };
        final refDoc = ref.doc();
        await refDoc.set(data);
        fetchData(); 
        }else if(
          nameController.text.isNotEmpty &&
          quantityController.text.isNotEmpty &&
          priceController.text.isEmpty
        ){
          final data = {
          "nama": nameController.text,
          "kategori": selectedCategory.value,
          "Banyak": int.parse(quantityController.text),
          "Harga": 0,
          "imageURL": null,
        };
        final refDoc = ref.doc();
        await refDoc.set(data);
        fetchData(); 
        }else if(
          nameController.text.isNotEmpty &&
          quantityController.text.isEmpty &&
          priceController.text.isEmpty
        ){
          final data = {
          "nama": nameController.text,
          "kategori": selectedCategory.value,
          "Banyak": 0,
          "Harga": 0,
          "imageURL": null,
        };
        final refDoc = ref.doc();
        await refDoc.set(data);
        fetchData(); 
        }
    }
  }

  void fetchData() async {
    var makananSnapshot = await ref.where('kategori', isEqualTo: 'Makanan').get();
    var minumanSnapshot = await ref.where('kategori', isEqualTo: 'Minuman').get();
    var lainnyaSnapshot = await ref.where('kategori', isEqualTo: 'Lainnya').get();

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
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: pickImage,
                      child: Obx(() =>
                        Container(
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
                        )
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(() => DropdownButton<String>(
                value: selectedCategory.value,
                items:
                    <String>['Makanan', 'Minuman', 'Lainnya'].map((String value) {
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
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                await uploadData();
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
}
