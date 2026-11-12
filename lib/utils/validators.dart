class Validators {
  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) return 'Judul tidak boleh kosong';
    if (value.length < 3) return 'Minimal 3 karakter';
    if (value.length > 50) return 'Maksimal 50 karakter';
    return null;
  }

  static String? validateContent(String? value) {
    if (value == null || value.isEmpty) return 'Isi tidak boleh kosong';
    if (value.length < 10) return 'Minimal 10 karakter';
    if (value.length > 1000) return 'Maksimal 1000 karakter';
    return null;
  }

  static String sanitize(String input) => input.replaceAll('<', '').replaceAll('>', '').replaceAll('"', '').replaceAll("'", '');
}