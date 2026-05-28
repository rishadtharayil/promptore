import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// Prompt size classification
enum PromptSize {
  short('Short', '< 200 words'),
  medium('Medium', '200-500 words'),
  long('Long', '500-1000 words'),
  epic('Epic', '1000+ words');

  const PromptSize(this.label, this.description);
  final String label;
  final String description;
}

/// All prompt categories with visual identity
enum PromptCategory {
  character('Character Prompts', PromptoreColors.categoryCharacter, '✦'),
  image('Image Prompts', PromptoreColors.categoryImage, '◐'),
  coding('Coding Prompts', PromptoreColors.categoryCoding, '⟨⟩'),
  philosophy('Philosophy', PromptoreColors.categoryPhilosophy, '∞'),
  storytelling('Storytelling', PromptoreColors.categoryStorytelling, '❧'),
  simulation('Simulation', PromptoreColors.categorySimulation, '◈'),
  productivity('Productivity', PromptoreColors.categoryProductivity, '▣'),
  experimental('Experimental', PromptoreColors.categoryExperimental, '⌬'),
  worldbuilding('Worldbuilding', PromptoreColors.categoryWorldbuilding, '◉'),
  emotional('Emotional', PromptoreColors.categoryEmotional, '◇'),
  strangeInternet('Strange Internet', PromptoreColors.categoryStrangeInternet, '⌘'),
  psychological('Psychological', PromptoreColors.categoryPsychological, '⊛'),
  other('Other', PromptoreColors.categoryOther, '•');

  const PromptCategory(this.label, this.color, this.symbol);
  final String label;
  final Color color;
  final String symbol;
}

/// A prompt — the core content unit of PROMPTORE.
/// Treated as a creative artifact, thought experiment, or intellectual creation.
class Prompt {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String authorId;
  final String authorName;
  final String authorHandle;
  final String? authorAvatarUrl;
  final PromptCategory category;
  final List<String> tags;
  final int echoCount;
  final int archiveCount;
  final int remixCount;
  final int annotationCount;
  final String? remixOfId;
  final String? remixOfTitle;
  final String? thumbnailUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final PromptSize size;
  final double impactScore;
  bool isEchoed;
  bool isArchived;

  Prompt({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.authorHandle,
    this.authorAvatarUrl,
    required this.category,
    this.tags = const [],
    this.echoCount = 0,
    this.archiveCount = 0,
    this.remixCount = 0,
    this.annotationCount = 0,
    this.remixOfId,
    this.remixOfTitle,
    this.thumbnailUrl,
    required this.createdAt,
    this.updatedAt,
    this.size = PromptSize.medium,
    this.impactScore = 0.5,
    this.isEchoed = false,
    this.isArchived = false,
  });

  Prompt copyWith({
    bool? isEchoed,
    bool? isArchived,
    int? echoCount,
    int? archiveCount,
  }) {
    return Prompt(
      id: id,
      title: title,
      excerpt: excerpt,
      content: content,
      authorId: authorId,
      authorName: authorName,
      authorHandle: authorHandle,
      authorAvatarUrl: authorAvatarUrl,
      category: category,
      tags: tags,
      echoCount: echoCount ?? this.echoCount,
      archiveCount: archiveCount ?? this.archiveCount,
      remixCount: remixCount,
      annotationCount: annotationCount,
      remixOfId: remixOfId,
      remixOfTitle: remixOfTitle,
      thumbnailUrl: thumbnailUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      size: size,
      impactScore: impactScore,
      isEchoed: isEchoed ?? this.isEchoed,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}

/// A user's collection — a curated library of prompts
class PromptCollection {
  final String id;
  final String name;
  final String? description;
  final String ownerId;
  final List<String> promptIds;
  final int promptCount;
  final DateTime createdAt;
  final Color? coverColor;
  final bool isPublic;

  const PromptCollection({
    required this.id,
    required this.name,
    this.description,
    required this.ownerId,
    this.promptIds = const [],
    this.promptCount = 0,
    required this.createdAt,
    this.coverColor,
    this.isPublic = true,
  });
}

/// User profile — a personal archive and creative identity
class UserProfile {
  final String id;
  final String displayName;
  final String handle;
  final String? bio;
  final String? avatarUrl;
  final int promptCount;
  final int echoesReceived;
  final int collectionsCount;
  final int tunedInCount;
  final int tuningInToCount;
  final DateTime joinedAt;
  final String? mood;
  final List<String> pinnedPromptIds;
  bool isTunedIn;

  UserProfile({
    required this.id,
    required this.displayName,
    required this.handle,
    this.bio,
    this.avatarUrl,
    this.promptCount = 0,
    this.echoesReceived = 0,
    this.collectionsCount = 0,
    this.tunedInCount = 0,
    this.tuningInToCount = 0,
    required this.joinedAt,
    this.mood,
    this.pinnedPromptIds = const [],
    this.isTunedIn = false,
  });
}

/// Annotation on a prompt — margin notes, thoughts
class Annotation {
  final String id;
  final String promptId;
  final String authorId;
  final String authorName;
  final String authorHandle;
  final String content;
  final DateTime createdAt;

  const Annotation({
    required this.id,
    required this.promptId,
    required this.authorId,
    required this.authorName,
    required this.authorHandle,
    required this.content,
    required this.createdAt,
  });
}
