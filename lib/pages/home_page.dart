import 'package:dmovies/api/movie_service.dart';
import 'package:dmovies/models/movie_model.dart';
import 'package:dmovies/pages/single_movie_details_page.dart';
import 'package:dmovies/providers/theme_provider.dart';
import 'package:dmovies/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MovieModel> _movies = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  // init state
  Future<void> _fetchMovies() async {
    if (_isLoading || !_hasMore) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    try {
      final newMovie =
          await MovieService().fetchUpcommingMovies(page: _currentPage);
      print(newMovie.length);
      setState(() {
        if (newMovie.isEmpty) {
          _hasMore = false;
        } else {
          newMovie.shuffle();
          _movies.addAll(newMovie);
          _currentPage++;
        }
      });
    } catch (eror) {
      print("Error:$eror");
    } finally {
      _isLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: GradientText(
          "dFlix",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          colors: [
            Color.fromRGBO(8, 158, 255, 1),
            Color.fromRGBO(19, 213, 255, 1)
          ],
        ),
        actions: [
          IconButton(
            onPressed: themeProvider.toggleTheme,
            icon: Icon(themeProvider.themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
        ],
      ),
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (!_isLoading &&
                notification.metrics.pixels ==
                    notification.metrics.maxScrollExtent) {
              _fetchMovies();
            }
            return true;
          },
          child: ListView.builder(
            itemCount: _movies.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _movies.length) {
                return Center(
                  child: Lottie.asset(
                    "assets/loading.json",
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                );
              }
              final MovieModel movie = _movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SingleMovieDetailsPage(movie: movie),
                    ),
                  );
                },
                child: MovieCard(
                  movie: movie,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
