const Map<String, int> _unidadesPorCaixaPorCodigo = {
  'BK001': 24, // Rosquinha de polvilho tradicional 120g
  'BK002': 24, // Rosquinha de polvilho tradicional 80g
  'BK003': 24, // Rosquinha de polvilho sabor cebola 70g
  'BK004': 24, // Rosquinha de polvilho sabor calabresa 70g
  'BK005': 24, // Rosquinha de polvilho sabor churrasco 70g
  'BK006': 24, // Rosquinha de polvilho sabor pizza 70g
  'BK007': 24, // Rosquinha de polvilho sabor bacon 70g
  'BK008': 24, // Rosquinha de polvilho sem lactose 70g
  'BK009': 24, // Rosquinha de polvilho com linhaça e chia 70g
  'BK010': 24, // Rosquinha de polvilho sabor queijo 70g
  'BK011': 24, // Biscoito de polvilho +Proteína 60g
  'BK012': 24, // Merengue caseiro 170g
  'BK013': 24, // Merengue caseiro 100g
  'BK014': 24, // Merengue caseiro sabor leite condensado 100g
  'BK015': 24, // Merengue caseiro sabor morango 100g
  'BK016': 40, // Flocos de arroz 100g
  'BK017': 12, // Broa de neve 170g
  'BK018': 12, // Broa de polvilho tradicional 200g
  'BK019': 12, // Broa de polvilho com coco 200g
  'BK020': 24, // Biscoito de amendoim 200g
  'BK021': 15, // Biscoito amanteigado 250g
  'BK022': 15, // Biscoito amanteigado com goiabada 250g
  'BK023': 15, // Biscoito de natal 250g
  'BK024': 15, // Rosca merengada 250g
  'BK025': 20, // Joelhinho crocante 180g
  'BK026': 20, // Salgadinho de bacon 70g
};

int? unidadesPorCaixaPorCodigo(String codigo) {
  return _unidadesPorCaixaPorCodigo[codigo.toUpperCase()];
}
