import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../utils/theme.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback onTap;
  final Widget? trailing;

  const ListingCard({
    super.key,
    required this.listing,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kNavyCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kNavyMid, width: 1),
        ),
        child: Row(
          children: [
            // Category icon container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: kGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _categoryIcon(listing.category),
                color: kGold,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: kGold.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          listing.category,
                          style: const TextStyle(
                              color: kGold, fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    listing.address,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Trailing (edit/delete) or chevron
            if (trailing != null)
              trailing!
            else
              const Icon(Icons.chevron_right, color: kWhite40),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Hospital':
        return Icons.local_hospital_outlined;
      case 'Police Station':
        return Icons.local_police_outlined;
      case 'Library':
        return Icons.local_library_outlined;
      case 'Restaurant':
        return Icons.restaurant_outlined;
      case 'Café':
        return Icons.coffee_outlined;
      case 'Park':
        return Icons.park_outlined;
      case 'Tourist Attraction':
        return Icons.photo_camera_outlined;
      case 'Pharmacy':
        return Icons.medication_outlined;
      case 'Utility Office':
        return Icons.business_outlined;
      default:
        return Icons.place_outlined;
    }
  }
}
