// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************


import 'package:get_it/get_it.dart';
import 'package:myapp/services/databaseServices.dart';
import 'package:myapp/services/hiveService.dart';

void $initGetIt(GetIt g, {String? environment}) {
  g.registerLazySingleton<DatabaseServices>(() => DatabaseServices());
  g.registerLazySingleton<HiveService>(() => HiveService());
}