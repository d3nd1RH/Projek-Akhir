import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/scurity_controller.dart';

class ScurityView extends GetView<ScurityController> {
  const ScurityView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ScurityView'),
        centerTitle: true,
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
