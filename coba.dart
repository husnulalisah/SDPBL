import 'dart:collection';
import 'dart:io';

// Kelas dasar untuk HP
class HP {
  String id;
  String model;
  double hargaPerHari;
  bool tersedia;
  String spesifikasi;

  HP(this.id, this.model, this.hargaPerHari, this.spesifikasi, {this.tersedia = true});

  @override
  String toString() {
    return '''Model: $model
ID: $id
Harga/Hari: Rp${hargaPerHari.toStringAsFixed(0)}
Status: ${tersedia ? 'Tersedia' : 'Disewa'}
Spesifikasi: $spesifikasi''';
  }
}

// Kelas untuk Penyewa
class Penyewa {
  String nama;
  String id;
  String noTelp;
  String alamat;
  
  Penyewa(this.nama, this.id, this.noTelp, this.alamat);

  @override
  String toString() {
    return '''Nama: $nama
ID: $id
No. Telp: $noTelp
Alamat: $alamat''';
  }
}

// Kelas turunan PelangganVIP
class PelangganVIP extends Penyewa {
  double diskon;

  PelangganVIP(String nama, String id, String noTelp, String alamat, this.diskon)
      : super(nama, id, noTelp, alamat);

  @override
  String toString() {
    return '''${super.toString()}
Diskon: ${(diskon * 100).toStringAsFixed(0)}%''';
  }
}

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

--- Data Penyewa ---
${penyewa.toString()}

--- Data HP ---
${hp.toString()}
Tanggal Sewa: ${tanggalSewa.toString().split(' ')[0]}
Durasi: $durasiHari hari
Tanggal Kembali: $tanggalKembali
Total Harga: Rp${totalHarga.toStringAsFixed(0)}
Status: ${sudahKembali ? 'Sudah Kembali' : 'Belum Kembali'}''';
  }
}

class StatusPerubahan {
  DateTime waktu;
  String idHP;
  bool statusBaru;
  String keterangan;

  StatusPerubahan(this.waktu, this.idHP, this.statusBaru, this.keterangan);

  @override
  String toString() {
    return '''Waktu: ${waktu.toString()}
