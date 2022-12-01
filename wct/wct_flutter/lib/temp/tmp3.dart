void main(List<String> args) {
  var list = ['1', '2', '3'];
  var firstWhere = list.firstWhere((element) => element == '3');
  print(firstWhere);
}
