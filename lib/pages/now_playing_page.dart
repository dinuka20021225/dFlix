import 'package:dmovies/api/movie_service.dart';
import 'package:dmovies/models/movie_model.dart';
import 'package:dmovies/pages/single_movie_details_page.dart';
import 'package:dmovies/styles/app_text_styles.dart';
import 'package:dmovies/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  List<MovieModel> movies = [];
  int currentPage = 1;
  int totalPages = 1;
  bool isloading = false;

  Future<void> fetchMovies() async {
    setState(() {
      isloading = true;
    });
    try {
      List<MovieModel> fetchedMovies =
          await MovieService().fetchNowPlayingMovies(page: currentPage);
      setState(() {
        movies = fetchedMovies;
        totalPages = 100;
      });
    } catch (error) {
      print("movie fetch error: $error");
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  // previus button
  void previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      fetchMovies();
    }
  }

  // next page
  void nextPage() {
    if (currentPage < totalPages) {
      setState(() {
        currentPage++;
      });
      fetchMovies();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Now Playing",
          style: AppTextStyles.title.copyWith(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(8, 158, 255, 1)),
        ),
      ),
      body: isloading
          ? Center(
              child: Lottie.asset(
                "assets/loading.json",
                width: MediaQuery.of(context).size.width * 0.3,
              ),
            )
          : Column(
              children: [
                Expanded(
                    child: ListView.builder(
                  itemCount: movies.length + 1,
                  itemBuilder: (context, index) {
                    if (index > movies.length - 1) {
                      return buildPlaginationControls();
                    } else {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingleMovieDetailsPage(
                                movie: movies[index],
                              ),
                            ),
                          );
                        },
                        child: MovieCard(
                          movie: movies[index],
                        ),
                      );
                    }
                  },
                ))
              ],
            ),
    );
  }

  Widget buildPlaginationControls() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: currentPage > 1 ? previousPage : null,
            child: Text("Previous", style: AppTextStyles.subtitle),
          ),
          SizedBox(width: 8),
          Text("Page $currentPage of $totalPages"),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: currentPage < totalPages ? nextPage : null,
            child: Text("Next", style: AppTextStyles.subtitle),
          ),
        ],
      ),
    );
  }
}
