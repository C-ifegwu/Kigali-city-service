import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/listing.dart';
import '../utils/theme.dart';
import 'add_edit_listing_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/listing_provider.dart';

class ListingDetailScreen extends StatelessWidget {
  final Listing listing;
  const ListingDetailScreen({super.key, required this.listing});

  Future<void> _launchNavigation(BuildContext context) async {
    final uri = Uri.parse(
        'google.navigation:q=${listing.latitude},${listing.longitude}&mode=d');
    final fallbackUri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=${listing.latitude},${listing.longitude}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();
    final prov = context.read<ListingProvider>();
    final isOwner = auth.firebaseUser?.uid == listing.createdBy;
    final markerPos = LatLng(listing.latitude, listing.longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text(listing.name,
            overflow: TextOverflow.ellipsis),
        actions: [
          if (isOwner)
            PopupMenuButton<String>(
              color: kNavyCard,
              onSelected: (v) async {
                if (v == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AddEditListingScreen(listing: listing),
                    ),
                  );
                } else if (v == 'delete') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: kNavyCard,
                      title: const Text('Delete Listing'),
                      content: Text(
                          'Delete "${listing.name}"? This cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel',
                              style: TextStyle(color: kWhite70)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true && context.mounted) {
                    await prov.deleteListing(listing.id);
                    if (context.mounted) Navigator.pop(context);
                  }
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined, color: kGold),
                    title: Text('Edit'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete_outline,
                        color: Colors.redAccent),
                    title: Text('Delete',
                        style: TextStyle(color: Colors.redAccent)),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Map Preview
            SizedBox(
              height: 220,
              child: GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: markerPos, zoom: 15),
                markers: {
                  Marker(
                    markerId: const MarkerId('detail_marker'),
                    position: markerPos,
                    infoWindow: InfoWindow(title: listing.name),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueOrange),
                  ),
                },
                zoomControlsEnabled: false,
                scrollGesturesEnabled: false,
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
                zoomGesturesEnabled: false,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  Chip(
                    label: Text(listing.category),
                    backgroundColor: kGold.withValues(alpha: 0.2),
                    labelStyle: const TextStyle(
                        color: kGold, fontWeight: FontWeight.w600),
                    side: BorderSide.none,
                  ),
                  const SizedBox(height: 12),
                  Text(listing.name,
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),

                  // Info rows
                  _infoRow(context, Icons.location_on_outlined,
                      listing.address),
                  const SizedBox(height: 10),
                  _infoRow(context, Icons.phone_outlined,
                      listing.contactNumber.isEmpty
                          ? 'Not provided'
                          : listing.contactNumber),
                  const SizedBox(height: 10),
                  _infoRow(context, Icons.my_location_outlined,
                      '${listing.latitude.toStringAsFixed(6)}, ${listing.longitude.toStringAsFixed(6)}'),
                  const SizedBox(height: 16),

                  // Description
                  Text('About',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kNavyCard,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(listing.description,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  const SizedBox(height: 24),

                  // Navigate button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchNavigation(context),
                      icon: const Icon(Icons.directions),
                      label: const Text('Get Directions'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: kGold),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
