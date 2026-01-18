import 'package:flutter/material.dart'; // Paquete para UI (colores, widgets, etc)
import 'package:get/get.dart'; // Paquete GetX para gestión de estado reactivo
import 'package:movies/api/api.dart'; // Importa constantes de la API
import 'package:movies/api/api_service.dart'; // Importa el servicio de API
import 'package:movies/models/movie.dart'; // Importa el modelo Movie
import 'package:movies/models/actor.dart'; // Importa el modelo Actor

// CONTROLADOR DE PELÍCULAS: gestiona toda la lógica y estado de películas y actores
// Extiende GetxController de GetX para manejar estado reactivo
class MoviesController extends GetxController {
  // VARIABLES REACTIVAS - El ".obs" hace que se actualice automáticamente en la UI cuando cambien
  
  // isLoading: indica si se está cargando datos de la API (muestra spinner)
  var isLoading = false.obs;
  
  // isLoadingMore: indica si se está cargando más elementos para paginación
  var isLoadingMore = false.obs;
  
  // mainTopRatedMovies: lista de películas mejor calificadas
  var mainTopRatedMovies = <Movie>[].obs;
  
  // popularActors: lista de actores populares
  var popularActors = <Actor>[].obs;
  
  // trendingActors: lista de actores en tendencia
  var trendingActors = <Actor>[].obs;
  
  // trendingMovies: lista de películas en tendencia
  var trendingMovies = <Movie>[].obs;
  
  // mainTopRatedSeries: lista de series mejor calificadas
  var mainTopRatedSeries = <Movie>[].obs;
  
  // trendingSeries: lista de series en tendencia
  var trendingSeries = <Movie>[].obs;
  
  // watchListMovies: lista de películas guardadas en "Mi Lista" por el usuario
  var watchListMovies = <Movie>[].obs;
  
  // VARIABLES DE PAGINACIÓN (no reactivas porque solo se usan internamente)
  var currentTrendingPage = 1; // Página actual de actores en tendencia
  var currentMoviePage = 1; // Página actual de películas
  var currentSeriesPage = 1; // Página actual de series
  
  // Se ejecuta automáticamente cuando el controlador se inicializa
  // "onInit" es un método del ciclo de vida de GetxController
  @override
  void onInit() {
    super.onInit(); // Llama al método onInit() de la clase padre
    _loadInitialData(); // Carga los datos iniciales de la API
  }

  // Carga todos los datos iniciales cuando la app abre
  // async: permite usar await para esperar peticiones HTTP
  Future<void> _loadInitialData() async {
    try {
      isLoading.value = true; // Muestra el spinner de carga
      
      // Hace todas las peticiones a la API de forma paralela (espera a que terminen todas)
      final topRated = await ApiService.getTopRatedMovies(); // Películas mejor calificadas
      final popular = await ApiService.getPopularActors(); // Actores populares
      final trending = await ApiService.getTrendingActors(currentTrendingPage); // Actores en tendencia
      final trendingMovieList = await ApiService.getCustomMovies('popular?api_key=${Api.apiKey}&language=en-US&page=$currentMoviePage'); // Películas populares
      final topRatedSeries = await ApiService.getTopRatedSeries(); // Series mejor calificadas
      final trendingSeriesList = await ApiService.getPopularSeries(currentSeriesPage); // Series populares
      
      // ASIGNA LOS RESULTADOS A LAS VARIABLES REACTIVAS
      // Si la API devuelve null (error), usa una lista vacía []
      mainTopRatedMovies.value = topRated ?? []; // Películas top rated
      popularActors.value = popular ?? []; // Actores populares
      trendingActors.value = trending ?? []; // Actores en tendencia
      trendingMovies.value = trendingMovieList ?? []; // Películas en tendencia
      mainTopRatedSeries.value = topRatedSeries ?? []; // Series top rated
      trendingSeries.value = trendingSeriesList ?? []; // Series en tendencia
    } catch (e) {
      // Si ocurre un error durante la carga, lo imprime
    } finally {
      // Se ejecuta siempre, independientemente de si hubo error o no
      isLoading.value = false; // Oculta el spinner de carga
    }
  }

