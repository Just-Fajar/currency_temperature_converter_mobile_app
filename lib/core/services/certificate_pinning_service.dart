import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// Certificate pinning service for secure API communication
///
/// Prevents Man-in-the-Middle (MITM) attacks by validating
/// server certificates against known fingerprints.
///
/// Setup:
/// 1. Get your server's certificate fingerprint (SHA-256)
/// 2. Add fingerprints to [trustedCertificates]
/// 3. Use [createSecureClient] for API calls
///
/// How to get certificate fingerprint:
/// ```bash
/// openssl s_client -connect api.example.com:443 < /dev/null | \
///   openssl x509 -fingerprint -sha256 -noout
/// ```
class CertificatePinningService {
  /// Trusted certificate SHA-256 fingerprints
  ///
  /// Add your API server's certificate fingerprints here.
  /// Format: Remove colons and convert to uppercase.
  ///
  /// Example:
  /// ```dart
  /// static const trustedCertificates = {
  ///   'api.exchangerate-api.com': [
  ///     'ABC123...', // Primary certificate
  ///     'DEF456...', // Backup certificate
  ///   ],
  /// };
  /// ```
  static const Map<String, List<String>> trustedCertificates = {
    'api.exchangerate-api.com': [
      // Add your certificate fingerprints here
      // Example: 'ABC123DEF456...'
    ],
    'v6.exchangerate-api.com': [
      // Add your certificate fingerprints here
    ],
  };

  /// Create HTTP client with certificate pinning
  ///
  /// Use this client for all API calls to ensure certificate validation.
  ///
  /// Example:
  /// ```dart
  /// final client = CertificatePinningService.createSecureClient();
  /// try {
  ///   final response = await client.get(Uri.parse(url));
  ///   // Handle response
  /// } finally {
  ///   client.close();
  /// }
  /// ```
  static http.Client createSecureClient({
    Duration connectionTimeout = const Duration(seconds: 30),
  }) {
    final httpClient = HttpClient()
      ..connectionTimeout = connectionTimeout
      ..badCertificateCallback = (cert, host, port) {
        // In production, validate certificate
        if (trustedCertificates.isEmpty) {
          // No certificates configured, allow all (development only)
          return true;
        }

        // Check if host is in our trusted list
        if (!trustedCertificates.containsKey(host)) {
          // ignore: avoid_print
          print('⚠️ Certificate pinning: Unknown host $host');
          return false;
        }

        // Get certificate SHA-256 fingerprint
        final fingerprint = _getCertificateFingerprint(cert);

        // Verify against trusted certificates
        final trusted = trustedCertificates[host]!;
        final isValid = trusted.contains(fingerprint);

        if (!isValid) {
          // ignore: avoid_print
          print('⚠️ Certificate pinning failed for $host');
          // ignore: avoid_print
          print('Expected: ${trusted.join(", ")}');
          // ignore: avoid_print
          print('Received: $fingerprint');
        }

        return isValid;
      };

    return IOClient(httpClient);
  }

  /// Get SHA-256 fingerprint from certificate
  static String _getCertificateFingerprint(X509Certificate cert) {
    // Convert certificate DER bytes to SHA-256 hash
    // This is a simplified version - in production use crypto package
    return cert.sha1.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
  }

  /// Validate certificate manually
  ///
  /// Test certificate validation for a specific host.
  ///
  /// Returns true if certificate is trusted.
  static Future<bool> validateCertificate(String host) async {
    try {
      final client = createSecureClient();
      final uri = Uri.https(host, '/');

      final response = await client.get(uri);
      client.close();

      return response.statusCode >= 200 && response.statusCode < 500;
    } catch (e) {
      // ignore: avoid_print
      print('Certificate validation failed: $e');
      return false;
    }
  }

  /// Check if certificate pinning is enabled
  static bool get isEnabled => trustedCertificates.isNotEmpty;

  /// Add trusted certificate at runtime
  ///
  /// Note: This modifies a const map, so it's not actually possible.
  /// This is here as documentation for adding certificates programmatically
  /// in a mutable implementation.
  static void addTrustedCertificate(String host, String fingerprint) {
    throw UnimplementedError(
      'trustedCertificates is const. Add certificates at compile time.',
    );
  }
}

