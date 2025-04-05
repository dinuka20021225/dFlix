import 'package:dmovies/models/tv_show_model.dart';
import 'package:dmovies/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class TvShowCard extends StatelessWidget {
  final TvShowModel tvShow;
  const TvShowCard({
    super.key,
    required this.tvShow,
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
            if (tvShow.poster_path == null)
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
                  "https://image.tmdb.org/t/p/w500/${tvShow.poster_path}",
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(
              height: 10,
            ),
            Text(
              tvShow.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "First air date: ${tvShow.first_air_date}",
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              tvShow.overview,
              style: AppTextStyles.body,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Rating: ${tvShow.vote_average}",
              style: AppTextStyles.subtitle,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
