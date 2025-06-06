import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'movie.dart';
import 'movie_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Filmes',
      debugShowCheckedModeBanner: false,
      home: const MovieListScreen(),
    );
  }
}

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  List<Movie> _movies = [];

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final movies = await DatabaseHelper.instance.getAllMovies();
    setState(() {
      _movies = movies;
    });
  }

  Future<void> _deleteMovie(int id) async {
    await DatabaseHelper.instance.delete(id);
    _loadMovies();
  }

  Future<void> _openMovieForm([Movie? movie]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieForm(movie: movie)),
    );

    if (result == true) {
      _loadMovies();
    }
  }

  void _showOptions(Movie movie) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Exibir Dados'),
              onTap: () {
                Navigator.pop(context);
                _showMovieDetails(movie);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Alterar'),
              onTap: () {
                Navigator.pop(context);
                _openMovieForm(movie);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMovieDetails(Movie movie) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(movie.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(movie.imageUrl, height: 150),
              const SizedBox(height: 8),
              Text('Gênero: ${movie.genre}'),
              Text('Faixa Etária: ${movie.ageRating} anos'),
              Text('Duração: ${movie.duration}'),
              Text('Ano: ${movie.year}'),
              Text('Pontuação: ${movie.rating}'),
              const SizedBox(height: 8),
              Text(movie.description),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Filmes'),
      ),
      body: ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          final movie = _movies[index];
          return Dismissible(
            key: ValueKey(movie.id),
            direction: DismissDirection.startToEnd,
            background: Container(
              color: Colors.red,
              padding: const EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              _deleteMovie(movie.id!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Filme "${movie.title}" deletado')),
              );
            },
            child: ListTile(
              leading: Image.network(movie.imageUrl, width: 50, fit: BoxFit.cover),
              title: Text(movie.title),
              subtitle: Text('${movie.genre} | ${movie.ageRating} anos'),
              onTap: () => _showOptions(movie),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openMovieForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
