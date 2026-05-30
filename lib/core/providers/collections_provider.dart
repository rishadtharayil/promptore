import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../repositories/collections_repository.dart';

class CollectionsNotifier extends Notifier<List<PromptCollection>> {
  final _repo = CollectionsRepository();

  @override
  List<PromptCollection> build() {
    _init();
    return const [];
  }

  Future<void> _init() async {
    try {
      final collections = await _repo.getMyCollections();
      state = collections;
    } catch (_) {}
  }

  Future<void> refreshCollections() async {
    try {
      final collections = await _repo.getMyCollections();
      state = collections;
    } catch (_) {}
  }

  void createCollection(String name, String? description,
      {Color? coverColor}) {
    final hexColor = coverColor != null
        ? '#${coverColor.value.toRadixString(16).substring(2).toUpperCase()}'
        : '#5A6B8B';
    _createCollectionOnServer(name, description, hexColor);
  }

  Future<void> _createCollectionOnServer(
      String name, String? description, String coverColor) async {
    try {
      final col =
          await _repo.createCollection(name, description, coverColor: coverColor);
      state = [...state, col];
    } catch (_) {}
  }

  void togglePromptInCollection(String collectionId, String promptId) {
    // Optimistic update
    state = [
      for (final col in state)
        if (col.id == collectionId) _togglePrompt(col, promptId) else col
    ];
    // Sync to backend
    final col = state.firstWhere((c) => c.id == collectionId);
    final added = col.promptIds.contains(promptId);
    _syncTogglePrompt(collectionId, promptId, added);
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

  Future<void> _syncTogglePrompt(
      String collectionId, String promptId, bool added) async {
    try {
      if (added) {
        await _repo.addPromptToCollection(collectionId, promptId);
      } else {
        await _repo.removePromptFromCollection(collectionId, promptId);
      }
    } catch (_) {
      // Revert
      state = [
        for (final col in state)
          if (col.id == collectionId) _togglePrompt(col, promptId) else col
      ];
    }
  }
}

final collectionsProvider =
    NotifierProvider<CollectionsNotifier, List<PromptCollection>>(() {
  return CollectionsNotifier();
});
