import 'package:flutter/material.dart';
import 'package:promptore/core/theme/color_extension.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:promptore/core/theme/typography.dart';
import 'package:promptore/core/theme/dimensions.dart';
import 'package:promptore/core/data/mock_data.dart';
import 'package:promptore/core/models/models.dart';
import 'package:promptore/core/providers/collections_provider.dart';
/// User's collections — curated libraries of thought.
class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  void _showCreateCollectionDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: PromptoreColorExtension.of(context).surfaceElevated,
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
              style: PromptoreTypography.bodySmall.copyWith(color: PromptoreColorExtension.of(context).parchment),
              decoration: InputDecoration(
                hintText: 'Collection Name',
                hintStyle: PromptoreTypography.bodySmall.copyWith(color: PromptoreColorExtension.of(context).charcoal),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: PromptoreColorExtension.of(context).warmGray.withValues(alpha: 0.3)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: PromptoreColorExtension.of(context).mutedGold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              style: PromptoreTypography.bodySmall.copyWith(color: PromptoreColorExtension.of(context).parchment),
              decoration: InputDecoration(
                hintText: 'Description (Optional)',
                hintStyle: PromptoreTypography.bodySmall.copyWith(color: PromptoreColorExtension.of(context).charcoal),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: PromptoreColorExtension.of(context).warmGray.withValues(alpha: 0.3)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: PromptoreColorExtension.of(context).mutedGold),
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
              style: PromptoreTypography.metaMedium.copyWith(color: PromptoreColorExtension.of(context).dustySepia),
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
                        color: PromptoreColorExtension.of(context).parchment,
                      ),
                    ),
                    backgroundColor: PromptoreColorExtension.of(context).surfaceElevated,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text(
              'Create',
              style: PromptoreTypography.metaMedium.copyWith(color: PromptoreColorExtension.of(context).mutedGold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCollections = ref.watch(collectionsProvider);
    final collections = allCollections
        .where((c) => c.ownerId == MockData.currentUser.id)
        .toList();

    return Scaffold(
        backgroundColor: PromptoreColorExtension.of(context).background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
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
                          const SizedBox(height: 4),
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
                          _showCreateCollectionDialog(context, ref);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: PromptoreColorExtension.of(context).mutedGold
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
                                color: PromptoreColorExtension.of(context).mutedGold,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Create',
                                style: PromptoreTypography.metaMedium.copyWith(
                                  color: PromptoreColorExtension.of(context).mutedGold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms),

                const SizedBox(height: 24),

                if (collections.isEmpty)
                  // Empty state
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.pagePaddingH,
                      vertical: 60,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.collections_bookmark_outlined,
                            size: 48,
                            color: PromptoreColorExtension.of(context).charcoal,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Your archive is empty',
                            style: PromptoreTypography.titleMedium.copyWith(
                              color: PromptoreColorExtension.of(context).dustySepia,
                            ),
                          ),
                          const SizedBox(height: 8),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.pagePaddingH,
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                if (allCollections.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.pagePaddingH,
                    ),
                    child: Text(
                      'DISCOVER COLLECTIONS',
                      style: PromptoreTypography.metaLarge.copyWith(
                        letterSpacing: 2.0,
                        color: PromptoreColorExtension.of(context).dustySepia,
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.pagePaddingH,
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: allCollections.length,
                      itemBuilder: (context, index) {
                        final col = allCollections[index];
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
      );
  }
}

/// Collection card — library-like card with accent color bar
class _CollectionCard extends StatelessWidget {
  final PromptCollection collection;
  final int index;

  const _CollectionCard({required this.collection, required this.index});

  @override
  Widget build(BuildContext context) {
    final accentColor = collection.coverColor ?? PromptoreColorExtension.of(context).mutedGold;

    return GestureDetector(
      onTap: () => context.push('/collections/${collection.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: PromptoreColorExtension.of(context).surface,
          borderRadius: BorderRadius.circular(Dimensions.cardRadius),
          border: Border.all(
            color: PromptoreColorExtension.of(context).warmGray.withValues(alpha: 0.3),
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
            const SizedBox(height: 14),

            // Name
            Text(
              collection.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: PromptoreTypography.titleMedium.copyWith(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 6),

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

            const Spacer(),

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
        )
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          duration: 400.ms,
        );
  }
}
