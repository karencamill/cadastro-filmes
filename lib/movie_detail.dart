import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'movie.dart';

class MovieDetail extends StatelessWidget {
  final Movie movie;
  const MovieDetail({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Image.network(movie.imageUrl, height: 250, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Text(
              movie.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Gênero: ${movie.genre}'),
            Text('Faixa Etária: ${movie.ageRating}'),
            Text('Duração: ${movie.duration}'),
            Text('Ano: ${movie.year}'),
            const SizedBox(height: 10),
            RatingBarIndicator(
              rating: movie.rating,
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              itemCount: 5,
              itemSize: 30,
            ),
            const SizedBox(height: 20),
            const Text(
              'Descrição',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(movie.description),
          ],
        ),
      ),
    );
  }
}
// TODO Implement this library.
