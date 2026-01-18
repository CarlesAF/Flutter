// CLASE QUE CONTIENE LAS CONSTANTES DE LA API DE THEMOVIEDB
// Esta clase centraliza todas las URLs y credenciales necesarias para hacer peticiones a la API
class Api {
  // BASE URL: la URL raíz de la API de The Movie Database (TMDB)
  static const baseUrl = "https://api.themoviedb.org/3/";
  
  // IMAGE BASE URL: URL base para cargar imágenes de películas y actores
  // "original" significa que cargamos las imágenes en su resolución máxima
  static const imageBaseUrl = "https://image.tmdb.org/t/p/original/";
  
  // API KEY: clave de autenticación para acceder a la API de TMDB
  // Esta clave debe incluirse en cada petición HTTP
  static const apiKey = "df4c8eb65c8c23eb8879727f62f83a9c";
}
