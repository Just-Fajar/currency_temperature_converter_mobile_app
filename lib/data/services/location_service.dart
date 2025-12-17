import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Service for GPS and location operations
class LocationService {
  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Get current position
  Future<Position?> getCurrentPosition() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check permissions
      LocationPermission permission = await checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get position
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  /// Detect country from coordinates using reverse geocoding
  Future<String?> detectCountryCode(Position position) async {
    try {
      // Use geocoding package for reverse geocoding
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        // Return ISO country code (e.g., "US", "GB", "ID")
        return placemark.isoCountryCode;
      }

      return null;
    } catch (e) {
      debugPrint('Error detecting country: $e');
      return null;
    }
  }

  /// Map country code to currency code
  String? countryCodeToCurrency(String countryCode) {
    // Comprehensive mapping of countries to their currencies
    const Map<String, String> countryToCurrency = {
      // Americas
      'US': 'USD', // United States Dollar
      'CA': 'CAD', // Canadian Dollar
      'MX': 'USD', // Mexico (often uses USD)
      'BR': 'USD', // Brazil
      'AR': 'USD', // Argentina
      // Europe
      'GB': 'GBP', // British Pound
      'CH': 'CHF', // Swiss Franc
      'AT': 'EUR', // Austria
      'BE': 'EUR', // Belgium
      'FR': 'EUR', // France
      'DE': 'EUR', // Germany
      'IT': 'EUR', // Italy
      'ES': 'EUR', // Spain
      'NL': 'EUR', // Netherlands
      'PT': 'EUR', // Portugal
      'IE': 'EUR', // Ireland
      'GR': 'EUR', // Greece
      // Asia
      'JP': 'JPY', // Japanese Yen
      'CN': 'CNY', // Chinese Yuan
      'ID': 'IDR', // Indonesian Rupiah
      'SG': 'SGD', // Singapore Dollar
      'MY': 'MYR', // Malaysian Ringgit
      'TH': 'THB', // Thai Baht
      'KR': 'KRW', // South Korean Won
      'HK': 'HKD', // Hong Kong Dollar
      'IN': 'INR', // Indian Rupee
      'PH': 'USD', // Philippines
      'VN': 'USD', // Vietnam
      // Oceania
      'AU': 'AUD', // Australian Dollar
      'NZ': 'AUD', // New Zealand
      // Middle East
      'AE': 'USD', // UAE
      'SA': 'USD', // Saudi Arabia
    };

    return countryToCurrency[countryCode.toUpperCase()];
  }

  /// Auto-detect currency based on user location
  Future<String?> detectUserCurrency() async {
    // Web browsers require HTTPS for geolocation
    if (kIsWeb) {
      debugPrint(
        '⚠️ GPS on web requires HTTPS. Running on HTTP - GPS disabled.',
      );
      debugPrint('💡 Tip: Use mobile/desktop app or deploy to HTTPS for GPS.');
      return null;
    }

    try {
      final position = await getCurrentPosition();
      if (position == null) return null;

      final countryCode = await detectCountryCode(position);
      if (countryCode == null) return null;

      return countryCodeToCurrency(countryCode);
    } catch (e) {
      debugPrint('Error detecting user currency: $e');
      return null;
    }
  }
}
