import 'package:dio/dio.dart';
import '../models/models.dart';
import '../services/api_service.dart';

/// Repository for annotation-related API calls.
class AnnotationsRepository {
  final Dio _dio = ApiService().dio;

  Future<List<Annotation>> getAnnotations(String promptId) async {
    final resp =
        await _dio.get('/api/v1/prompts/$promptId/annotations');
    return (resp.data as List)
        .map((j) => Annotation.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<Annotation> addAnnotation(String promptId, String content) async {
    final resp = await _dio.post(
      '/api/v1/prompts/$promptId/annotations',
      data: {'content': content},
    );
    return Annotation.fromJson(resp.data as Map<String, dynamic>);
  }
}
