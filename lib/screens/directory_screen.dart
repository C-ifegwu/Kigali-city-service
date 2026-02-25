import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/listing_provider.dart';
import '../utils/theme.dart';
import '../widgets/listing_card.dart';
import '../widgets/category_chips.dart';
import 'listing_detail_screen.dart';
import 'add_edit_listing_screen.dart';

class DirectoryScreen extends StatelessWidget {
  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listingProv = context.watch<ListingProvider>();
    final filtered = listingProv.filteredListings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kigali City'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: kGold),
            tooltip: 'Add Listing',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AddEditListingScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category chips
          const CategoryChips(),

          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              onChanged: (v) => listingProv.setSearch(v),
              decoration: const InputDecoration(
                hintText: 'Search for a service...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          // Near You header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text('Near You',
                style: Theme.of(context).textTheme.titleMedium),
          ),

          // Content
          Expanded(
            child: listingProv.isLoading && filtered.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(color: kGold))
                : listingProv.error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.redAccent, size: 48),
                            const SizedBox(height: 12),
                            Text(listingProv.error!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.redAccent)),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {
                                listingProv.clearError();
                                listingProv.startListeningAll();
                              },
                              child: const Text('Retry',
                                  style: TextStyle(color: kGold)),
                            ),
                          ],
                        ),
                      )
                    : filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.search_off,
                                    size: 48, color: kWhite40),
                                const SizedBox(height: 12),
                                Text(
                                  'No listings found',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, i) {
                              final listing = filtered[i];
                              return ListingCard(
                                listing: listing,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ListingDetailScreen(
                                        listing: listing),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
