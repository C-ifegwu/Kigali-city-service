import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/listing_provider.dart';
import '../models/listing.dart';
import 'listing_detail_screen.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  static const _kigaliCenter = LatLng(-1.9441, 30.0619);

  Set<Marker> _buildMarkers(List<Listing> listings) {
    return listings.map((listing) {
      return Marker(
        markerId: MarkerId(listing.id),
        position: LatLng(listing.latitude, listing.longitude),
        infoWindow: InfoWindow(
          title: listing.name,
          snippet: listing.category,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ListingDetailScreen(listing: listing)),
          ),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final listings = context.watch<ListingProvider>().allListings;
    final markers = _buildMarkers(listings);

    return Scaffold(
      appBar: AppBar(title: const Text('Map View')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: _kigaliCenter,
          zoom: 13,
        ),
        markers: markers,
        onMapCreated: (controller) {},
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        mapType: MapType.normal,
      ),
    );
  }
}
