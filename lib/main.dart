import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/widgets/movieswidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Movie> _movies = new List<Movie>();

  bool isloading = true;

  @override
  void initState(){
    super.initState();
    _populateAllMovies();
    isloading = false;
  }

  void _populateAllMovies() async{
    final movies = await _fetchAllMovies();
    setState(() {
      _movies= movies;
    });
  }


  Future<List<Movie>> _fetchAllMovies() async{

    final response = await http.get(Uri.parse("http://www.omdbapi.com/?s=Batman&page=2&apikey=1ee89786"));

    if(response.statusCode==200){
      final result = jsonDecode(response.body);
      Iterable list = result["Search"];
      return list.map((movie) => Movie.fromJson(movie)).toList();
    }
    else {
        throw Exception("Failed to load movies");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movies"),
      ),
      body: Center(child: isloading?CircularProgressIndicator(): MoviesWidget(movies: _movies)),
    );
  }
}
