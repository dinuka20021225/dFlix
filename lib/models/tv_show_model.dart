class TvShowModel {
  final int id;
  final String name;
  final String? poster_path;
  final String overview;
  final bool adult;
  final List<int> genre_ids;
  final double vote_average;
  final String first_air_date;
  final String? original_language;

  TvShowModel({
    required this.id,
    required this.name,
    this.poster_path,
    required this.overview,
    required this.adult,
    required this.genre_ids,
    required this.vote_average,
    required this.first_air_date,
    this.original_language,
  });

  factory TvShowModel.fromJson(Map<String, dynamic> json) {
    return TvShowModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      poster_path: json['poster_path'] as String?,
      overview: json['overview'] ?? "",
      adult: json['adult'] ?? false,
      genre_ids: List<int>.from(json['genre_ids']),
      vote_average: (json['vote_average'] ?? 0).toDouble(),
      first_air_date: json['first_air_date'] ?? "",
      original_language: json['original_language'] ?? "",
    );
  }
}
