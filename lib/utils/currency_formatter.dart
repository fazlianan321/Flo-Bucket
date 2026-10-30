
String formatRupiah(int amount) {
  final value = amount.toString();
  final result = StringBuffer();

  for (int i = 0; i < value.length; i++) {
    result.write(value[i]);

    final remaining = value.length - i - 1;

    if (remaining > 0 && remaining % 3 == 0) {
      result.write('.');
    }
  }

  return 'Rp$result';
}
