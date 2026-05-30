import 'package:dio/dio.dart';
import '../models/models.dart';
import '../services/api_service.dart';

/// Repository for user-related API calls.
class UsersRepository {
  final Dio _dio = ApiService().dio;

  Future<UserProfile> getMe() async {
    final resp = await _dio.get('/api/v1/users/me');
    return UserProfile.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<UserProfile> getUser(String userId) async {
    final resp = await _dio.get('/api/v1/users/$userId');
    return UserProfile.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<UserProfile> updateMe(Map<String, dynamic> data) async {
    final resp = await _dio.put('/api/v1/users/me', data: data);
    return UserProfile.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> toggleFollow(
      String userId, bool follow) async {
    if (follow) {
      final resp = await _dio.post('/api/v1/users/$userId/follow');
      return resp.data as Map<String, dynamic>;
    } else {
      final resp = await _dio.delete('/api/v1/users/$userId/follow');
      return resp.data as Map<String, dynamic>;
    }
  }

  Future<List<Prompt>> getUserPrompts(String userId,
      {String? cursor, int limit = 20}) async {
    final resp =
        await _dio.get('/api/v1/users/$userId/prompts', queryParameters: {
      if (cursor != null) 'cursor': cursor,
      'limit': limit,
    });
    return (resp.data['data'] as List)
        .map((j) => Prompt.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}