HP ID: $idHP
Status: ${statusBaru ? 'Tersedia' : 'Disewa'}
Keterangan: $keterangan''';
  }
}

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

// Fungsi untuk membersihkan layar
void clearScreen() {
  if (Platform.isWindows) {
    print(Process.runSync('cls', [], runInShell: true).stdout);
  } else {
    print(Process.runSync('clear', [], runInShell: true).stdout);
  }
}

// Fungsi untuk mendapatkan input string
String getInput(String prompt) {
  stdout.write(prompt);
  return stdin.readLineSync() ?? '';
}

// Fungsi untuk mendapatkan input double
double getDoubleInput(String prompt) {
  while (true) {
    try {
      stdout.write(prompt);
      return double.parse(stdin.readLineSync() ?? '0');
    } catch (e) {
      print('Input tidak valid. Mohon masukkan angka.');
    }
  }
}

// Fungsi untuk mendapatkan input integer
int getIntInput(String prompt) {
  while (true) {
    try {
      stdout.write(prompt);
      return int.parse(stdin.readLineSync() ?? '0');
    } catch (e) {
      print('Input tidak valid. Mohon masukkan angka bulat.');
    }
  }
}

void main() {
  var sistem = SistemPenyewaan();

  // Inisialisasi data awal
  sistem.tambahHP(HP('IP13', 'iPhone 13', 100000,
      'RAM: 4GB, Storage: 128GB, Warna: Midnight'));
  sistem.tambahHP(HP('IP14', 'iPhone 14', 150000,
      'RAM: 6GB, Storage: 256GB, Warna: Purple'));
  sistem.tambahHP(HP('IP15', 'iPhone 15', 200000,
      'RAM: 8GB, Storage: 512GB, Warna: Natural Titanium'));
  sistem.tambahHP(HP('IP16', 'iPhone 16', 250000,
      'RAM: 12GB, Storage: 1TB, Warna: white'));

  while (true) {
    clearScreen();
    print('╔═══════════════════════════════════════╗');
    print('║      Sistem Penyewaan iPhone          ║');
    print('╠═══════════════════════════════════════╣');
    print('║ 1. Tampilkan Daftar iPhone            ║');
    print('║ 2. Sewa iPhone                        ║');
    print('║ 3. Kembalikan iPhone                  ║');
    print('║ 4. Lihat Riwayat Transaksi            ║');
    print('║ 5. Lihat Riwayat Status iPhone        ║');
    print('║ 6. Keluar                             ║');
    print('╚═══════════════════════════════════════╝');

    var pilihan = getIntInput('\nPilih menu (1-6): ');

    switch (pilihan) {
      case 1:
        print('╔═══════════════════════════════════════╗');
        print('║         DAFTAR IPHONE                 ║');
        print('╚═══════════════════════════════════════╝');
        sistem.tampilkanDaftarHP();
        break;

      case 2:
        print('╔═══════════════════════════════════════╗');
        print('║         FORM PENYEWAAN                ║');
        print('╚═══════════════════════════════════════╝');
        var nama = getInput('Nama: ');
        var noTelp = getInput('No. Telp: ');
        var alamat = getInput('Alamat: ');
        var isVIP = getInput('Apakah member VIP? (y/n): ').toLowerCase() == 'y';

        Penyewa penyewa;
        String idPenyewa = 'P${sistem.daftarPenyewa.length + 1}'.padLeft(4, '0');

        if (isVIP) {
          penyewa = PelangganVIP(nama, idPenyewa, noTelp, alamat, 0.1);
        } else {
          penyewa = Penyewa(nama, idPenyewa, noTelp, alamat);
        }
        sistem.tambahPenyewa(penyewa);

        sistem.tampilkanDaftarHP();
        var idHP = getInput('\nMasukkan ID iPhone yang ingin disewa: ');
        var hp = sistem.daftarHP.firstWhere(
          (h) => h.id == idHP && h.tersedia,
          orElse: () => HP('', '', 0, ''),
        );

        if (hp.id.isEmpty) {
          print('iPhone tidak tersedia.');
          break;
        }

        var durasi = getIntInput('Durasi sewa (hari): ');
        var idTransaksi = 'T${sistem.riwayatTransaksi.length + 1}'.padLeft(4, '0');

        sistem.sewaHP(Transaksi(
          idTransaksi,
          penyewa,
          hp,
          DateTime.now(),
          durasi,
        ));
        break;

      case 3:
        print('╔═══════════════════════════════════════╗');
        print('║         FORM PENGEMBALIAN             ║');
        print('╚═══════════════════════════════════════╝');
        var idTransaksi = getInput('Masukkan ID Transaksi: ');
        sistem.kembalikanHP(idTransaksi);
        break;

      case 4:
        print('╔═══════════════════════════════════════╗');
        print('║         RIWAYAT TRANSAKSI             ║');
        print('╚═══════════════════════════════════════╝');
        sistem.tampilkanRiwayatTransaksi();
        break;

      case 5:
        print('╔═══════════════════════════════════════╗');
        print('║      RIWAYAT STATUS IPHONE            ║');
        print('╚═══════════════════════════════════════╝');
        sistem.tampilkanRiwayatStatus();
        break;

      case 6:
        print('╔═══════════════════════════════════════╗');
        print('║    TERIMA KASIH TELAH MENGGUNAKAN     ║');
        print('║         SISTEM KAMI!                  ║');
        print('╚═══════════════════════════════════════╝');
        return;

      default:
        print('\n⚠️ Pilihan tidak valid!');
    }

    print('\nTekan Enter untuk melanjutkan...');
    stdin.readLineSync();
  }
}