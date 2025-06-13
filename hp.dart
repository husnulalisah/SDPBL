
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
