class Movie {
  final int? id;
  final String title;
  final String genre;
  final String ageRating;
  final String duration;
  final double rating;
  final String description;
  final String year;
  final String imageUrl;

  Movie({
    this.id,
    required this.title,
    required this.genre,
    required this.ageRating,
    required this.duration,
    required this.rating,
    required this.description,
    required this.year,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'ageRating': ageRating,
      'duration': duration,
      'rating': rating,
      'description': description,
      'year': year,
      'imageUrl': imageUrl,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as int?,
      title: map['title'],
      genre: map['genre'],
      ageRating: map['ageRating'],
      duration: map['duration'],
      rating: map['rating'],
      description: map['description'],
      year: map['year'],
      imageUrl: map['imageUrl'],
    );
  }
}
