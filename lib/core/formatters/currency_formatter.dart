String formatarMoedaReal(double valor) {
  final partes = valor.toStringAsFixed(2).split('.');
  final reais = partes[0];
  final centavos = partes[1];
  final buffer = StringBuffer();

  for (var i = 0; i < reais.length; i++) {
    final posicaoRestante = reais.length - i;

    buffer.write(reais[i]);

    if (posicaoRestante > 1 && posicaoRestante % 3 == 1) {
      buffer.write('.');
    }
  }

  return 'R\$ ${buffer.toString()},$centavos';
}
