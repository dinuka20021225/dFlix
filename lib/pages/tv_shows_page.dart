import 'package:dmovies/api/tv_show_service.dart';
import 'package:dmovies/models/tv_show_model.dart';
import 'package:dmovies/styles/app_text_styles.dart';
import 'package:dmovies/widgets/tv_show_card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TvShowsPage extends StatefulWidget {
  const TvShowsPage({super.key});

  @override
  State<TvShowsPage> createState() => _TvShowsPageState();
}

class _TvShowsPageState extends State<TvShowsPage> {
  List<TvShowModel> _tvShows = [];
  bool _isLoading = true;
  String _error = "";

  // fetch tv shows
  Future<void> fetchTVShows() async {
    try {
      List<TvShowModel> tvShows = await TvShowService().fetchTvShows();
      print(tvShows.length);
      setState(() {
        tvShows.shuffle();
        _tvShows = tvShows;
        _isLoading = false;
      });
    } catch (er) {
      print("error: $er");
      setState(() {
        _error = "Faild to load TV Shows";
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTVShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          "TV Shows",
          style: AppTextStyles.title.copyWith(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(8, 158, 255, 1)),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Lottie.asset(
                "assets/loading.json",
                width: MediaQuery.of(context).size.width * 0.3,
              ),
            )
          : _error.isNotEmpty
              ? Center(
                  child: Text(_error),
                )
              : SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: _tvShows.length,
                      itemBuilder: (context, index) {
                        return TvShowCard(tvShow: _tvShows[index]);
                      },
                    ),
                  ),
                ),
    );
  }
}
