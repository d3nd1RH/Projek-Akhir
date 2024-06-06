import 'package:get/get.dart';

import '../../splash.dart';
import '../modules/Costumer/bindings/costumer_binding.dart';
import '../modules/Costumer/views/costumer_view.dart';
import '../modules/Lihat_Laporan/bindings/lihat_laporan_binding.dart';
import '../modules/Lihat_Laporan/views/lihat_laporan_view.dart';
import '../modules/Stock_Barang/bindings/stock_barang_binding.dart';
import '../modules/Stock_Barang/views/stock_barang_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/reset_pass/bindings/reset_pass_binding.dart';
import '../modules/reset_pass/views/reset_pass_view.dart';
import '../modules/scurity/bindings/scurity_binding.dart';
import '../modules/scurity/views/scurity_view.dart';
import '../modules/workhome/bindings/workhome_binding.dart';
import '../modules/workhome/views/workhome_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => Splash(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.STOCK_BARANG,
      page: () => const StockBarangView(),
      binding: StockBarangBinding(),
    ),
    GetPage(
      name: _Paths.COSTUMER,
      page: () => const CostumerView(),
      binding: CostumerBinding(),
    ),
    GetPage(
      name: _Paths.LIHAT_LAPORAN,
      page: () => const LihatLaporanView(),
      binding: LihatLaporanBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASS,
      page: () => const ResetPassView(),
      binding: ResetPassBinding(),
    ),
    GetPage(
      name: _Paths.WORKHOME,
      page: () => const WorkhomeView(),
      binding: WorkhomeBinding(),
    ),
    GetPage(
      name: _Paths.SCURITY,
      page: () => const ScurityView(),
      binding: ScurityBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