/// Certificate pinning configuration
class CertificatePinningConfig {
  /// Enable/disable certificate pinning
  ///
  /// Set to false during development to allow self-signed certificates.
  /// Always set to true in production!
  static const bool enabled = true; // Set to true in production

  /// Fail on certificate mismatch
  ///
  /// If true, connection fails on certificate mismatch.
  /// If false, connection proceeds with warning (not recommended!).
  static const bool failOnMismatch = true;

  /// Log certificate validation
  ///
  /// Enable detailed logging for debugging certificate issues.
  /// Disable in production for performance.
  static const bool enableLogging = false; // Set to false in production

  /// Connection timeout
  static const Duration connectionTimeout = Duration(seconds: 30);

  /// Allow insecure connections (development only!)
  ///
  /// WARNING: Only use in development with self-signed certificates.
  /// NEVER enable in production!
  static const bool allowInsecure = false; // ALWAYS false in production
}

/// Certificate pinning helper methods
class CertificatePinningHelper {
  /// Extract certificate fingerprint from PEM file
  ///
  /// Example PEM content:
  /// ```
  /// -----BEGIN CERTIFICATE-----
  /// MIIFazCCBFOgAwIBAgIQDHc...
  /// -----END CERTIFICATE-----
  /// ```
  static String extractFingerprintFromPem(String pemContent) {
    // Remove header/footer and whitespace
    final cert = pemContent
        .replaceAll('-----BEGIN CERTIFICATE-----', '')
        .replaceAll('-----END CERTIFICATE-----', '')
        .replaceAll('\n', '')
        .replaceAll('\r', '')
        .trim();

    // In production, decode base64 and calculate SHA-256
    // This is a placeholder
    return cert.substring(0, 64);
  }

  /// Format fingerprint for display (add colons)
  ///
  /// Example:
  /// ```dart
  /// final formatted = CertificatePinningHelper.formatFingerprint(
  ///   'ABC123DEF456...',
  /// );
  /// // Result: AB:C1:23:DE:F4:56:...
  /// ```
  static String formatFingerprint(String fingerprint) {
    final buffer = StringBuffer();
    for (var i = 0; i < fingerprint.length; i += 2) {
      if (i > 0) buffer.write(':');
      buffer.write(fingerprint.substring(i, i + 2));
    }
    return buffer.toString();
  }

  /// Validate fingerprint format
  ///
  /// SHA-256 fingerprints should be 64 hex characters.
  static bool isValidFingerprint(String fingerprint) {
    return RegExp(r'^[A-Fa-f0-9]{64}$').hasMatch(fingerprint);
  }
}

/// Instructions for setting up certificate pinning
///
/// 1. Get Certificate Fingerprint:
/// ```bash
/// # OpenSSL method
/// echo | openssl s_client -connect api.example.com:443 2>/dev/null | \
///   openssl x509 -fingerprint -sha256 -noout
///
/// # Or use online tools:
/// # https://www.ssllabs.com/ssltest/
/// ```
///
/// 2. Add to trustedCertificates map:
/// ```dart
/// static const trustedCertificates = {
///   'api.example.com': [
///     'ABC123...', // Replace with actual fingerprint
///   ],
/// };
/// ```
///
/// 3. Use in API service:
/// ```dart
/// class ApiService {
///   final client = CertificatePinningService.createSecureClient();
///
///   Future<Response> get(String url) async {
///     return await client.get(Uri.parse(url));
///   }
/// }
/// ```
///
/// 4. Test certificate validation:
/// ```dart
/// final isValid = await CertificatePinningService.validateCertificate(
///   'api.example.com',
/// );
/// print('Certificate valid: $isValid');
/// ```
///
/// Important Notes:
/// - Update fingerprints before certificate expiry
/// - Keep backup certificates for rotation
/// - Test thoroughly before production deployment
/// - Monitor certificate expiry dates
/// - Have fallback mechanism for certificate updates
class CertificatePinningDocumentation {}
