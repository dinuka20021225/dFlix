import 'package:dmovies/api/movie_service.dart';
import 'package:dmovies/models/movie_model.dart';
import 'package:dmovies/pages/single_movie_details_page.dart';
import 'package:dmovies/styles/app_text_styles.dart';
import 'package:dmovies/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<MovieModel> searchResults = [];
  bool isLoading = false;
  String error = "";

  // method to search movie
  Future<void> searchMovies() async {
    setState(() {
      isLoading = true;
      error = "";
    });
    try {
      List<MovieModel> movies =
          await MovieService().searchMovie(_searchController.text);
      setState(() {
        searchResults = movies;
      });
    } catch (e) {
      print("error:$e");
      setState(() {
        error = "Failed to search that movie";
      });
    } finally {
      isLoading = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Search",
          style: AppTextStyles.title.copyWith(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(8, 158, 255, 1)),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      onSubmitted: (value) {
                        searchMovies();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(8, 158, 255, 1).withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        searchMovies();
                      },
                      icon: Icon(
                        FontAwesomeIcons.magnifyingGlass,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Center(
                  child: isLoading
                      ? Lottie.asset(
                          "assets/loading.json",
                          width: MediaQuery.of(context).size.width * 0.3,
                        )
                      : error.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                error,
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : searchResults.isEmpty
                              ? Text(
                                  "Not Found",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: searchResults.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SingleMovieDetailsPage(
                                              movie: searchResults[index],
                                            ),
                                          ),
                                        );
                                      },
                                      child: MovieCard(
                                          movie: searchResults[index]),
                                    );
                                  },
                                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
