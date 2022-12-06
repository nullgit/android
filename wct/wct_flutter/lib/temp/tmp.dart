import 'dart:async';

void main(List<String> args) {
  // Timer.periodic(const Duration(seconds: 3), (timer) {
  //   print('timer');
  // });
  var dateTime = DateTime.now().millisecondsSinceEpoch;
  var duration = const Duration(milliseconds: 12000).inMilliseconds;
  print(dateTime % duration);
}
