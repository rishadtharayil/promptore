import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:promptore/core/theme/colors.dart';
import 'package:promptore/core/theme/typography.dart';
import 'package:promptore/core/theme/dimensions.dart';
import 'package:promptore/core/providers/collections_provider.dart';

/// Bottom sheet for saving a prompt to a collection.
class AddToCollectionSheet extends ConsumerWidget {
  final String promptId;

  const AddToCollectionSheet({super.key, required this.promptId});

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

  void _showCreateCollectionDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: PromptoreColors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        ),
        title: Text(
          'Create Collection',
          style: PromptoreTypography.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              style: PromptoreTypography.bodySmall.copyWith(color: PromptoreColors.parchment),
              decoration: InputDecoration(
                hintText: 'Collection Name',
                hintStyle: PromptoreTypography.bodySmall.copyWith(color: PromptoreColors.charcoal),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: PromptoreColors.warmGray.withValues(alpha: 0.3)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: PromptoreColors.mutedGold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              style: PromptoreTypography.bodySmall.copyWith(color: PromptoreColors.parchment),
              decoration: InputDecoration(
                hintText: 'Description (Optional)',
                hintStyle: PromptoreTypography.bodySmall.copyWith(color: PromptoreColors.charcoal),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: PromptoreColors.warmGray.withValues(alpha: 0.3)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: PromptoreColors.mutedGold),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: PromptoreTypography.metaMedium.copyWith(color: PromptoreColors.dustySepia),
            ),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                ref.read(collectionsProvider.notifier).createCollection(
                  name,
                  descController.text.trim().isEmpty ? null : descController.text.trim(),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Collection "$name" created',
                      style: PromptoreTypography.bodySmall.copyWith(
                        color: PromptoreColors.parchment,
                      ),
                    ),
                    backgroundColor: PromptoreColors.surfaceElevated,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text(
              'Create',
              style: PromptoreTypography.metaMedium.copyWith(color: PromptoreColors.mutedGold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
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
          const SizedBox(height: 20),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(
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

          const SizedBox(height: 8),

          // Collection list
          ...collections.map((col) {
            final isInCollection = col.promptIds.contains(promptId);
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
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
                ref.read(collectionsProvider.notifier).togglePromptInCollection(col.id, promptId);
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
            contentPadding: const EdgeInsets.symmetric(
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
              _showCreateCollectionDialog(context, ref);
            },
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}
