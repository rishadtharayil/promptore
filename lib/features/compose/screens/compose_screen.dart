import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:promptore/core/theme/colors.dart';
import 'package:promptore/core/theme/typography.dart';
import 'package:promptore/core/theme/dimensions.dart';
import 'package:promptore/core/models/models.dart';
import 'package:promptore/core/widgets/grain_overlay.dart';
import 'package:promptore/core/widgets/atmospheric_divider.dart';

/// Compose screen — write something that outlasts you.
class ComposeScreen extends StatefulWidget {
  ComposeScreen({super.key});

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  PromptCategory _selectedCategory = PromptCategory.character;
  final List<String> _tags = [];
  final _tagController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final cleaned = tag.trim().replaceAll(',', '');
    if (cleaned.isNotEmpty && !_tags.contains(cleaned)) {
      setState(() => _tags.add(cleaned));
      _tagController.clear();
    }
  }

  void _publish() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Prompt archived successfully',
          style: PromptoreTypography.bodySmall.copyWith(
            color: PromptoreColors.parchment,
          ),
        ),
        backgroundColor: PromptoreColors.surfaceElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        ),
      ),
    );
    _titleController.clear();
    _contentController.clear();
    setState(() {
      _tags.clear();
      _selectedCategory = PromptCategory.character;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GrainOverlay(
      child: Scaffold(
        backgroundColor: PromptoreColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 100),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.pagePaddingH,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),

                  // Header
                  Text(
                    'Compose',
                    style: PromptoreTypography.displaySmall,
                  ).animate().fadeIn(duration: 500.ms),

                  SizedBox(height: 4),

                  Text(
                    'Write something that outlasts you',
                    style: PromptoreTypography.accent.copyWith(fontSize: 14),
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                  SizedBox(height: 28),

                  // Title field
                  TextField(
                    controller: _titleController,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: PromptoreColors.parchment,
                      height: 1.3,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Give it a name...',
                      hintStyle: GoogleFonts.cormorantGaramond(
                        fontSize: 26,
                        fontWeight: FontWeight.w300,
                        color: PromptoreColors.charcoal,
                        height: 1.3,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    maxLines: 2,
                  ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

                  SizedBox(height: 16),

                  AtmosphericDivider(),

                  SizedBox(height: 16),

                  // Content field
                  TextField(
                    controller: _contentController,
                    style: PromptoreTypography.bodyLarge.copyWith(
                      height: 1.7,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          'Write your prompt...\n\nThe best prompts feel like discovering a strange machine, a hidden manuscript, or a new perspective.',
                      hintStyle: PromptoreTypography.bodyMedium.copyWith(
                        color: PromptoreColors.charcoal,
                        height: 1.7,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    maxLines: null,
                    minLines: 8,
                  ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

                  SizedBox(height: 24),

                  AtmosphericDivider(),

                  SizedBox(height: 20),

                  // Category selector
                  Text(
                    'CATEGORY',
                    style: PromptoreTypography.metaLarge.copyWith(
                      letterSpacing: 2.0,
                      color: PromptoreColors.dustySepia,
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 350.ms),

                  SizedBox(height: 10),

                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: PromptCategory.values.map((cat) {
                        final isSelected = cat == _selectedCategory;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? cat.color.withValues(alpha: 0.15)
                                  : PromptoreColors.surface,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radiusFull),
                              border: Border.all(
                                color: isSelected
                                    ? cat.color.withValues(alpha: 0.5)
                                    : PromptoreColors.warmGray
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
                                SizedBox(width: 5),
                                Text(
                                  cat.label.split(' ').first,
                                  style: PromptoreTypography.metaSmall.copyWith(
                                    color: isSelected
                                        ? cat.color
                                        : PromptoreColors.dustySepia,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 400.ms),

                  SizedBox(height: 24),

                  // Tags
                  Text(
                    'TAGS',
                    style: PromptoreTypography.metaLarge.copyWith(
                      letterSpacing: 2.0,
                      color: PromptoreColors.dustySepia,
                    ),
                  ),

                  SizedBox(height: 10),

                  if (_tags.isNotEmpty) ...[
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _tags.map((tag) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color:
                                PromptoreColors.warmGray.withValues(alpha: 0.3),
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusFull),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tag,
                                style: PromptoreTypography.metaSmall.copyWith(
                                  color: PromptoreColors.dustySepia,
                                ),
                              ),
                              SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  setState(() => _tags.remove(tag));
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 12,
                                  color: PromptoreColors.charcoal,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 8),
                  ],

                  TextField(
                    controller: _tagController,
                    style: PromptoreTypography.bodySmall,
                    decoration: InputDecoration(
                      hintText: 'Add tags (comma separated)...',
                      hintStyle: PromptoreTypography.bodySmall.copyWith(
                        color: PromptoreColors.charcoal,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: _addTag,
                    onChanged: (value) {
                      if (value.contains(',')) {
                        _addTag(value);
                      }
                    },
                  ),

                  SizedBox(height: 32),

                  // Publish button
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: _publish,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: PromptoreColors.mutedGold,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusMd),
                        ),
                        child: Center(
                          child: Text(
                            'Publish to Archive',
                            style: PromptoreTypography.labelLarge.copyWith(
                              color: PromptoreColors.background,
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
        ),
      ),
    );
  }
}
