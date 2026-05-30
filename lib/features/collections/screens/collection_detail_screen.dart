import 'package:flutter/material.dart';
import 'package:promptore/core/theme/color_extension.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:promptore/core/theme/typography.dart';
import 'package:promptore/core/theme/dimensions.dart';
import 'package:promptore/core/providers/collections_provider.dart';
import 'package:promptore/core/providers/prompts_provider.dart';
import 'package:promptore/core/widgets/atmospheric_divider.dart';
import 'package:promptore/features/feed/widgets/prompt_card.dart';

/// Collection detail — curated library of prompts.
class CollectionDetailScreen extends ConsumerWidget {
  final String collectionId;

  const CollectionDetailScreen({super.key, required this.collectionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCollections = ref.watch(collectionsProvider);
    final collection = allCollections.firstWhere(
      (c) => c.id == collectionId,
      orElse: () => allCollections.first,
    );
    
    final allPrompts = ref.watch(promptsProvider);
    final prompts = allPrompts
        .where((p) => collection.promptIds.contains(p.id))
        .toList();
        
    final accentColor = collection.coverColor ?? PromptoreColorExtension.of(context).mutedGold;

    return Scaffold(
      backgroundColor: PromptoreColorExtension.of(context).background,
      appBar: AppBar(
        backgroundColor: PromptoreColorExtension.of(context).background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 20,
            color: PromptoreColorExtension.of(context).dustySepia,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.pagePaddingH,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Collection Info Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: PromptoreColorExtension.of(context).surface,
                      borderRadius: BorderRadius.circular(Dimensions.cardRadius),
                      border: Border.all(
                        color: PromptoreColorExtension.of(context).warmGray.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          collection.name,
                          style: PromptoreTypography.displaySmall.copyWith(
                            fontSize: 24,
                          ),
                        ),
                        if (collection.description != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            collection.description!,
                            style: PromptoreTypography.bodyMedium.copyWith(
                              color: PromptoreColorExtension.of(context).dustySepia,
                              height: 1.5,
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        const AtmosphericDivider(),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${prompts.length} ARCHIVAL ENTRIES',
                              style: PromptoreTypography.metaSmall.copyWith(
                                color: accentColor,
                                letterSpacing: 1.0,
                              ),
                            ),
                            Text(
                              collection.isPublic ? 'PUBLIC RECORD' : 'RESTRICTED',
                              style: PromptoreTypography.metaSmall.copyWith(
                                color: PromptoreColorExtension.of(context).charcoal,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 500.ms, delay: 100.ms),

                  const SizedBox(height: 28),

                  Row(
                    children: [
                      Icon(
                        Icons.auto_stories_outlined,
                        size: 14,
                        color: PromptoreColorExtension.of(context).charcoal,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'SAVED TRANSMISSIONS',
                        style: PromptoreTypography.metaSmall.copyWith(
                          color: PromptoreColorExtension.of(context).charcoal,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

                  const SizedBox(height: 16),
                  const AtmosphericDivider()
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 250.ms),

                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Prompts
            ...prompts.asMap().entries.map((entry) {
              return PromptCard(
                prompt: entry.value,
                index: entry.key,
              );
            }),

            if (prompts.isEmpty)
              Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Text(
                    'This collection is empty',
                    style: PromptoreTypography.bodyMedium.copyWith(
                      color: PromptoreColorExtension.of(context).charcoal,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
