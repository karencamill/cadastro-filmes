import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'database_helper.dart';
import 'movie.dart';

class MovieForm extends StatefulWidget {
  final Movie? movie;
  const MovieForm({super.key, this.movie});

  @override
  State<MovieForm> createState() => _MovieFormState();
}

class _MovieFormState extends State<MovieForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _genreController = TextEditingController();
  final _durationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _yearController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String _ageRating = 'Livre';
  double _rating = 0.0;

  final List<String> _ageRatings = ['Livre', '10', '12', '14', '16', '18'];

  @override
  void initState() {
    super.initState();
    if (widget.movie != null) {
      _titleController.text = widget.movie!.title;
      _genreController.text = widget.movie!.genre;
      _durationController.text = widget.movie!.duration;
      _descriptionController.text = widget.movie!.description;
      _yearController.text = widget.movie!.year;
      _imageUrlController.text = widget.movie!.imageUrl;
      _ageRating = widget.movie!.ageRating;
      _rating = widget.movie!.rating;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _genreController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    _yearController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie == null ? 'Novo Filme' : 'Editar Filme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (value) =>
                      value!.isEmpty ? 'Informe o título' : null,
                ),
                TextFormField(
                  controller: _genreController,
                  decoration: const InputDecoration(labelText: 'Gênero'),
                  validator: (value) =>
                      value!.isEmpty ? 'Informe o gênero' : null,
                ),
                DropdownButtonFormField(
                  value: _ageRating,
                  decoration:
                      const InputDecoration(labelText: 'Faixa Etária'),
                  items: _ageRatings
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _ageRating = value!;
                    });
                  },
                ),
                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(labelText: 'Duração'),
                  validator: (value) =>
                      value!.isEmpty ? 'Informe a duração' : null,
                ),
                TextFormField(
                  controller: _yearController,
                  decoration: const InputDecoration(labelText: 'Ano'),
                  validator: (value) =>
                      value!.isEmpty ? 'Informe o ano' : null,
                ),
                TextFormField(
                  controller: _imageUrlController,
                  decoration:
                      const InputDecoration(labelText: 'URL da Imagem'),
                  validator: (value) =>
                      value!.isEmpty ? 'Informe a URL da imagem' : null,
                ),
                const SizedBox(height: 16),
                const Text('Pontuação'),
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  maxLines: 5,
                  validator: (value) =>
                      value!.isEmpty ? 'Informe a descrição' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final movie = Movie(
                          id: widget.movie?.id,
                          title: _titleController.text,
                          genre: _genreController.text,
                          ageRating: _ageRating,
                          duration: _durationController.text,
                          rating: _rating,
                          description: _descriptionController.text,
                          year: _yearController.text,
                          imageUrl: _imageUrlController.text,
                        );

                        if (widget.movie == null) {
                          await DatabaseHelper.instance.insert(movie);
                        } else {
                          await DatabaseHelper.instance.update(movie);
                        }

                        Navigator.pop(context, true); // <== Volta true para atualizar lista
                      }
                    },
                    child: Text(widget.movie == null ? 'Salvar' : 'Atualizar'))
              ],
            )),
      ),
    );
  }
}
