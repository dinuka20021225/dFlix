import 'dart:convert';

import 'package:dmovies/models/movie_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MovieService {
  // get the api key from.env
  final String? _apiKey = dotenv.env["TMDB_KEY"];
  final String _url = "https://api.themoviedb.org/3/movie";

  // 1 - Fetch all upcomming movies
  Future<List<MovieModel>> fetchUpcommingMovies({int page = 1}) async {
    try {
      final responce = await http.get(
        Uri.parse(
          "$_url/upcoming?api_key=$_apiKey&page=$page",
        ),
      );
      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        final List<dynamic> results = data["results"];

        return results
            .map((movieData) => MovieModel.fromJson(movieData))
            .toList();
      } else {
        throw Exception("Faild to load movies data");
      }
    } catch (error) {
      print("movie service error: $error");
      return [];
    }
  }

  // 2 - Fetch all now playing movies
  Future<List<MovieModel>> fetchNowPlayingMovies({int page = 1}) async {
    try {
      final responce = await http.get(
        Uri.parse(
          "$_url/now_playing?api_key=$_apiKey&page=$page",
        ),
      );
      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        final List<dynamic> results = data["results"];
        return results
            .map((movieData) => MovieModel.fromJson(movieData))
            .toList();
      } else {
        throw Exception("Faild to load movies data");
      }
    } catch (error) {
      print("Movie service Now playing error: $error");
      return [];
    }
  }

  // 3 - search movie
  Future<List<MovieModel>> searchMovie(String movieName) async {
    try {
      final responce = await http.get(
        Uri.parse(
          "https://api.themoviedb.org/3/search/multi?api_key=$_apiKey&query=$movieName",
        ),
      );
      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        final List<dynamic> results = data["results"];
        return results
            .map((movieData) => MovieModel.fromJson(movieData))
            .toList();
      } else {
        throw Exception("Faild to lord search movies data");
      }
    } catch (error) {
      print("Search error: $error");
      throw Exception("Faild to search movie");
    }
  }

  // similor movies
  // https://api.themoviedb.org/3/movie/12445/similar?api_key=ce30423267aa6517a7d6d59c20e55ac1
  Future<List<MovieModel>> similorMovies(int movieId) async {
    if (_apiKey == null) {
      print("API Key is missing");
      return [];
    }

    try {
      final responce = await http.get(
        Uri.parse("$_url/$movieId/similar?api_key=$_apiKey"),
      );

      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        final List<dynamic> results = data["results"];
        return results
            .map((movieData) => MovieModel.fromJson(movieData))
            .toList();
      } else {
        throw Exception("Faild to load movies data");
      }
    } catch (er) {
      print("Similor movie service error: $er");
      return [];
    }
  }

  // recomded movies
  Future<List<MovieModel>> recomondedMovies(int movieId) async {
    try {
      final responce = await http.get(
        Uri.parse(
          "$_url/$movieId/recommendations?api_key=$_apiKey",
        ),
      );
      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        final List<dynamic> results = data["results"];

        return results
            .map((movieData) => MovieModel.fromJson(movieData))
            .toList();
      } else {
        throw Exception("Faild to load movies data");
      }
    } catch (er) {
      print("Recomonded movie service error: $er");
      return [];
    }
  }

  // fethching movie images by movie id
  Future<List<String>> movieImages(int movieId) async {
    try {
      final responce = await http.get(
        Uri.parse(
          "$_url/$movieId/images?api_key=$_apiKey",
        ),
      );
      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        final List<dynamic> backdrops = data["backdrops"];
        return backdrops
            .take(10)
            .map((imageData) =>
                "https://image.tmdb.org/t/p/w500${imageData["file_path"]}")
            .toList();
      } else {
        throw Exception("Faild to load images");
      }
    } catch (er) {
      print("Movie images service error: $er");
      return [];
    }
  }
}
