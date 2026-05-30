import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../repositories/prompts_repository.dart';

class PromptsNotifier extends Notifier<List<Prompt>> {
  final _repo = PromptsRepository();

  @override
  List<Prompt> build() {
    _init();
    return const [];
  }

  Future<void> _init() async {
    try {
      final prompts = await _repo.getFeed();
      state = prompts;
    } catch (e) {
      // Keep empty state on error
    }
  }

  Future<void> refreshFeed() async {
    try {
      final prompts = await _repo.getFeed();
      state = prompts;
    } catch (_) {}
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
    final isNowEchoed = state.firstWhere((p) => p.id == id).isEchoed;
    _syncEcho(id, isNowEchoed);
  }

  Future<void> _syncEcho(String id, bool echoed) async {
    try {
      await _repo.toggleEcho(id, echoed);
    } catch (_) {
      // Revert optimistic update on failure
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
    final isNowArchived = state.firstWhere((p) => p.id == id).isArchived;
    _syncArchive(id, isNowArchived);
  }

  Future<void> _syncArchive(String id, bool archived) async {
    try {
      await _repo.toggleArchive(id, archived);
    } catch (_) {
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
  }

  void addPrompt(Prompt prompt) {
    state = [prompt, ...state];
  }

  Future<Prompt?> createPromptOnServer(Map<String, dynamic> data) async {
    try {
      final prompt = await _repo.createPrompt(data);
      state = [prompt, ...state];
      return prompt;
    } catch (_) {
      return null;
    }
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
