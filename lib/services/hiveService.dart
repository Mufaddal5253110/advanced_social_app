import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class HiveService {
  static isExists({String? boxName}) async {
    final openBox = await Hive.openBox(boxName!);
    int length = openBox.length;
    return length != 0;
  }

  static addBoxes<T>(List<T> items, String boxName) async {
    print("adding boxes");
    final openBox = await Hive.openBox(boxName);
    // print(openBox);
    // print(openBox.values);
    // print(openBox.clear());
    await openBox.clear();
    for (var item in items) {
      openBox.add(item);
    }
  }

  static clearBoxes<T>(String boxName) async {
    print("clearing boxes");
    final openBox = await Hive.openBox(boxName);
    await openBox.clear();
  }

  static getBoxes<T>(String boxName) async {
    List<T> boxList = [];

    final openBox = await Hive.openBox(boxName);

    int length = openBox.length;

    for (int i = 0; i < length; i++) {
      boxList.add(openBox.getAt(i));
    }

    return boxList;
  }
}
