import 'package:dio/dio.dart';
import '../models/models.dart';
import '../services/api_service.dart';

/// Repository for prompt-related API calls.
class PromptsRepository {
  final Dio _dio = ApiService().dio;

  Future<List<Prompt>> getFeed({String? cursor, int limit = 20}) async {
    final resp = await _dio.get('/api/v1/prompts/feed', queryParameters: {
      if (cursor != null) 'cursor': cursor,
      'limit': limit,
    });
    return (resp.data['data'] as List)
        .map((j) => Prompt.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<List<Prompt>> getTrending({
    String? category,
    String? cursor,
    int limit = 20,
  }) async {
    final resp = await _dio.get('/api/v1/prompts/trending', queryParameters: {
      if (category != null) 'category': category,
      if (cursor != null) 'cursor': cursor,
      'limit': limit,
    });
    return (resp.data['data'] as List)
        .map((j) => Prompt.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<Prompt> getPrompt(String id) async {
    final resp = await _dio.get('/api/v1/prompts/$id');
    return Prompt.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<Prompt> createPrompt(Map<String, dynamic> data) async {
    final resp = await _dio.post('/api/v1/prompts', data: data);
    return Prompt.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> toggleEcho(String promptId, bool echo) async {
    if (echo) {
      final resp = await _dio.post('/api/v1/prompts/$promptId/echo');
      return resp.data as Map<String, dynamic>;
    } else {
      final resp = await _dio.delete('/api/v1/prompts/$promptId/echo');
      return resp.data as Map<String, dynamic>;
    }
  }

  Future<Map<String, dynamic>> toggleArchive(
      String promptId, bool archive) async {
    if (archive) {
      final resp = await _dio.post('/api/v1/prompts/$promptId/archive');
      return resp.data as Map<String, dynamic>;
    } else {
      final resp = await _dio.delete('/api/v1/prompts/$promptId/archive');
      return resp.data as Map<String, dynamic>;
    }
  }

  Future<List<Prompt>> getRemixes(String promptId) async {
    final resp = await _dio.get('/api/v1/prompts/$promptId/remixes');
    return (resp.data['data'] as List)
        .map((j) => Prompt.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<List<Prompt>> searchPrompts(
    String q, {
    String? category,
    List<String>? tags,
    String? cursor,
    int limit = 20,
  }) async {
    final resp = await _dio.get('/api/v1/search', queryParameters: {
      'q': q,
      if (category != null) 'category': category,
      if (tags != null && tags.isNotEmpty) 'tags': tags.join(','),
      if (cursor != null) 'cursor': cursor,
      'limit': limit,
    });
    return (resp.data['data'] as List)
        .map((j) => Prompt.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}
