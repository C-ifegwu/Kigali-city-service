import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/listing_provider.dart';
import '../models/listing.dart';
import '../utils/theme.dart';
import '../widgets/listing_card.dart';
import 'listing_detail_screen.dart';
import 'add_edit_listing_screen.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  Future<void> _confirmDelete(
      BuildContext context, Listing listing, ListingProvider prov) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kNavyCard,
        title: const Text('Delete Listing'),
        content: Text('Delete "${listing.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: kWhite70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await prov.deleteListing(listing.id);
      if (context.mounted && prov.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(prov.error!),
              backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ListingProvider>();
    final myListings = prov.myListings;

    return Scaffold(
      appBar: AppBar(title: const Text('My Listings')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kGold,
        foregroundColor: kNavyDark,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditListingScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add Listing',
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: myListings.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_location_outlined,
                      size: 64, color: kGold),
                  const SizedBox(height: 16),
                  Text('No listings yet',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Tap the button below to add your first listing.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: myListings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final listing = myListings[i];
                return ListingCard(
                  listing: listing,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ListingDetailScreen(listing: listing),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: kGold),
                        tooltip: 'Edit',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AddEditListingScreen(listing: listing),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent),
                        tooltip: 'Delete',
                        onPressed: () =>
                            _confirmDelete(context, listing, prov),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
