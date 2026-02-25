import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing.dart';

class ListingService {
  final CollectionReference _listingsCol =
      FirebaseFirestore.instance.collection('listings');

  /// Stream of all listings, ordered by timestamp descending
  Stream<List<Listing>> getListingsStream() {
    return _listingsCol
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                Listing.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  /// Stream of listings belonging to a specific user
  /// NOTE: Uses client-side sort to avoid needing a Firestore composite index
  Stream<List<Listing>> getUserListingsStream(String uid) {
    return _listingsCol
        .where('createdBy', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      final listings = snapshot.docs
          .map((doc) =>
              Listing.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      // Sort client-side: newest first
      listings.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return listings;
    });
  }

  /// Add a new listing
  Future<void> addListing(Listing listing) async {
    await _listingsCol.add(listing.toMap());
  }

  /// Update an existing listing by ID
  Future<void> updateListing(Listing listing) async {
    await _listingsCol.doc(listing.id).update(listing.toMap());
  }

  /// Delete a listing by ID
  Future<void> deleteListing(String id) async {
    await _listingsCol.doc(id).delete();
  }
}
