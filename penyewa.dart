
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