import 'package:biscoitos_kaue_mobile/core/storage/token_storage.dart';
import 'package:biscoitos_kaue_mobile/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('deve abrir a tela de login quando não houver token salvo', (
      WidgetTester tester,
      ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      BiscoitosKaueApp(
        tokenStorage: TokenStorage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Entrar'), findsWidgets);
  });
}