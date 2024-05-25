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

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const Splash(),
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
  ];
}
