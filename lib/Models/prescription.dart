import 'package:sticky_az_list/sticky_az_list.dart';
class Prescription extends TaggedItem{
  final String name;
  Prescription(
      {required this.name});
  @override
  String sortName() => name;
}