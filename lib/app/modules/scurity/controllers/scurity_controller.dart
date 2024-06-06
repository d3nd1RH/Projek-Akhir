import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../login/controllers/login_controller.dart';

class ScurityController extends GetxController {
  var users = <Map<String, dynamic>>[].obs;
  var currentUserUid = ''.obs;
  var userPeran = <Rx<String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentUserUid();
    fetchUsers();
  }

  void fetchCurrentUserUid() {
    final loginController = Get.find<LoginController>();
    loginController.streamAuthStatus.listen((user) {
      if (user != null) {
        currentUserUid.value = user.uid;
      }
    });
  }

  void fetchUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('userdata').get();
      users.value = snapshot.docs
          .where((doc) => doc.id != currentUserUid.value && doc.data()['peran'] != 'Owner')
          .map((doc) => doc.data())
          .toList();
      if (users.isNotEmpty) {
        userPeran.value = users.map((user) {
          var peran = user['peran'] ?? 'Lainnya';
          return Rx<String>(peran);
        }).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch users: $e');
    }
  }

  void updateRole(String userId, bool isKnown) async {
    try {
      await FirebaseFirestore.instance
          .collection('userdata')
          .doc(userId)
          .update({'peran': isKnown ? 'Pegawai' : 'Lainnya'});
      Get.snackbar('Success', 'Role updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update role: $e');
    }
  }
}
