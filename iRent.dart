import 'dart:io';
import 'hp.dart';
import 'penyewa.dart';
import 'transaksi.dart';
import 'sistemPenyewaan.dart';

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
    print('\n' + '=' * 35);
    print('======SISTEM PENYEWAAN IPHONE======');
    print('=' * 35);
  
    print(' 1. Tampilkan Daftar iPhone            ');
    print(' 2. Sewa iPhone                        ');
    print(' 3. Kembalikan iPhone                  ');
    print(' 4. Lihat Riwayat Transaksi            ');
    print(' 5. Lihat Riwayat Status iPhone        ');
    print(' 6. Keluar                             ');

    var pilihan = getIntInput('\nPilih menu (1-6): ');

    switch (pilihan) {
      case 1:
        print('\n' + '=' * 35);
        print('========== DAFTAR IPHONE ==========');
         print('=' * 35);
        sistem.tampilkanDaftarHP();
        break;

      case 2:
        print('\n' + '=' * 35);
        print('======== FORM PENYEWAAN ===========');
        print('=' * 35);

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
       print('\n' + '=' * 35);
        print('======== FORM PENGEMBALIAN ========');
        print('=' * 35);
  
        var idTransaksi = getInput('Masukkan ID Transaksi: ');
        sistem.kembalikanHP(idTransaksi);
        break;

      case 4:
       print('\n' + '=' * 35);
        print('======== RIWAYAT TRANSAKSI ========');
        print('=' * 35);
      
        sistem.tampilkanRiwayatTransaksi();
        break;

      case 5:
       print('\n' + '=' * 35);
        print('======== RIWAYAT STATUS IPHONE ========');
        print('=' * 35);
       
        sistem.tampilkanRiwayatStatus();
        break;

      case 6:
       print('\n' + '=' * 69);
        print('===========  TERIMA KASIH TELAH MENGGUNAKAN SISTEM KAMI!  ===========');
        print('=' * 69);
      
        return;

      default:
        print('\n Pilihan tidak valid!');
    }

    print('\n Tekan Enter untuk melanjutkan...');
    stdin.readLineSync();
  }
}