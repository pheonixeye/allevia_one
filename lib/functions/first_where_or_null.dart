import 'package:allevia_one/functions/dprint.dart';

extension FirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } on StateError catch (e) {
      dprint('firstWhereOrNull($runtimeType-->${e.message})');
      return null;
    }
  }
}
