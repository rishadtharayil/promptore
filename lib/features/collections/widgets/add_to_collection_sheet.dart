import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:promptore/core/theme/colors.dart';
import 'package:promptore/core/theme/typography.dart';
import 'package:promptore/core/theme/dimensions.dart';
import 'package:promptore/core/data/mock_data.dart';

/// Bottom sheet for saving a prompt to a collection.
class AddToCollectionSheet extends StatelessWidget {
  final String promptId;

  AddToCollectionSheet({super.key, required this.promptId});

  static void show(BuildContext context, String promptId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: PromptoreColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.sheetRadius),
        ),
      ),
      builder: (_) => AddToCollectionSheet(promptId: promptId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final collections = MockData.collections;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: Dimensions.sheetHandleWidth,
            height: Dimensions.sheetHandleHeight,
            decoration: BoxDecoration(
              color: PromptoreColors.warmGray,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 20),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.pagePaddingH,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Save to Collection',
                  style: PromptoreTypography.titleMedium,
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 20,
                    color: PromptoreColors.dustySepia,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          // Collection list
          ...collections.map((col) {
            final isInCollection = col.promptIds.contains(promptId);
            return ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: Dimensions.pagePaddingH,
                vertical: 4,
              ),
              leading: Container(
                width: 4,
                height: 28,
                decoration: BoxDecoration(
                  color: col.coverColor ?? PromptoreColors.mutedGold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              title: Text(
                col.name,
                style: PromptoreTypography.labelLarge.copyWith(
                  color: isInCollection
                      ? PromptoreColors.mutedGold
                      : PromptoreColors.parchment,
                ),
              ),
              subtitle: Text(
                '${col.promptCount} prompts',
                style: PromptoreTypography.metaSmall,
              ),
              trailing: Icon(
                isInCollection
                    ? Icons.check_circle_rounded
                    : Icons.circle_outlined,
                size: 20,
                color: isInCollection
                    ? PromptoreColors.mutedGold
                    : PromptoreColors.charcoal,
              ),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isInCollection
                          ? 'Removed from ${col.name}'
                          : 'Saved to ${col.name}',
                      style: PromptoreTypography.bodySmall.copyWith(
                        color: PromptoreColors.parchment,
                      ),
                    ),
                    backgroundColor: PromptoreColors.surfaceElevated,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            );
          }),

          // Create new collection
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.pagePaddingH,
              vertical: 4,
            ),
            leading: Container(
              width: 4,
              height: 28,
              decoration: BoxDecoration(
                color: PromptoreColors.mutedGold.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            title: Text(
              'Create New Collection',
              style: PromptoreTypography.labelLarge.copyWith(
                color: PromptoreColors.mutedGold,
              ),
            ),
            trailing: Icon(
              Icons.add_circle_outline,
              size: 20,
              color: PromptoreColors.mutedGold,
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}
