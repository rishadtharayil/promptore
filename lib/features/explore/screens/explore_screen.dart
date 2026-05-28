import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:promptore/core/theme/colors.dart';
import 'package:promptore/core/theme/typography.dart';
import 'package:promptore/core/theme/dimensions.dart';
import 'package:promptore/core/data/mock_data.dart';
import 'package:promptore/core/models/models.dart';
import 'package:promptore/core/widgets/grain_overlay.dart';

/// Explore screen — discover categories, trending prompts, rising creators.
class ExploreScreen extends StatelessWidget {
  ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Top 5 prompts by echo count
    final trending = List<Prompt>.from(MockData.prompts)
      ..sort((a, b) => b.echoCount.compareTo(a.echoCount));
    final topPrompts = trending.take(5).toList();

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
                  child: Text(
                    'Explore',
                    style: PromptoreTypography.displaySmall,
                  ),
                ).animate().fadeIn(duration: 500.ms),

                SizedBox(height: 16),

                // Search bar (tappable, navigates to /search)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.pagePaddingH,
                  ),
                  child: GestureDetector(
                    onTap: () => context.push('/search'),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: PromptoreColors.surface,
                        borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                        border: Border.all(
                          color: PromptoreColors.warmGray.withValues(alpha: 0.4),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 18,
                            color: PromptoreColors.charcoal,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Search the archive...',
                            style: PromptoreTypography.bodyMedium.copyWith(
                              color: PromptoreColors.charcoal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                SizedBox(height: 28),

                // Trending section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.pagePaddingH,
                  ),
                  child: Text(
                    'TRENDING',
                    style: PromptoreTypography.metaLarge.copyWith(
                      letterSpacing: 2.0,
                      color: PromptoreColors.dustySepia,
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

                SizedBox(height: 12),

                // Trending cards
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.pagePaddingH,
                    ),
                    itemCount: topPrompts.length,
                    itemBuilder: (context, index) {
                      final p = topPrompts[index];
                      return GestureDetector(
                        onTap: () => context.push('/prompt/${p.id}'),
                        child: Container(
                          width: 200,
                          margin: EdgeInsets.only(right: 12),
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: PromptoreColors.surface,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusMd),
                            border: Border.all(
                              color: PromptoreColors.warmGray
                                  .withValues(alpha: 0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: p.category.color,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    p.category.label.split(' ').first,
                                    style: PromptoreTypography.metaSmall
                                        .copyWith(color: p.category.color),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Expanded(
                                child: Text(
                                  p.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: PromptoreTypography.titleSmall.copyWith(
                                    color: PromptoreColors.parchment,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.graphic_eq_rounded,
                                    size: 12,
                                    color: PromptoreColors.charcoal,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '${p.echoCount}',
                                    style: PromptoreTypography.metaSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(
                              duration: 400.ms,
                              delay: Duration(milliseconds: 200 + index * 80),
                            )
                            .slideX(
                              begin: 0.05,
                              end: 0,
                              duration: 400.ms,
                              delay: Duration(milliseconds: 200 + index * 80),
                            ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 32),

                // Categories
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.pagePaddingH,
                  ),
                  child: Text(
                    'CATEGORIES',
                    style: PromptoreTypography.metaLarge.copyWith(
                      letterSpacing: 2.0,
                      color: PromptoreColors.dustySepia,
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

                SizedBox(height: 12),

                // Category grid
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
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: PromptCategory.values.length,
                    itemBuilder: (context, index) {
                      final cat = PromptCategory.values[index];
                      final count = MockData.prompts
                          .where((p) => p.category == cat)
                          .length;
                      return _CategoryTile(
                        category: cat,
                        promptCount: count,
                        index: index,
                      );
                    },
                  ),
                ),

                SizedBox(height: 32),

                // Rising Creators
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.pagePaddingH,
                  ),
                  child: Text(
                    'RISING CREATORS',
                    style: PromptoreTypography.metaLarge.copyWith(
                      letterSpacing: 2.0,
                      color: PromptoreColors.dustySepia,
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 400.ms),

                SizedBox(height: 12),

                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.pagePaddingH,
                    ),
                    itemCount: MockData.users.length,
                    itemBuilder: (context, index) {
                      final user = MockData.users[index];
                      return Container(
                        width: 72,
                        margin: EdgeInsets.only(right: 16),
                        child: Column(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: PromptoreColors.surfaceElevated,
                                border: Border.all(
                                  color: PromptoreColors.mutedGold
                                      .withValues(alpha: 0.3),
                                  width: 0.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  user.displayName[0],
                                  style:
                                      PromptoreTypography.titleMedium.copyWith(
                                    color: PromptoreColors.mutedGold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              user.displayName.split(' ').first,
                              style: PromptoreTypography.metaSmall.copyWith(
                                color: PromptoreColors.parchment,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${user.promptCount} prompts',
                              style: PromptoreTypography.metaSmall.copyWith(
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(
                            duration: 400.ms,
                            delay: Duration(milliseconds: 450 + index * 60),
                          )
                          .scale(
                            begin: Offset(0.9, 0.9),
                            end: Offset(1, 1),
                            duration: 400.ms,
                            delay: Duration(milliseconds: 450 + index * 60),
                          );
                    },
                  ),
                ),

                SizedBox(height: 32),

                // Recent Collections
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.pagePaddingH,
                  ),
                  child: Text(
                    'RECENT COLLECTIONS',
                    style: PromptoreTypography.metaLarge.copyWith(
                      letterSpacing: 2.0,
                      color: PromptoreColors.dustySepia,
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 500.ms),

                SizedBox(height: 12),

                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.pagePaddingH,
                    ),
                    itemCount: MockData.collections.length,
                    itemBuilder: (context, index) {
                      final col = MockData.collections[index];
                      return GestureDetector(
                        onTap: () => context.push('/collections/${col.id}'),
                        child: Container(
                          width: 180,
                          margin: EdgeInsets.only(right: 12),
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: PromptoreColors.surface,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusMd),
                            border: Border.all(
                              color: PromptoreColors.warmGray
                                  .withValues(alpha: 0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: col.coverColor ??
                                      PromptoreColors.mutedGold,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                col.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: PromptoreTypography.titleSmall.copyWith(
                                  color: PromptoreColors.parchment,
                                  fontSize: 13,
                                ),
                              ),
                              Spacer(),
                              Text(
                                '${col.promptCount} prompts',
                                style: PromptoreTypography.metaSmall,
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(
                              duration: 400.ms,
                              delay:
                                  Duration(milliseconds: 550 + index * 80),
                            )
                            .slideX(
                              begin: 0.05,
                              end: 0,
                              duration: 400.ms,
                              delay:
                                  Duration(milliseconds: 550 + index * 80),
                            ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Category tile for the explore grid
class _CategoryTile extends StatelessWidget {
  final PromptCategory category;
  final int promptCount;
  final int index;

  _CategoryTile({
    required this.category,
    required this.promptCount,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PromptoreColors.surface,
        borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        border: Border.all(
          color: PromptoreColors.warmGray.withValues(alpha: 0.3),
          width: 0.5,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            category.color.withValues(alpha: 0.08),
            PromptoreColors.surface,
          ],
        ),
      ),
      padding: EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category.symbol,
            style: TextStyle(
              fontSize: 22,
              color: category.color.withValues(alpha: 0.7),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.label,
                style: PromptoreTypography.labelMedium.copyWith(
                  color: PromptoreColors.parchment,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                '$promptCount prompts',
                style: PromptoreTypography.metaSmall.copyWith(
                  color: category.color.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: Duration(milliseconds: 350 + index * 50),
        )
        .scale(
          begin: Offset(0.95, 0.95),
          end: Offset(1, 1),
          duration: 400.ms,
          delay: Duration(milliseconds: 350 + index * 50),
        );
  }
}
