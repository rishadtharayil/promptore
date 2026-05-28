import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:promptore/core/theme/colors.dart';
import 'package:promptore/core/theme/typography.dart';
import 'package:promptore/core/theme/dimensions.dart';
import 'package:promptore/core/data/mock_data.dart';
import 'package:promptore/core/widgets/grain_overlay.dart';
import 'package:promptore/core/widgets/atmospheric_divider.dart';
import 'package:promptore/features/feed/widgets/prompt_card.dart';

/// Collection detail — curated library of prompts.
class CollectionDetailScreen extends StatelessWidget {
  final String collectionId;

  CollectionDetailScreen({super.key, required this.collectionId});

  @override
  Widget build(BuildContext context) {
    final collection =
        MockData.collections.firstWhere((c) => c.id == collectionId);
    final prompts = MockData.prompts
        .where((p) => collection.promptIds.contains(p.id))
        .toList();
    final accentColor = collection.coverColor ?? PromptoreColors.mutedGold;

    return GrainOverlay(
      child: Scaffold(
        backgroundColor: PromptoreColors.background,
        appBar: AppBar(
          backgroundColor: PromptoreColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
              color: PromptoreColors.dustySepia,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
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

                    SizedBox(height: 16),

                    // Collection name
                    Text(
                      collection.name,
                      style: PromptoreTypography.displaySmall,
                    ).animate().fadeIn(duration: 500.ms, delay: 100.ms),

                    SizedBox(height: 8),

                    if (collection.description != null)
                      Text(
                        collection.description!,
                        style: PromptoreTypography.bodyMedium.copyWith(
                          height: 1.6,
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

                    SizedBox(height: 12),

                    // Metadata
                    Row(
                      children: [
                        Text(
                          '${collection.promptCount} prompts',
                          style: PromptoreTypography.metaMedium.copyWith(
                            color: accentColor,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Created ${collection.createdAt.year}',
                          style: PromptoreTypography.metaMedium,
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms, delay: 250.ms),

                    SizedBox(height: 20),
                    AtmosphericDivider(),
                    SizedBox(height: 16),
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
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: Text(
                      'This collection is empty',
                      style: PromptoreTypography.bodyMedium.copyWith(
                        color: PromptoreColors.charcoal,
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
