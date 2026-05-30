import 'package:flutter/material.dart';
import 'package:promptore/core/theme/color_extension.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:promptore/core/theme/colors.dart';
import 'package:promptore/core/theme/color_extension.dart';
import 'package:promptore/core/theme/typography.dart';
import 'package:promptore/core/theme/dimensions.dart';
import 'package:promptore/core/providers/collections_provider.dart';
import 'package:promptore/core/providers/prompts_provider.dart';
import 'package:promptore/core/widgets/grain_overlay.dart';
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

    return GrainOverlay(
      child: Scaffold(
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
                    // Accent bar
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ).animate().fadeIn(duration: 400.ms).scaleX(
                          begin: 0,
                          end: 1,
                          alignment: Alignment.centerLeft,
                          duration: 600.ms,
                        ),

                    const SizedBox(height: 16),

                    // Collection name
                    Text(
                      collection.name,
                      style: PromptoreTypography.displaySmall,
                    ).animate().fadeIn(duration: 500.ms, delay: 100.ms),

                    const SizedBox(height: 8),

                    if (collection.description != null)
                      Text(
                        collection.description!,
                        style: PromptoreTypography.bodyMedium.copyWith(
                          height: 1.6,
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

                    const SizedBox(height: 12),

                    // Metadata
                    Row(
                      children: [
                        Text(
                          '${collection.promptCount} prompts',
                          style: PromptoreTypography.metaMedium.copyWith(
                            color: accentColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Created ${collection.createdAt.year}',
                          style: PromptoreTypography.metaMedium,
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms, delay: 250.ms),

                    const SizedBox(height: 20),
                    const AtmosphericDivider(),
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
      ),
    );
  }
}
