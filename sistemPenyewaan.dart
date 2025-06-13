import 'hp.dart';
import 'penyewa.dart';
import 'transaksi.dart';
import 'statusPerubahan.dart';
import 'dart:collection';

class SistemPenyewaan {
  List<HP> daftarHP = [];
  Queue<Transaksi> antrianPeminjaman = Queue<Transaksi>();
  Map<String, double> hargaPerModel = {};
  List<Transaksi> riwayatTransaksi = [];
  List<Penyewa> daftarPenyewa = [];
  List<StatusPerubahan> riwayatStatus = []; // Tambahkan ini

  void tambahHP(HP hp) {
    daftarHP.add(hp);
    hargaPerModel[hp.model] = hp.hargaPerHari;
  }

  void tambahPenyewa(Penyewa penyewa) {
    daftarPenyewa.add(penyewa);
  }

  void sewaHP(Transaksi transaksi) {
    if (transaksi.hp.tersedia) {
      antrianPeminjaman.add(transaksi);
      transaksi.hp.tersedia = false;
      riwayatTransaksi.add(transaksi);
      riwayatStatus.add(StatusPerubahan(
        DateTime.now(),
        transaksi.hp.id,
        false,
        'Disewa oleh ${transaksi.penyewa.nama}'
      ));
      print('\nPenyewaan berhasil!');
      print(transaksi);
    } else {
      print('\nMaaf, HP tidak tersedia.');
    }
  }

  void kembalikanHP(String transaksiId) {
    try {
      var transaksi = riwayatTransaksi.firstWhere(
        (t) => t.id == transaksiId && !t.sudahKembali,
      );
      transaksi.hp.tersedia = true;
      transaksi.sudahKembali = true;
      riwayatStatus.add(StatusPerubahan(
        DateTime.now(),
        transaksi.hp.id,
        true,
        'Dikembalikan oleh ${transaksi.penyewa.nama}'
      ));
      print('\nPengembalian berhasil!');
      print(transaksi);
    } catch (e) {
      print('\nTransaksi tidak ditemukan atau sudah dikembalikan.');
    }
  }

  List<HP> getHPTersedia() {
    return daftarHP.where((hp) => hp.tersedia).toList();
  }

  void tampilkanDaftarHP() {
    print('\nDaftar HP:');
    for (var hp in daftarHP) {
      print('\n${hp.toString()}\n=================');
    }
  }

  void tampilkanRiwayatTransaksi() {
    if (riwayatTransaksi.isEmpty) {
      print('\nBelum ada transaksi.');
      return;
    }
    print('\nRiwayat Transaksi:');
    for (var transaksi in riwayatTransaksi) {
      print('${transaksi.toString()}\n=================');
    }
  }

  void tampilkanRiwayatStatus() {
    if (riwayatStatus.isEmpty) {
      print('\nBelum ada riwayat perubahan status.');
      return;
    }
    print('\nRiwayat Perubahan Status (Terbaru ke Terlama):');
    // Menampilkan dari yang terbaru (implementasi Stack)
    for (var i = riwayatStatus.length - 1; i >= 0; i--) {
      print('\n${riwayatStatus[i].toString()}\n=================');
    }
  }
}
