import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/scurity_controller.dart';

class ScurityView extends GetView<ScurityController> {
  const ScurityView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text('Keamanan'),
        titleTextStyle: TextStyle(
            fontSize: 25.sp, fontWeight: FontWeight.bold, color: Colors.black),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(233, 107, 107, 1),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text(
          'ScurityView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
