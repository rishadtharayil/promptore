import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class AnnotationsNotifier extends Notifier<List<Annotation>> {
  @override
  List<Annotation> build() {
    return List.from(MockData.annotations);
  }

  void addAnnotation(String promptId, String content) {
    final user = MockData.currentUser;
    final ann = Annotation(
      id: 'ann-${DateTime.now().millisecondsSinceEpoch}',
      promptId: promptId,
      authorId: user.id,
      authorName: user.displayName,
      authorHandle: user.handle,
      content: content,
      createdAt: DateTime.now(),
    );
    state = [...state, ann];
  }
}

final annotationsProvider =
    NotifierProvider<AnnotationsNotifier, List<Annotation>>(() {
  return AnnotationsNotifier();
});
