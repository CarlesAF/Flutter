// ignore_for_file: deprecated_member_use

// IMPORTACIONES NECESARIAS
import 'package:flutter/material.dart'; // Paquete principal de Flutter para UI
import 'package:flutter/services.dart'; // Paquete para controlar servicios del sistema (como la barra de estado)
import 'package:get/get.dart'; // Paquete GetX para gestión de estado y navegación
import 'package:movies/screens/main.dart'; // Importa la pantalla principal de la app

// PUNTO DE ENTRADA DE LA APLICACIÓN
void main() {
  // runApp() inicia la app, pasando MyApp como widget raíz
  runApp(const MyApp());
}

// CLASE PRINCIPAL DE LA APLICACIÓN - Widgets sin estado
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configura la apariencia de la barra de estado del dispositivo
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF242A32), // Color gris oscuro para la barra de estado
      ),
    );
    
    // GetMaterialApp es como MaterialApp pero con funcionalidades de GetX integradas
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // Oculta el banner "Debug" en la esquina superior derecha
      
      // TEMA GLOBAL DE LA APLICACIÓN
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF242A32), // Color de fondo gris oscuro para toda la app
        
        // Estilos de texto por defecto para toda la app
        textTheme: const TextTheme(
          // bodyLarge: texto grande (para títulos, etc)
          bodyLarge: TextStyle(
            color: Colors.white, // Texto en color blanco
            fontFamily: 'Poppins', // Usa la fuente Poppins (descargada en assets/fonts)
          ),
          // bodyMedium: texto mediano (para contenido normal)
          bodyMedium: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      
      home: Main(), // Widget que se muestra cuando la app inicia (pantalla principal)
    );
  }
}
