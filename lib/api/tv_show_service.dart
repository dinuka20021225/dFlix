import 'dart:convert';
import 'package:dmovies/models/tv_show_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // For debugPrint

class TvShowService {
  final String? _apiKey = dotenv.maybeGet("TMDB_KEY");

  Future<List<TvShowModel>> fetchTvShows() async {
    if (_apiKey == null) {
      throw Exception("API key is missing. Please check your .env file.");
    }

    try {
      // Popular TV shows
      final popularResponse = await http.get(
        Uri.parse("https://api.themoviedb.org/3/tv/popular?api_key=$_apiKey"),
      );

      // Airing today
      final airingTodayResponse = await http.get(
        Uri.parse(
            "https://api.themoviedb.org/3/tv/airing_today?api_key=$_apiKey"),
      );

      // Top-rated TV shows
      final topRatedResponse = await http.get(
        Uri.parse("https://api.themoviedb.org/3/tv/top_rated?api_key=$_apiKey"),
      );

      if (popularResponse.statusCode == 200 &&
          airingTodayResponse.statusCode == 200 &&
          topRatedResponse.statusCode == 200) {
        final popularData = json.decode(popularResponse.body);
        final airingTodayData = json.decode(airingTodayResponse.body);
        final topRatedData = json.decode(topRatedResponse.body);

        final List<dynamic> popularResults = popularData["results"];
        final List<dynamic> airingTodayResults = airingTodayData["results"];
        final List<dynamic> topRatedResults = topRatedData["results"];

        List<TvShowModel> tvShows = [];
        tvShows.addAll(popularResults
            .map((tvData) => TvShowModel.fromJson(tvData))
            .take(10));
        tvShows.addAll(airingTodayResults
            .map((tvData) => TvShowModel.fromJson(tvData))
            .take(10));
        tvShows.addAll(topRatedResults
            .map((tvData) => TvShowModel.fromJson(tvData))
            .take(10));

        return tvShows;
      } else {
        throw Exception("Failed to load TV shows");
      }
    } catch (error) {
      debugPrint("Error fetching TV shows: $error");
      return [];
    }
  }
}
