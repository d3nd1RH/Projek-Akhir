import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/scurity_controller.dart';

class ScurityView extends GetView<ScurityController> {
  const ScurityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keamanan'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(233, 107, 107, 1),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.users.isEmpty) {
          controller.fetchUsers();
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              final user = controller.users[index];
              final userPeran =
                  controller.userPeran[index]; 

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['photoUrl'] ?? ''),
                  ),
                  title: Text(user['nama'] ?? 'No Name'),
                  subtitle: Column(
                    children: [
                      const Text("Apakah anda mengenal orang ini?"),
                      Obx(() => Row(
                            children: [
                              Radio(
                                value: 'Pegawai',
                                groupValue: userPeran.value,
                                onChanged: (value) {
                                  controller.updateRole(
                                      user['uid'], value == 'Pegawai');
                                  userPeran.value = value!;
                                },
                              ),
                              const Text("Kenal"),
                              Radio(
                                value: 'Lainnya',
                                groupValue: userPeran.value,
                                onChanged: (value) {
                                  controller.updateRole(
                                      user['uid'], value == 'Pegawai');
                                  userPeran.value = value!;
                                },
                              ),
                              const Text("Tidak Kenal"),
                            ],
                          ))
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
