// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const PROFILE = _Paths.PROFILE;
  static const ADD_TASK = _Paths.ADD_TASK;
  static const EDIT_TASK = _Paths.EDIT_TASK;
}

abstract class _Paths {
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const PROFILE = '/profile';
  static const ADD_TASK = '/add-task';
  static const EDIT_TASK = '/edit-task';
}
 
