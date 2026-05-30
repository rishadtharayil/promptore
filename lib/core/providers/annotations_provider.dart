import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../repositories/annotations_repository.dart';

class AnnotationsNotifier extends Notifier<List<Annotation>> {
  final _repo = AnnotationsRepository();

  @override
  List<Annotation> build() {
    return const [];
  }

  Future<void> loadAnnotations(String promptId) async {
    try {
      final annotations = await _repo.getAnnotations(promptId);
      state = annotations;
    } catch (_) {}
  }

  void addAnnotation(String promptId, String content) {
    _addAnnotationToServer(promptId, content);
  }

  Future<void> _addAnnotationToServer(
      String promptId, String content) async {
    try {
      final ann = await _repo.addAnnotation(promptId, content);
      state = [...state, ann];
    } catch (_) {}
  }
}

final annotationsProvider =
    NotifierProvider<AnnotationsNotifier, List<Annotation>>(() {
  return AnnotationsNotifier();
});
