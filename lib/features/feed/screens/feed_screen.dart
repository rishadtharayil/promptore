import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:promptore/core/theme/colors.dart';
import 'package:promptore/core/theme/typography.dart';
import 'package:promptore/core/theme/dimensions.dart';
import 'package:promptore/core/models/models.dart';
import 'package:promptore/core/providers/prompts_provider.dart';
import 'package:promptore/core/widgets/grain_overlay.dart';
import '../widgets/prompt_card.dart';

/// The main social feed — scrolling through archived transmissions.
class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  PromptCategory? _selectedCategory;

  List<Prompt> _getFilteredPrompts(List<Prompt> prompts) {
    if (_selectedCategory == null) return prompts;
    return prompts
        .where((p) => p.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final allPrompts = ref.watch(promptsProvider);
    final filteredPrompts = _getFilteredPrompts(allPrompts);

    return GrainOverlay(
      child: Scaffold(
        backgroundColor: PromptoreColors.background,
        body: RefreshIndicator(
          color: PromptoreColors.mutedGold,
          backgroundColor: PromptoreColors.surface,
          onRefresh: () async {
            await Future.delayed(Duration(milliseconds: 800));
          },
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              // App bar
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: PromptoreColors.background,
                elevation: 0,
                scrolledUnderElevation: 0,
                toolbarHeight: 56,
                title: Text(
                  'PROMPTORE',
                  style: PromptoreTypography.titleLarge.copyWith(
                    letterSpacing: 4.0,
                    color: PromptoreColors.mutedGold,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.search_rounded,
                      color: PromptoreColors.dustySepia,
                      size: 22,
                    ),
                    onPressed: () => context.push('/search'),
                  ),
                  SizedBox(width: 4),
                ],
              ),

              // Category chips
              SliverToBoxAdapter(
                child: _CategoryChipBar(
                  selected: _selectedCategory,
                  onSelected: (cat) {
                    setState(() => _selectedCategory = cat);
                  },
                ),
              ),

              // Feed items
              SliverPadding(
                padding: EdgeInsets.only(top: 8, bottom: 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= filteredPrompts.length) return null;
                      return PromptCard(
                        prompt: filteredPrompts[index],
                        index: index,
                      );
                    },
                    childCount: filteredPrompts.length,
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

/// Horizontal scrolling category filter chips
class _CategoryChipBar extends StatelessWidget {
  final PromptCategory? selected;
  final ValueChanged<PromptCategory?> onSelected;

  const _CategoryChipBar({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.pagePaddingH,
        ),
        children: [
          // "All" chip
          _Chip(
            label: 'All',
            symbol: '◎',
            isSelected: selected == null,
            color: PromptoreColors.mutedGold,
            onTap: () => onSelected(null),
          ),
          SizedBox(width: 8),
          // Category chips
          ...PromptCategory.values.map((cat) {
            return Padding(
              padding: EdgeInsets.only(right: 8),
              child: _Chip(
                label: cat.label.split(' ').first,
                symbol: cat.symbol,
                isSelected: selected == cat,
                color: cat.color,
                onTap: () => onSelected(cat),
              ),
            );
          }),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 200.ms)
        .slideX(begin: 0.05, end: 0, duration: 400.ms, delay: 200.ms);
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final String symbol;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.symbol,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : PromptoreColors.surface,
          borderRadius: BorderRadius.circular(Dimensions.radiusFull),
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.5)
                : PromptoreColors.warmGray.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              symbol,
              style: TextStyle(fontSize: 11, color: color),
            ),
            SizedBox(width: 5),
            Text(
              label,
              style: PromptoreTypography.metaSmall.copyWith(
                color: isSelected ? color : PromptoreColors.dustySepia,
                letterSpacing: 0.5,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
