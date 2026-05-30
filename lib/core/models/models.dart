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

  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      id: json['id'] as String,
      title: json['title'] as String,
      excerpt: json['excerpt'] as String,
      content: json['content'] as String,
      authorId: json['author_id'] as String,
      authorName: json['author_name'] as String,
      authorHandle: json['author_handle'] as String,
      authorAvatarUrl: json['author_avatar_url'] as String?,
      category: PromptCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => PromptCategory.other,
      ),
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      echoCount: json['echo_count'] as int? ?? 0,
      archiveCount: json['archive_count'] as int? ?? 0,
      remixCount: json['remix_count'] as int? ?? 0,
      annotationCount: json['annotation_count'] as int? ?? 0,
      remixOfId: json['remix_of_id'] as String?,
      remixOfTitle: json['remix_of_title'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      size: PromptSize.values.firstWhere(
        (e) => e.name == json['size'],
        orElse: () => PromptSize.medium,
      ),
      impactScore: (json['impact_score'] as num?)?.toDouble() ?? 0.0,
      isEchoed: json['is_echoed'] as bool? ?? false,
      isArchived: json['is_archived'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'excerpt': excerpt,
      'content': content,
      'author_id': authorId,
      'author_name': authorName,
      'author_handle': authorHandle,
      'author_avatar_url': authorAvatarUrl,
      'category': category.name,
      'tags': tags,
      'echo_count': echoCount,
      'archive_count': archiveCount,
      'remix_count': remixCount,
      'annotation_count': annotationCount,
      'remix_of_id': remixOfId,
      'remix_of_title': remixOfTitle,
      'thumbnail_url': thumbnailUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'size': size.name,
      'impact_score': impactScore,
      'is_echoed': isEchoed,
      'is_archived': isArchived,
    };
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

  static Color? _colorFromHex(String? hex) {
    if (hex == null) return null;
    final clean = hex.replaceFirst('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

  static String? _colorToHex(Color? color) {
    if (color == null) return null;
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  factory PromptCollection.fromJson(Map<String, dynamic> json) {
    return PromptCollection(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      ownerId: json['owner_id'] as String,
      promptIds: (json['prompt_ids'] as List<dynamic>?)?.cast<String>() ?? [],
      promptCount: json['prompt_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      coverColor: _colorFromHex(json['cover_color'] as String?),
      isPublic: json['is_public'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'owner_id': ownerId,
      'prompt_ids': promptIds,
      'prompt_count': promptCount,
      'created_at': createdAt.toIso8601String(),
      'cover_color': _colorToHex(coverColor),
      'is_public': isPublic,
    };
  }
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

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      handle: json['handle'] as String,
      bio: json['bio'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      promptCount: json['prompt_count'] as int? ?? 0,
      echoesReceived: json['echoes_received'] as int? ?? 0,
      collectionsCount: json['collections_count'] as int? ?? 0,
      tunedInCount: json['tuned_in_count'] as int? ?? 0,
      tuningInToCount: json['tuning_in_to_count'] as int? ?? 0,
      joinedAt: DateTime.parse(json['joined_at'] as String),
      mood: json['mood'] as String?,
      pinnedPromptIds:
          (json['pinned_prompt_ids'] as List<dynamic>?)?.cast<String>() ?? [],
      isTunedIn: json['is_tuned_in'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'handle': handle,
      'bio': bio,
      'avatar_url': avatarUrl,
      'prompt_count': promptCount,
      'echoes_received': echoesReceived,
      'collections_count': collectionsCount,
      'tuned_in_count': tunedInCount,
      'tuning_in_to_count': tuningInToCount,
      'joined_at': joinedAt.toIso8601String(),
      'mood': mood,
      'pinned_prompt_ids': pinnedPromptIds,
      'is_tuned_in': isTunedIn,
    };
  }
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

  factory Annotation.fromJson(Map<String, dynamic> json) {
    return Annotation(
      id: json['id'] as String,
      promptId: json['prompt_id'] as String,
      authorId: json['author_id'] as String,
      authorName: json['author_name'] as String,
      authorHandle: json['author_handle'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt_id': promptId,
      'author_id': authorId,
      'author_name': authorName,
      'author_handle': authorHandle,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
