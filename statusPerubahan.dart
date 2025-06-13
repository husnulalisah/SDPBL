
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
