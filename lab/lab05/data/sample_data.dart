import '../models/movie.dart';
import '../models/trailer.dart';

final List<Movie> sampleMovies = [
  Movie(
    id: 1,
    title: 'Inception',
    posterUrl: 'https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Ber.jpg',
    overview: 'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.',
    genres: ['Action', 'Sci-Fi', 'Thriller'],
    rating: 8.8,
    releaseDate: '2010-07-16',
    duration: '2h 28m',
    trailers: [
      Trailer(id: '1', title: 'Official Trailer', thumbnailUrl: '', duration: '2:28'),
      Trailer(id: '2', title: 'Behind the Scenes', thumbnailUrl: '', duration: '5:12'),
    ],
  ),
  Movie(
    id: 2,
    title: 'The Dark Knight',
    posterUrl: 'https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
    overview: 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests.',
    genres: ['Action', 'Crime', 'Drama'],
    rating: 9.0,
    releaseDate: '2008-07-18',
    duration: '2h 32m',
    trailers: [
      Trailer(id: '1', title: 'Official Trailer', thumbnailUrl: '', duration: '2:31'),
    ],
  ),
  Movie(
    id: 3,
    title: 'Interstellar',
    posterUrl: 'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
    overview: 'A team of explorers travel through a wormhole in space in an attempt to ensure humanity survival.',
    genres: ['Adventure', 'Drama', 'Sci-Fi'],
    rating: 8.7,
    releaseDate: '2014-11-07',
    duration: '2h 49m',
    trailers: [
      Trailer(id: '1', title: 'Official Trailer', thumbnailUrl: '', duration: '2:45'),
    ],
  ),
  Movie(
    id: 4,
    title: 'The Matrix',
    posterUrl: 'https://image.tmdb.org/t/p/w500/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg',
    overview: 'A computer programmer discovers that reality as he knows it is a simulation created by machines.',
    genres: ['Action', 'Sci-Fi'],
    rating: 8.7,
    releaseDate: '1999-03-31',
    duration: '2h 16m',
    trailers: [
      Trailer(id: '1', title: 'Official Trailer', thumbnailUrl: '', duration: '2:20'),
    ],
  ),
  Movie(
    id: 5,
    title: 'Pulp Fiction',
    posterUrl: 'https://image.tmdb.org/t/p/w500/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg',
    overview: 'The lives of two mob hitmen, a boxer, a gangster and his wife intertwine in four tales of violence.',
    genres: ['Crime', 'Drama'],
    rating: 8.9,
    releaseDate: '1994-10-14',
    duration: '2h 34m',
    trailers: [
      Trailer(id: '1', title: 'Official Trailer', thumbnailUrl: '', duration: '2:33'),
    ],
  ),
];