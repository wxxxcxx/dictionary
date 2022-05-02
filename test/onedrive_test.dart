import 'package:dictionary/src/onedrive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dictionary/src/api.dart';

void main() {
  test('onedrive client authorize', () async {
    final client=OneDrive();
    client.authorize();
  });

}
