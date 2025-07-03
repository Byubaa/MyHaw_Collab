class FAQModel {
  final String question;
  final String answer;

  FAQModel({required this.question, required this.answer});

  static List<FAQModel> getFAQList() {
    return [
      FAQModel(
        question: "Bagaimana cara mengisi saldo?",
        answer: "Anda dapat mengisi saldo melalui menu 'Isi Saldo' di halaman utama.",
      ),
      FAQModel(
        question: "Bagaimana cara membeli pulsa?",
        answer: "Pilih menu 'Pulsa', masukkan nomor HP, nominal pulsa, dan provider. Pastikan saldo Anda mencukupi.",
      ),
      FAQModel(
        question: "Apakah ada biaya tambahan saat membeli pulsa?",
        answer: "Ya, terdapat biaya administrasi sebesar Rp2000 untuk setiap pembelian pulsa.",
      ),
      FAQModel(
        question: "Apakah ada biaya tambahan saat membeli data?",
        answer: "Ya, terdapat biaya administrasi sebesar Rp3000 untuk setiap pembelian data.",
      ),
      FAQModel(
        question: "Bagaimana cara melihat riwayat transaksi?",
        answer: "Anda dapat melihat riwayat transaksi melalui menu 'Riwayat' di halaman utama.",
      ),
      FAQModel(
        question: "Bagaimana cara melihat pembukuan?",
        answer: "Pilih menu 'Pembukuan' untuk melihat total pemasukan, pengeluaran, dan riwayat transaksi.",
      ),
      FAQModel(
        question: "Apa yang harus dilakukan jika saldo tidak mencukupi?",
        answer: "Silakan isi saldo terlebih dahulu melalui menu 'Isi Saldo' sebelum melakukan pembelian.",
      ),
    ];
  }
}
