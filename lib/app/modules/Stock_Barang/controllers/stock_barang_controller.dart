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

     Future<void> uploadData() async {
    if (selectedImagePath.value.isNotEmpty) {
      final file = File(selectedImagePath.value);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('menu_images/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');
      
      try {
        // Upload file to Firebase Storage
        final uploadTask = storageRef.putFile(file);
        final snapshot = await uploadTask;
        
        // Get the download URL
        final downloadURL = await snapshot.ref.getDownloadURL();
        
        // Prepare data to be stored in Firestore
        final data = {
          "nama": nameController.text,
          "kategori": selectedCategory.value,
          "Banyak": quantityController.text,
          "Harga": priceController.text,
          "imageURL": downloadURL, // Adding image URL to Firestore
        };
        
        // Store data in Firestore
        final refDoc = ref.doc();
        await refDoc.set(data);
        
      } catch (e) {
        print('Error uploading image: $e');
      }
    } else {
      // Handle case when no image is selected
      final data = {
        "nama": nameController.text,
        "kategori": selectedCategory.value,
        "Banyak": quantityController.text,
        "Harga": priceController.text,
        "imageURL": null, // No image selected
      };
      final refDoc = ref.doc();
      await refDoc.set(data);
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
}
