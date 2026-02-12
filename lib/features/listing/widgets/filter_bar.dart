import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class FilterChipItem {
  final String id;
  final String label;
  final bool selected;

  const FilterChipItem({required this.id, required this.label, this.selected = false});
}

class FilterBar extends StatelessWidget {
  final List<FilterChipItem> chips;
  final ValueChanged<String> onChipTap;
  final String? sortValue;
  final List<String> sortOptions;
  final ValueChanged<String?> onSortChanged;

  const FilterBar({
    super.key,
    required this.chips,
    required this.onChipTap,
    this.sortValue,
    this.sortOptions = const ['Relevance', 'Price: Low to High', 'Verified Suppliers'],
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: chips
                  .map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(c.label),
                        selected: c.selected,
                        onSelected: (_) => onChipTap(c.id),
                        backgroundColor: AppColors.chipBackground,
                        selectedColor: AppColors.chipSelected,
                        checkmarkColor: AppColors.accent,
                        labelStyle: AppTypography.textTheme.labelMedium?.copyWith(
                          color: c.selected ? AppColors.accent : AppColors.textSecondary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          AppSpacing.gapSm,
          Row(
            children: [
              Text(
                'Sort by',
                style: AppTypography.textTheme.bodySmall,
              ),
              AppSpacing.gapSm,
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: sortValue ?? sortOptions.first,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                      items: sortOptions
                          .map((e) => DropdownMenuItem(value: e, child: Text(e, style: AppTypography.textTheme.bodyMedium)))
                          .toList(),
                      onChanged: onSortChanged,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
