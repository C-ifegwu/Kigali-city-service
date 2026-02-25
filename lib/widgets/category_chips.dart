import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/listing_provider.dart';
import '../utils/theme.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ListingProvider>();

    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
        scrollDirection: Axis.horizontal,
        itemCount: kCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = kCategories[i];
          final isSelected = cat == prov.selectedCategory;
          return GestureDetector(
            onTap: () => prov.setCategory(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? kGold : kNavyCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: isSelected ? kGold : kNavyMid, width: 1),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isSelected ? kNavyDark : kWhite70,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
