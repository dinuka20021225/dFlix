import 'package:dmovies/models/movie_model.dart';
import 'package:dmovies/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  const MovieCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromRGBO(19, 213, 255, 0.1),
      ),
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (movie.poster_path == null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "https://igpa.uillinois.edu/wp-content/themes/igpa/dist/img/backgrounds/no_image.png",
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "https://image.tmdb.org/t/p/w500/${movie.poster_path}",
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(
              height: 10,
            ),
            Text(
              movie.title,
              style: AppTextStyles.title,
            ),
            SizedBox(
              height: 10,
            ),
            Text("Release date: ${movie.release_date}"),
            SizedBox(
              height: 10,
            ),
            Text(
              movie.overview,
              style: AppTextStyles.body,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Average vote: ${movie.vote_average}",
                  style: AppTextStyles.subtitle,
                ),
                Text(
                  "Popularity: ${movie.popularity}",
                  style: AppTextStyles.subtitle,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
