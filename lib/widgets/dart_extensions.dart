extension Retry<T> on Future<T> Function() {
  Future<T> withRetries(int count) async {
    while (true) {
      try {
        final future = this();
        return await future;
      }
      catch (e) {
        if (count > 0) {
          count--;
        }
        else {
          rethrow;
        }
      }
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
  String toTitleCase() => replaceAll(RegExp(' '), ' ').split(' ').map((str) => str.capitalize()).join(' ');



}
