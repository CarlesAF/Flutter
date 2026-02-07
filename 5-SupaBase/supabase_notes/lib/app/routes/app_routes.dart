// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const PROFILE = _Paths.PROFILE;
  // Actualizado: Constante renombrada de ADD_NOTE a ADD_TASK
  static const ADD_TASK = _Paths.ADD_TASK;
  // Actualizado: Constante renombrada de EDIT_NOTE a EDIT_TASK
  static const EDIT_TASK = _Paths.EDIT_TASK;
}

abstract class _Paths {
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const PROFILE = '/profile';
  // Actualizado: Ruta cambió de /add-note a /add-task
  static const ADD_TASK = '/add-task';
  // Actualizado: Ruta cambió de /edit-note a /edit-task
  static const EDIT_TASK = '/edit-task';
}
 
