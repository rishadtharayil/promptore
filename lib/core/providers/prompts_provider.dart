import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class PromptsNotifier extends Notifier<List<Prompt>> {
  @override
  List<Prompt> build() {
    // Start with a copy of mock data prompts
    return List.from(MockData.prompts);
  }

  void toggleEcho(String id) {
    state = [
      for (final p in state)
        if (p.id == id)
          p.copyWith(
            isEchoed: !p.isEchoed,
            echoCount: p.echoCount + (p.isEchoed ? -1 : 1),
          )
        else
          p
    ];
  }

  void toggleArchive(String id) {
    state = [
      for (final p in state)
        if (p.id == id)
          p.copyWith(
            isArchived: !p.isArchived,
            archiveCount: p.archiveCount + (p.isArchived ? -1 : 1),
          )
        else
          p
    ];
  }

  void addPrompt(Prompt prompt) {
    state = [prompt, ...state];
  }

  void incrementRemixCount(String originalId) {
    state = [
      for (final p in state)
        if (p.id == originalId)
          Prompt(
            id: p.id,
            title: p.title,
            excerpt: p.excerpt,
            content: p.content,
            authorId: p.authorId,
            authorName: p.authorName,
            authorHandle: p.authorHandle,
            authorAvatarUrl: p.authorAvatarUrl,
            category: p.category,
            tags: p.tags,
            echoCount: p.echoCount,
            archiveCount: p.archiveCount,
            remixCount: p.remixCount + 1,
            annotationCount: p.annotationCount,
            remixOfId: p.remixOfId,
            remixOfTitle: p.remixOfTitle,
            thumbnailUrl: p.thumbnailUrl,
            createdAt: p.createdAt,
            updatedAt: p.updatedAt,
            size: p.size,
            impactScore: p.impactScore,
            isEchoed: p.isEchoed,
            isArchived: p.isArchived,
          )
        else
          p
    ];
  }

  void incrementAnnotationCount(String promptId) {
    state = [
      for (final p in state)
        if (p.id == promptId)
          Prompt(
            id: p.id,
            title: p.title,
            excerpt: p.excerpt,
            content: p.content,
            authorId: p.authorId,
            authorName: p.authorName,
            authorHandle: p.authorHandle,
            authorAvatarUrl: p.authorAvatarUrl,
            category: p.category,
            tags: p.tags,
            echoCount: p.echoCount,
            archiveCount: p.archiveCount,
            remixCount: p.remixCount,
            annotationCount: p.annotationCount + 1,
            remixOfId: p.remixOfId,
            remixOfTitle: p.remixOfTitle,
            thumbnailUrl: p.thumbnailUrl,
            createdAt: p.createdAt,
            updatedAt: p.updatedAt,
            size: p.size,
            impactScore: p.impactScore,
            isEchoed: p.isEchoed,
            isArchived: p.isArchived,
          )
        else
          p
    ];
  }
}

final promptsProvider = NotifierProvider<PromptsNotifier, List<Prompt>>(() {
  return PromptsNotifier();
});
