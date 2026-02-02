import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';


Future<void> main() async {
  await Supabase.initialize(
    url: 'https://lhkrfjpcvfwyonzfhzez.supabase.co',
    anonKey: 'sb_publishable_fo4rfYlAK04GR_V3vG3sCg_213oYVRo',
  );
  runApp(App());
}