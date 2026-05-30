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

/// Search screen — searching through whispered memories.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';

  final _suggestions = [
    'consciousness', 'dreams', 'architect', 'ocean',
    'memory', 'future', 'silence', 'machine',
  ];

  @override
  void initState() {
    super.initState();
    // Auto-focus the search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<Prompt> _getResults(List<Prompt> prompts) {
    if (_query.isEmpty) return [];
    final q = _query.toLowerCase();
    return prompts.where((p) {
      return p.title.toLowerCase().contains(q) ||
          p.tags.any((t) => t.toLowerCase().contains(q)) ||
          p.excerpt.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final prompts = ref.watch(promptsProvider);
    final results = _getResults(prompts);

    return GrainOverlay(
      child: Scaffold(
        backgroundColor: PromptoreColors.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Search bar + close button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.pagePaddingH,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: PromptoreColors.surface,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusMd),
                          border: Border.all(
                            color: PromptoreColors.warmGray
                                .withValues(alpha: 0.4),
                            width: 0.5,
                          ),
                        ),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          style: PromptoreTypography.bodyMedium.copyWith(
                            color: PromptoreColors.parchment,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search the archive...',
                            hintStyle: PromptoreTypography.bodyMedium.copyWith(
                              color: PromptoreColors.charcoal,
                            ),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.search_rounded,
                              size: 18,
                              color: PromptoreColors.charcoal,
                            ),
                          ),
                          onChanged: (v) => setState(() => _query = v),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Icon(
                        Icons.close_rounded,
                        size: 22,
                        color: PromptoreColors.dustySepia,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 20),

              // Content
              Expanded(
                child: _query.isEmpty
                    ? _buildSuggestions()
                    : results.isEmpty
                        ? _buildEmpty()
                        : _buildResults(results),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.pagePaddingH,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RECENT WHISPERS',
            style: PromptoreTypography.metaLarge.copyWith(
              letterSpacing: 2.0,
              color: PromptoreColors.dustySepia,
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestions.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () {
                  _controller.text = entry.value;
                  setState(() => _query = entry.value);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: PromptoreColors.surface,
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusFull),
                    border: Border.all(
                      color: PromptoreColors.warmGray.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    entry.value,
                    style: PromptoreTypography.metaMedium.copyWith(
                      color: PromptoreColors.dustySepia,
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(
                    duration: 300.ms,
                    delay: Duration(milliseconds: 150 + entry.key * 50),
                  )
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1, 1),
                    duration: 300.ms,
                    delay: Duration(milliseconds: 150 + entry.key * 50),
                  );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.graphic_eq_rounded,
            size: 40,
            color: PromptoreColors.charcoal,
          ),
          const SizedBox(height: 16),
          Text(
            'No echoes found in the archive',
            style: PromptoreTypography.accent.copyWith(
              fontSize: 14,
              color: PromptoreColors.dustySepia,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildResults(List<Prompt> results) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.pagePaddingH,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final p = results[index];
        return GestureDetector(
          onTap: () => context.push('/prompt/${p.id}'),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: PromptoreColors.surface,
              borderRadius: BorderRadius.circular(Dimensions.radiusSm),
              border: Border.all(
                color: PromptoreColors.warmGray.withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: p.category.color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: PromptoreTypography.labelLarge.copyWith(
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${p.authorName} · ${p.category.label}',
                        style: PromptoreTypography.metaSmall,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: PromptoreColors.charcoal,
                ),
              ],
            ),
          ),
        )
            .animate()
            .fadeIn(
              duration: 300.ms,
              delay: Duration(milliseconds: index * 60),
            );
      },
    );
  }
}
