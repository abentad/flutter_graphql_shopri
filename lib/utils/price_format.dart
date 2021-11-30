import 'package:money_formatter/money_formatter.dart';

String formatPrice(String? price) {
  return MoneyFormatter(amount: (double.parse(price!))).output.nonSymbol;
}
