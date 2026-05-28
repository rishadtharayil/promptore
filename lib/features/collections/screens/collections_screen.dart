import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:promptore/core/theme/colors.dart';
import 'package:promptore/core/theme/typography.dart';
import 'package:promptore/core/theme/dimensions.dart';
import 'package:promptore/core/data/mock_data.dart';
import 'package:promptore/core/models/models.dart';
import 'package:promptore/core/widgets/grain_overlay.dart';

/// User's collections — curated libraries of thought.
class CollectionsScreen extends StatelessWidget {
  CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final collections = MockData.collections
        .where((c) => c.ownerId == MockData.currentUser.id)
        .toList();

    return GrainOverlay(
      child: Scaffold(
        backgroundColor: PromptoreColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),

                // Header
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.pagePaddingH,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Archive',
                            style: PromptoreTypography.displaySmall,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Curated libraries of thought',
                            style: PromptoreTypography.bodyMedium,
                          ),
                        ],
                      ),
                      // Create collection button
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'New collection created',
                                style: PromptoreTypography.bodySmall.copyWith(
                                  color: PromptoreColors.parchment,
                                ),
                              ),
                              backgroundColor: PromptoreColors.surfaceElevated,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: PromptoreColors.mutedGold
                                  .withValues(alpha: 0.4),
                              width: 0.5,
                            ),
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusFull),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add,
                                size: 14,
                                color: PromptoreColors.mutedGold,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Create',
                                style: PromptoreTypography.metaMedium.copyWith(
                                  color: PromptoreColors.mutedGold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms),

                SizedBox(height: 24),

                if (collections.isEmpty)
                  // Empty state
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.pagePaddingH,
                      vertical: 60,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.collections_bookmark_outlined,
                            size: 48,
                            color: PromptoreColors.charcoal,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Your archive is empty',
                            style: PromptoreTypography.titleMedium.copyWith(
                              color: PromptoreColors.dustySepia,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Save prompts to begin collecting.',
                            style: PromptoreTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  // Collections grid
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.pagePaddingH,
                    ),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: collections.length,
                      itemBuilder: (context, index) {
                        final col = collections[index];
                        return _CollectionCard(
                          collection: col,
                          index: index,
                        );
                      },
                    ),
                  ),

                // Also show all collections for discovery
                if (collections.isNotEmpty) ...[
                  SizedBox(height: 32),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.pagePaddingH,
                    ),
                    child: Text(
                      'DISCOVER COLLECTIONS',
                      style: PromptoreTypography.metaLarge.copyWith(
                        letterSpacing: 2.0,
                        color: PromptoreColors.dustySepia,
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.pagePaddingH,
                    ),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: MockData.collections.length,
                      itemBuilder: (context, index) {
                        final col = MockData.collections[index];
                        return _CollectionCard(
                          collection: col,
                          index: index + collections.length,
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Collection card — library-like card with accent color bar
class _CollectionCard extends StatelessWidget {
  final PromptCollection collection;
  final int index;

  _CollectionCard({required this.collection, required this.index});

  @override
  Widget build(BuildContext context) {
    final accentColor = collection.coverColor ?? PromptoreColors.mutedGold;

    return GestureDetector(
      onTap: () => context.push('/collections/${collection.id}'),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: PromptoreColors.surface,
          borderRadius: BorderRadius.circular(Dimensions.cardRadius),
          border: Border.all(
            color: PromptoreColors.warmGray.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color accent bar
            Container(
              width: 32,
              height: 3,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 14),

            // Name
            Text(
              collection.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: PromptoreTypography.titleMedium.copyWith(
                fontSize: 15,
              ),
            ),
            SizedBox(height: 6),

            // Description
            if (collection.description != null)
              Expanded(
                child: Text(
                  collection.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: PromptoreTypography.bodySmall.copyWith(
                    height: 1.4,
                  ),
                ),
              ),

            Spacer(),

            // Count
            Text(
              '${collection.promptCount} prompts',
              style: PromptoreTypography.metaSmall.copyWith(
                color: accentColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: Duration(milliseconds: 100 + index * 80),
        )
        .scale(
          begin: Offset(0.95, 0.95),
          end: Offset(1, 1),
          duration: 400.ms,
          delay: Duration(milliseconds: 100 + index * 80),
        );
  }
}