  // Carga más actores cuando el usuario hace scroll al final de la lista
  // Se usa para implementar "infinite scroll" o paginación
  Future<void> loadMoreTrendingActors() async {
    if (isLoadingMore.value) return; // Si ya está cargando, no hace nada
    isLoadingMore.value = true; // Marca que está cargando
    currentTrendingPage++; // Incrementa el número de página
    
    // Obtiene los actores de la siguiente página de la API
    final newActors = await ApiService.getTrendingActors(currentTrendingPage);
    
    // Si obtiene resultados, los añade a la lista existente
    if (newActors != null) {
      trendingActors.addAll(newActors); // .addAll() añade todos los elementos de la lista
    }
    isLoadingMore.value = false; // Marca que terminó de cargar
  }

  // Carga más películas cuando el usuario hace scroll al final
  Future<void> loadMoreTrendingMovies() async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;
    currentMoviePage++; // Incrementa la página
    
    // Obtiene películas de la siguiente página
    final newMovies = await ApiService.getCustomMovies('popular?api_key=${Api.apiKey}&language=en-US&page=$currentMoviePage');
    
    if (newMovies != null) {
      trendingMovies.addAll(newMovies); // Añade las nuevas películas a la lista
    }
    isLoadingMore.value = false;
  }

  // Carga más series cuando el usuario hace scroll al final
  Future<void> loadMoreTrendingSeries() async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;
    currentSeriesPage++; // Incrementa la página
    
    // Obtiene series de la siguiente página
    final newSeries = await ApiService.getPopularSeries(currentSeriesPage);
    
    if (newSeries != null) {
      trendingSeries.addAll(newSeries); // Añade las nuevas series a la lista
    }
    isLoadingMore.value = false;
  }

  // Verifica si una película está en la lista de "Mi Lista"
  // Retorna true si está, false si no
  bool isInWatchList(Movie movie) {
    // .any() devuelve true si existe algún elemento que cumpla la condición
    return watchListMovies.any((m) => m.id == movie.id); // Busca si existe una película con el mismo ID
  }

  // Añade o quita una película de "Mi Lista"
  void addToWatchList(Movie movie) {
    // Verifica si la película ya está en la lista
    if (watchListMovies.any((m) => m.id == movie.id)) {
      // SI ESTÁ: la quita
      watchListMovies.remove(movie); // Elimina la película
      
      // Muestra notificación de que se eliminó
      Get.snackbar(
        'Removed from Watch List', // Título
        movie.title, // Subtítulo con el nombre de la película
        snackPosition: SnackPosition.BOTTOM, // Aparece en la parte inferior
        backgroundColor: const Color(0xFF1F1F1F), // Color de fondo gris oscuro
        colorText: Colors.white, // Texto en blanco
        duration: const Duration(seconds: 2), // Desaparece después de 2 segundos
        borderRadius: 8, // Bordes redondeados
        margin: const EdgeInsets.all(16), // Espacio desde los bordes
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Espacio interno
        titleText: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            'Removed from Watch List',
            style: const TextStyle(
              color: Color(0xFFFFA726), // Color naranja
              fontWeight: FontWeight.w700, // Texto en negrita
              fontSize: 16, // Tamaño del texto
            ),
          ),
        ),
        messageText: Text(
          movie.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        icon: const Icon(
          Icons.bookmark_remove, // Icono de bookmark eliminado
          color: Color(0xFFFFA726),
          size: 28,
        ),
      );
    } else {
      // SI NO ESTÁ: la añade
      watchListMovies.add(movie); // Añade la película a la lista
      
      // Muestra notificación de que se añadió
      Get.snackbar(
        'Added to Watch List',
        movie.title,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1F1F1F),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        titleText: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            'Added to Watch List',
            style: const TextStyle(
              color: Color(0xFF0296E5), // Color azul
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        messageText: Text(
          movie.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        icon: const Icon(
          Icons.bookmark_add, // Icono de bookmark añadido
          color: Color(0xFF0296E5),
          size: 28,
        ),
      );
    }
  }
}
