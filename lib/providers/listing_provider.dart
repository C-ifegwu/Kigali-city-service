import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/listing.dart';
import '../services/listing_service.dart';

class ListingProvider extends ChangeNotifier {
  final ListingService _listingService;

  ListingProvider(this._listingService);

  List<Listing> _allListings = [];
  List<Listing> _myListings = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isLoading = false;
  String? _error;

  StreamSubscription<List<Listing>>? _allSub;
  StreamSubscription<List<Listing>>? _mySub;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<Listing> get filteredListings {
    List<Listing> result = List.from(_allListings);
    if (_selectedCategory != 'All') {
      result = result
          .where((l) => l.category == _selectedCategory)
          .toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where((l) =>
              l.name.toLowerCase().contains(q) ||
              l.address.toLowerCase().contains(q) ||
              l.category.toLowerCase().contains(q))
          .toList();
    }
    return result;
  }

  List<Listing> get myListings => _myListings;

  /// All listings (unfiltered) for map view
  List<Listing> get allListings => _allListings;

  void startListeningAll() {
    _isLoading = true;
    notifyListeners();
    _allSub?.cancel();
    _allSub = _listingService.getListingsStream().listen(
      (listings) {
        _allListings = listings;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Failed to load listings: $e';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void startListeningUserListings(String uid) {
    _mySub?.cancel();
    _mySub = _listingService.getUserListingsStream(uid).listen(
      (listings) {
        _myListings = listings;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Failed to load your listings: $e';
        notifyListeners();
      },
    );
  }

  void stopListening() {
    _allSub?.cancel();
    _mySub?.cancel();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<bool> addListing(Listing listing) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _listingService.addListing(listing);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to add listing: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateListing(Listing listing) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _listingService.updateListing(listing);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update listing: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteListing(String id) async {
    _error = null;
    notifyListeners();
    try {
      await _listingService.deleteListing(id);
      return true;
    } catch (e) {
      _error = 'Failed to delete listing: $e';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _allSub?.cancel();
    _mySub?.cancel();
    super.dispose();
  }
}
