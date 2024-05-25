import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/costumer_controller.dart';

class CostumerView extends GetView<CostumerController> {
  const CostumerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CostumerView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CostumerView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
