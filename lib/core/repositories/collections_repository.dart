import 'package:dio/dio.dart';
import '../models/models.dart';
import '../services/api_service.dart';

/// Repository for collection-related API calls.
class CollectionsRepository {
  final Dio _dio = ApiService().dio;

  Future<List<PromptCollection>> getMyCollections() async {
    final resp = await _dio.get('/api/v1/collections');
    return (resp.data as List)
        .map((j) => PromptCollection.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<PromptCollection> createCollection(
    String name,
    String? description, {
    String? coverColor,
    bool isPublic = true,
  }) async {
    final resp = await _dio.post('/api/v1/collections', data: {
      'name': name,
      'description': description,
      if (coverColor != null) 'cover_color': coverColor,
      'is_public': isPublic,
    });
    return PromptCollection.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<PromptCollection> addPromptToCollection(
      String collectionId, String promptId) async {
    final resp = await _dio
        .post('/api/v1/collections/$collectionId/prompts/$promptId');
    return PromptCollection.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<PromptCollection> removePromptFromCollection(
      String collectionId, String promptId) async {
    final resp = await _dio
        .delete('/api/v1/collections/$collectionId/prompts/$promptId');
    return PromptCollection.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<void> deleteCollection(String collectionId) async {
    await _dio.delete('/api/v1/collections/$collectionId');
  }
}
