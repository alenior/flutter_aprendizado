class ContaRepository extends ChangeNotifier {
  late Database db;
  List<Posicao> _carteira = [];
}
