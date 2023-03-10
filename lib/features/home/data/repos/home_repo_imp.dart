import 'package:dartz/dartz.dart';

import 'package:ebookia/core/errors/failures.dart';
import 'package:ebookia/core/utils/api_servers.dart';
import 'package:ebookia/features/home/data/models/book_model/book_model.dart';
import 'package:ebookia/features/home/data/repos/home_repos.dart';
import 'package:dio/dio.dart';

class HomeRepoImp extends HomeRepo {
  ApiServer apiServer;
  HomeRepoImp({
    required this.apiServer,
  });
  @override
  Future<Either<Failure, List<BookModel>>> fetchNewestBooks() async {
    try {
      var data = await apiServer.get(
          endPoint:
              'volumes?q=subject:Programming&Filtering=free-ebooks&orderBy=newest');
      List<BookModel> books = [];
      for (var item in data['items']) {
        books.add(BookModel.fromJson(item));
      }
      return right(books);
    } catch (e) {
      if (e is DioError) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookModel>>> fetchFeaturesBooks() async {
    try {
      var data = await apiServer.get(
          endPoint: 'volumes?q=subject:Programming&Filtering=free-ebooks');
      List<BookModel> books = [];
      for (var item in data['items']) {
        books.add(BookModel.fromJson(item));
      }
      return right(books);
    } catch (e) {
      if (e is DioError) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookModel>>> fetchSimilarBooks(
      {required String category}) async {
    try {
      var data = await apiServer.get(
          endPoint:
              'volumes?q=subject:$category&Filtering=free-ebooks&orderBy=relevance');
      List<BookModel> books = [];
      for (var item in data['items']) {
        books.add(BookModel.fromJson(item));
      }
      return right(books);
    } catch (e) {
      if (e is DioError) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
