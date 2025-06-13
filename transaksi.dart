import 'penyewa.dart';
import 'hp.dart';
// Kelas untuk menangani transaksi
class Transaksi {
  String id;
  Penyewa penyewa;
  HP hp;
  DateTime tanggalSewa;
  int durasiHari;
  double totalHarga;
  bool sudahKembali;

  Transaksi(this.id, this.penyewa, this.hp, this.tanggalSewa, this.durasiHari)
      : totalHarga = 0,
        sudahKembali = false {
    totalHarga = hitungHarga();
  }

  double hitungHarga() {
    double harga = hp.hargaPerHari * durasiHari;
    if (penyewa is PelangganVIP) {
      harga = harga * (1 - (penyewa as PelangganVIP).diskon);
    }
    return harga;
  }

  String get tanggalKembali {
    return tanggalSewa.add(Duration(days: durasiHari)).toString().split(' ')[0];
  }

  @override
  String toString() {
    return '''
ID Transaksi: $id

=== DATA PENYEWA === 
${penyewa.toString()}

===== DATA HP =====
${hp.toString()}
Tanggal Sewa: ${tanggalSewa.toString().split(' ')[0]}
Durasi: $durasiHari hari
Tanggal Kembali: $tanggalKembali
Total Harga: Rp${totalHarga.toStringAsFixed(0)}
Status: ${sudahKembali ? 'Sudah Kembali' : 'Belum Kembali'}''';
  }
}
