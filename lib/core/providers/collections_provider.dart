import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class CollectionsNotifier extends Notifier<List<PromptCollection>> {
  @override
  List<PromptCollection> build() {
    return List.from(MockData.collections);
  }

  void createCollection(String name, String? description, {Color? coverColor}) {
    final col = PromptCollection(
      id: 'col-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
      ownerId: MockData.currentUser.id,
      promptIds: const [],
      promptCount: 0,
      createdAt: DateTime.now(),
      coverColor: coverColor ?? const Color(0xFF5A6B8B),
    );
    state = [...state, col];
  }

  void togglePromptInCollection(String collectionId, String promptId) {
    state = [
      for (final col in state)
        if (col.id == collectionId)
          _togglePrompt(col, promptId)
        else
          col
    ];
  }

  PromptCollection _togglePrompt(PromptCollection col, String promptId) {
    final list = List<String>.from(col.promptIds);
    if (list.contains(promptId)) {
      list.remove(promptId);
    } else {
      list.add(promptId);
    }
    return PromptCollection(
      id: col.id,
      name: col.name,
      description: col.description,
      ownerId: col.ownerId,
      promptIds: list,
      promptCount: list.length,
      createdAt: col.createdAt,
      coverColor: col.coverColor,
      isPublic: col.isPublic,
    );
  }
}

final collectionsProvider =
    NotifierProvider<CollectionsNotifier, List<PromptCollection>>(() {
  return CollectionsNotifier();
});
