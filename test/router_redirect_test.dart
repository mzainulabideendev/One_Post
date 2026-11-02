import 'package:flutter_test/flutter_test.dart';
import 'package:onepost/app/router.dart';

void main() {
  group('safePostLoginDestination', () {
    test('preserves an internal provider connection destination', () {
      expect(
        safePostLoginDestination('/accounts?connect=x'),
        '/accounts?connect=x',
      );
    });

    test('rejects external and authentication destinations', () {
      expect(
        safePostLoginDestination('https://attacker.invalid/'),
        isNull,
      );
      expect(safePostLoginDestination('//attacker.invalid/'), isNull);
      expect(safePostLoginDestination('/sign-in'), isNull);
      expect(safePostLoginDestination('/welcome'), isNull);
    });
  });
}
