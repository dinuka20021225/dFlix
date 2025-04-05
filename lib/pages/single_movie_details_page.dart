import 'package:dmovies/api/movie_service.dart';
import 'package:dmovies/models/movie_model.dart';
import 'package:dmovies/styles/app_text_styles.dart';
import 'package:dmovies/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SingleMovieDetailsPage extends StatefulWidget {
  MovieModel movie;
  SingleMovieDetailsPage({
    super.key,
    required this.movie,
  });

  @override
  State<SingleMovieDetailsPage> createState() => _SingleMovieDetailsPageState();
}

class _SingleMovieDetailsPageState extends State<SingleMovieDetailsPage> {
  List<MovieModel> _similorMovies = [];
  List<MovieModel> _recomndedMovies = [];
  List<String> _movieImages = [];

  bool _isLoadingSimilor = true;
  bool _isLoadingRecomded = true;
  bool _isLoadingMovieImages = true;

  // fetching similor movies
  Future<void> fetchSimilorMovies() async {
    try {
      List<MovieModel> fetchMovies =
          await MovieService().similorMovies(widget.movie.id);
      setState(() {
        _similorMovies = fetchMovies;
        _isLoadingSimilor = false;
      });
    } catch (er) {
      print("error from similor: $er");
      setState(() {
        _isLoadingSimilor = false;
      });
    }
  }

  // fetching recomnded movies
  Future<void> fetchRecomdedMovies() async {
    try {
      List<MovieModel> fetchMovies =
          await MovieService().recomondedMovies(widget.movie.id);
      setState(() {
        _recomndedMovies = fetchMovies;
        _isLoadingRecomded = false;
      });
    } catch (er) {
      print("error from recomonded: $er");
      setState(() {
        _isLoadingRecomded = false;
      });
    }
  }

  // fetching movies images
  Future<void> fetchMoviesImages() async {
    try {
      List<String> fetchMoviesImages =
          await MovieService().movieImages(widget.movie.id);
      setState(() {
        _movieImages = fetchMoviesImages;
        _isLoadingMovieImages = false;
      });
    } catch (er) {
      print("error from movie images: $er");
      setState(() {
        _isLoadingMovieImages = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSimilorMovies();
    fetchRecomdedMovies();
    fetchMoviesImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          "${widget.movie.title}",
          style: AppTextStyles.title.copyWith(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(8, 158, 255, 1)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MovieCard(
                  movie: widget.movie,
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Movie images",
                  style: AppTextStyles.subtitle.copyWith(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                _buildImageSection(),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Similor Movies",
                  style: AppTextStyles.subtitle.copyWith(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                _buildSimilorMovies(),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Recomnded Movies",
                  style: AppTextStyles.subtitle.copyWith(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                _buildRecomondedMovies(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// image
  Widget _buildImageSection() {
    if (_isLoadingMovieImages) {
      return Center(
        child: Lottie.asset(
          "assets/loading.json",
          width: MediaQuery.of(context).size.width * 0.3,
        ),
      );
    } else if (_movieImages.isEmpty) {
      return Center(
        child: Text(
          "No Image Found",
        ),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _movieImages.length,
          itemBuilder: (context, index) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.all(0),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.transparent,
                      content: Image.network(
                        _movieImages[index],
                        width: MediaQuery.of(context).size.width * 10,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              },
              child: Container(
                margin: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    _movieImages[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  // Similor movies
  Widget _buildSimilorMovies() {
    if (_isLoadingSimilor) {
      return Center(
        child: Lottie.asset(
          "assets/loading.json",
          width: MediaQuery.of(context).size.width * 0.3,
        ),
      );
    } else if (_similorMovies.isEmpty) {
      return Center(
        child: Text(
          "No Similar Movies Found",
          style: TextStyle(fontSize: 16),
        ),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _similorMovies.length,
          itemBuilder: (context, index) {
            if (index >= _similorMovies.length)
              return SizedBox(); // Fixed range issue
            return GestureDetector(
              onTap: () {
                setState(() {
                  widget.movie = _similorMovies[index];
                  _buildImageSection();
                  fetchSimilorMovies();
                  fetchRecomdedMovies();
                  fetchMoviesImages();
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(19, 213, 255, 0.1),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _similorMovies[index].poster_path == null
                              ? "https://igpa.uillinois.edu/wp-content/themes/igpa/dist/img/backgrounds/no_image.png"
                              : "https://image.tmdb.org/t/p/w500/${_similorMovies[index].poster_path}",
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _similorMovies[index].title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Average votes: ${_similorMovies[index].vote_average}",
                        style: AppTextStyles.subtitle,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  // Recomnded movies
  Widget _buildRecomondedMovies() {
    if (_isLoadingRecomded) {
      return Center(
        child: Lottie.asset(
          "assets/loading.json",
          width: MediaQuery.of(context).size.width * 0.3,
        ),
      );
    } else if (_recomndedMovies.isEmpty) {
      return Center(
        child: Text(
          "No Recomnded Movies Found",
          style: TextStyle(fontSize: 16),
        ),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _recomndedMovies.length,
          itemBuilder: (context, index) {
            if (index >= _recomndedMovies.length)
              return SizedBox(); // Fixed range issue
            return GestureDetector(
              onTap: () {
                setState(() {
                  widget.movie = _recomndedMovies[index];
                  _buildImageSection();
                  fetchSimilorMovies();
                  fetchRecomdedMovies();
                  fetchMoviesImages();
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(19, 213, 255, 0.1),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _recomndedMovies[index].poster_path == null
                              ? "https://igpa.uillinois.edu/wp-content/themes/igpa/dist/img/backgrounds/no_image.png"
                              : "https://image.tmdb.org/t/p/w500/${_recomndedMovies[index].poster_path}",
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _recomndedMovies[index].title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Average votes: ${_recomndedMovies[index].vote_average}",
                        style: AppTextStyles.subtitle,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
