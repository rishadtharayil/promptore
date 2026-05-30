import 'package:flutter/material.dart';
import 'package:promptore/core/theme/color_extension.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import 'package:promptore/core/theme/typography.dart';
import 'package:promptore/core/theme/dimensions.dart';
import 'package:promptore/core/data/mock_data.dart';
import 'package:promptore/core/models/models.dart';
import 'package:promptore/core/providers/prompts_provider.dart';
import 'package:promptore/core/widgets/atmospheric_divider.dart';

/// Remix screen — fork a prompt and make it your own.
class RemixScreen extends ConsumerStatefulWidget {
  final String promptId;

  const RemixScreen({super.key, required this.promptId});

  @override
  ConsumerState<RemixScreen> createState() => _RemixScreenState();
}

class _RemixScreenState extends ConsumerState<RemixScreen> {
  late Prompt _original;
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late PromptCategory _selectedCategory;
  late List<String> _tags;
  bool _originalExpanded = false;

  @override
  void initState() {
    super.initState();
    // Read directly from provider to ensure we have the latest original state
    final prompts = ref.read(promptsProvider);
    _original = prompts.firstWhere((p) => p.id == widget.promptId);
    _titleController =
        TextEditingController(text: 'Remix of: ${_original.title}');
    _contentController = TextEditingController(text: _original.content);
    _selectedCategory = _original.category;
    _tags = List.from(_original.tags);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _publish() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Title and content cannot be empty',
            style: PromptoreTypography.bodySmall.copyWith(
              color: PromptoreColorExtension.of(context).parchment,
            ),
          ),
          backgroundColor: PromptoreColorExtension.of(context).surfaceElevated,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();

    final excerpt = content.length > 120 ? '${content.substring(0, 120)}...' : content;
    final wordCount = content.split(RegExp(r'\s+')).length;
    PromptSize size = PromptSize.medium;
    if (wordCount < 200) {
      size = PromptSize.short;
    } else if (wordCount < 500) {
      size = PromptSize.medium;
    } else if (wordCount < 1000) {
      size = PromptSize.long;
    } else {
      size = PromptSize.epic;
    }

    final remixedPrompt = Prompt(
      id: 'p-${const Uuid().v4()}',
      title: title,
      excerpt: excerpt,
      content: content,
      authorId: MockData.currentUser.id,
      authorName: MockData.currentUser.displayName,
      authorHandle: MockData.currentUser.handle,
      authorAvatarUrl: MockData.currentUser.avatarUrl,
      category: _selectedCategory,
      tags: List.from(_tags),
      createdAt: DateTime.now(),
      size: size,
      impactScore: 0.5,
      remixOfId: _original.id,
      remixOfTitle: _original.title,
    );

    // Save remix and update original remix count
    ref.read(promptsProvider.notifier).addPrompt(remixedPrompt);
    ref.read(promptsProvider.notifier).incrementRemixCount(_original.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Remix published to the archive',
          style: PromptoreTypography.bodySmall.copyWith(
            color: PromptoreColorExtension.of(context).parchment,
          ),
        ),
        backgroundColor: PromptoreColorExtension.of(context).surfaceElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        ),
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text(
            'Remix',
            style: PromptoreTypography.titleMedium,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.pagePaddingH,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // Attribution
                Row(
                  children: [
                    Icon(
                      Icons.call_split_rounded,
                      size: 14,
                      color: PromptoreColorExtension.of(context).fadedBronze,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Original by ${_original.authorName}',
                      style: PromptoreTypography.metaLarge.copyWith(
                        color: PromptoreColorExtension.of(context).fadedBronze,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms),

                const SizedBox(height: 16),

                // Original prompt (collapsible)
                GestureDetector(
                  onTap: () {
                    setState(() => _originalExpanded = !_originalExpanded);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: PromptoreColorExtension.of(context).surface,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSm),
                      border: Border.all(
                        color:
                            PromptoreColorExtension.of(context).warmGray.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _original.title,
                                style: PromptoreTypography.titleSmall.copyWith(
                                  color: PromptoreColorExtension.of(context).parchment,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Icon(
                              _originalExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              size: 18,
                              color: PromptoreColorExtension.of(context).charcoal,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _originalExpanded
                              ? _original.content
                              : _original.content.length > 150
                                  ? '${_original.content.substring(0, 150)}...'
                                  : _original.content,
                          style: PromptoreTypography.bodySmall.copyWith(
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                const SizedBox(height: 20),

                // "Your Remix" label
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 1,
                      color: PromptoreColorExtension.of(context).mutedGold.withValues(alpha: 0.3),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'YOUR REMIX',
                      style: PromptoreTypography.metaLarge.copyWith(
                        letterSpacing: 2.0,
                        color: PromptoreColorExtension.of(context).mutedGold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 1,
                        color:
                            PromptoreColorExtension.of(context).mutedGold.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

                const SizedBox(height: 20),

                // Title field
                TextField(
                  controller: _titleController,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: PromptoreColorExtension.of(context).parchment,
                    height: 1.3,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Remix title...',
                    hintStyle: GoogleFonts.cormorantGaramond(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      color: PromptoreColorExtension.of(context).charcoal,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  maxLines: 2,
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

                const SizedBox(height: 12),

                const AtmosphericDivider(),

                const SizedBox(height: 12),

                // Content field
                TextField(
                  controller: _contentController,
                  style: PromptoreTypography.bodyLarge.copyWith(
                    height: 1.7,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Your remixed content...',
                    hintStyle: PromptoreTypography.bodyMedium.copyWith(
                      color: PromptoreColorExtension.of(context).charcoal,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  maxLines: null,
                  minLines: 6,
                ).animate().fadeIn(duration: 400.ms, delay: 350.ms),

                const SizedBox(height: 20),

                // Category
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: PromptCategory.values.map((cat) {
                      final isSelected = cat == _selectedCategory;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategory = cat),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? cat.color.withValues(alpha: 0.15)
                                : PromptoreColorExtension.of(context).surface,
                            borderRadius: BorderRadius.circular(
                              Dimensions.radiusFull,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? cat.color.withValues(alpha: 0.5)
                                  : PromptoreColorExtension.of(context).warmGray
                                      .withValues(alpha: 0.4),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                cat.symbol,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: cat.color,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                cat.label.split(' ').first,
                                style: PromptoreTypography.metaSmall.copyWith(
                                  color: isSelected
                                      ? cat.color
                                      : PromptoreColorExtension.of(context).dustySepia,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),

                // Tags
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color:
                            PromptoreColorExtension.of(context).warmGray.withValues(alpha: 0.3),
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tag,
                            style: PromptoreTypography.metaSmall.copyWith(
                              color: PromptoreColorExtension.of(context).dustySepia,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              setState(() => _tags.remove(tag));
                            },
                            child: Icon(
                              Icons.close,
                              size: 12,
                              color: PromptoreColorExtension.of(context).charcoal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                // Publish button
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: _publish,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: PromptoreColorExtension.of(context).mutedGold,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusMd),
                      ),
                      child: Center(
                        child: Text(
                          'Publish Remix',
                          style: PromptoreTypography.labelLarge.copyWith(
                            color: PromptoreColorExtension.of(context).background,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
              ],
            ),
          ),
        ),
      );
  }
}
