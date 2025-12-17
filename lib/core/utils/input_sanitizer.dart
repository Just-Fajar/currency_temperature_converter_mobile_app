/// Input sanitization and validation utilities for security
///
/// Prevents:
/// - XSS (Cross-Site Scripting) attacks
/// - SQL Injection
/// - Invalid data formats
/// - Malicious input
///
/// Use before storing or displaying user input.
class InputSanitizer {
  // ==================== XSS Prevention ====================

  /// Sanitize HTML/XML special characters to prevent XSS
  ///
  /// Escapes: < > & " '
  ///
  /// Example:
  /// ```dart
  /// final safe = InputSanitizer.sanitizeHtml('<script>alert("xss")</script>');
  /// // Result: &lt;script&gt;alert(&quot;xss&quot;)&lt;/script&gt;
  /// ```
  static String sanitizeHtml(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;');
  }

  /// Remove all HTML tags from input
  ///
  /// Example:
  /// ```dart
  /// final clean = InputSanitizer.stripHtml('<p>Hello</p>');
  /// // Result: Hello
  /// ```
  static String stripHtml(String input) {
    return input.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  // ==================== String Sanitization ====================

  /// Trim whitespace and remove control characters
  ///
  /// Example:
  /// ```dart
  /// final clean = InputSanitizer.sanitizeString('  Hello\n\r\t  ');
  /// // Result: Hello
  /// ```
  static String sanitizeString(String input) {
    return input.trim().replaceAll(
      RegExp(r'[\x00-\x1F\x7F]'),
      '',
    ); // Remove control chars
  }

  /// Remove multiple whitespaces
  ///
  /// Example:
  /// ```dart
  /// final clean = InputSanitizer.normalizeWhitespace('Hello    World');
  /// // Result: Hello World
  /// ```
  static String normalizeWhitespace(String input) {
    return input.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Sanitize email input
  ///
  /// Converts to lowercase and trims whitespace
  static String sanitizeEmail(String email) {
    return email.trim().toLowerCase();
  }

  // ==================== Number Sanitization ====================

  /// Extract and sanitize number from input
  ///
  /// Example:
  /// ```dart
  /// final num = InputSanitizer.sanitizeNumber('$1,234.56');
  /// // Result: 1234.56
  /// ```
  static String sanitizeNumber(String input) {
    return input.replaceAll(RegExp(r'[^\d.-]'), '');
  }

  /// Sanitize integer input
  static String sanitizeInteger(String input) {
    return input.replaceAll(RegExp(r'[^\d-]'), '');
  }

  // ==================== Currency Sanitization ====================

  /// Sanitize currency code (must be 3 uppercase letters)
  ///
  /// Example:
  /// ```dart
  /// final code = InputSanitizer.sanitizeCurrencyCode('usd');
  /// // Result: USD
  /// ```
  static String sanitizeCurrencyCode(String code) {
    return code.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
  }

  /// Validate and sanitize currency amount
  ///
  /// Returns null if invalid
  static double? sanitizeCurrencyAmount(String amount) {
    final sanitized = sanitizeNumber(amount);
    return double.tryParse(sanitized);
  }

  // ==================== Path Sanitization ====================

  /// Sanitize file path to prevent directory traversal attacks
  ///
  /// Removes: ../ ./ /
  ///
  /// Example:
  /// ```dart
  /// final safe = InputSanitizer.sanitizePath('../../../etc/passwd');
  /// // Result: etcpasswd
  /// ```
  static String sanitizePath(String path) {
    return path
        .replaceAll('..', '')
        .replaceAll('./', '')
        .replaceAll('/', '')
        .replaceAll('\\', '');
  }

  /// Sanitize filename (keep extension)
  ///
  /// Example:
  /// ```dart
  /// final name = InputSanitizer.sanitizeFilename('my file!@#.txt');
  /// // Result: my_file.txt
  /// ```
  static String sanitizeFilename(String filename) {
    // Keep extension
    final parts = filename.split('.');
    final extension = parts.length > 1 ? '.${parts.last}' : '';
    final name = parts.length > 1
        ? parts.sublist(0, parts.length - 1).join('.')
        : filename;

    // Replace special characters with underscore
    final sanitized = name
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();

    return '$sanitized$extension';
  }

  // ==================== Validation & Whitelisting ====================

  /// Validate input against whitelist
  ///
  /// Example:
  /// ```dart
  /// final valid = InputSanitizer.validateWhitelist(
  ///   'USD',
  ///   ['USD', 'EUR', 'GBP'],
  /// );
  /// // Result: true
  /// ```
  static bool validateWhitelist(String input, List<String> whitelist) {
    return whitelist.contains(input);
  }

  /// Sanitize using whitelist (returns empty if not in whitelist)
  ///
  /// Example:
  /// ```dart
  /// final safe = InputSanitizer.sanitizeWithWhitelist(
  ///   'USD',
  ///   ['USD', 'EUR', 'GBP'],
  /// );
  /// // Result: USD (or '' if not in whitelist)
  /// ```
  static String sanitizeWithWhitelist(String input, List<String> whitelist) {
    return whitelist.contains(input) ? input : '';
  }

  /// Check if string contains only alphanumeric characters
  static bool isAlphanumeric(String input) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(input);
  }

  /// Check if string contains only letters
  static bool isAlpha(String input) {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(input);
  }

  /// Check if string contains only numbers
  static bool isNumeric(String input) {
    return RegExp(r'^[0-9]+$').hasMatch(input);
  }

  // ==================== Length Validation ====================

  /// Truncate string to maximum length
  ///
  /// Example:
  /// ```dart
  /// final truncated = InputSanitizer.truncate('Hello World', 5);
  /// // Result: Hello
  /// ```
  static String truncate(String input, int maxLength) {
    if (input.length <= maxLength) return input;
    return input.substring(0, maxLength);
  }

  /// Validate string length
  static bool validateLength(String input, {int? min, int? max}) {
    if (min != null && input.length < min) return false;
    if (max != null && input.length > max) return false;
    return true;
  }

  // ==================== Special Character Handling ====================

  /// Remove all special characters (keep alphanumeric and space)
  ///
  /// Example:
  /// ```dart
  /// final clean = InputSanitizer.removeSpecialChars('Hello!@# World');
  /// // Result: Hello World
  /// ```
  static String removeSpecialChars(String input) {
    return input.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
  }

  /// Keep only allowed characters
  ///
  /// Example:
  /// ```dart
  /// final clean = InputSanitizer.keepOnly('ABC123!@#', 'A-Z0-9');
  /// // Result: ABC123
  /// ```
  static String keepOnly(String input, String allowedPattern) {
    final regex = RegExp('[^$allowedPattern]');
    return input.replaceAll(regex, '');
  }

  // ==================== SQL Injection Prevention ====================

  /// Escape single quotes for SQL (basic protection)
  ///
  /// Note: Use parameterized queries instead when possible
  ///
  /// Example:
  /// ```dart
  /// final safe = InputSanitizer.escapeSqlQuotes("O'Reilly");
  /// // Result: O''Reilly
  /// ```
  static String escapeSqlQuotes(String input) {
    return input.replaceAll("'", "''");
  }

  // ==================== URL Sanitization ====================

  /// Validate URL format
  static bool isValidUrl(String input) {
    try {
      final uri = Uri.parse(input);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Sanitize URL (encode special characters)
  static String sanitizeUrl(String input) {
    return Uri.encodeFull(input);
  }

  // ==================== Complete Sanitization ====================

  /// Apply comprehensive sanitization
  ///
  /// Suitable for user-generated text content.
  ///
  /// Example:
  /// ```dart
  /// final safe = InputSanitizer.sanitize(userInput);
  /// ```
  static String sanitize(String input) {
    return normalizeWhitespace(sanitizeString(stripHtml(input)));
  }

  /// Sanitize for display (prevent XSS but keep formatting)
  static String sanitizeForDisplay(String input) {
    return sanitizeHtml(normalizeWhitespace(input));
  }
}

/// Security validator for input validation
class SecurityValidator {
  /// Validate currency code format (3 uppercase letters)
  static bool isValidCurrencyCode(String code) {
    return RegExp(r'^[A-Z]{3}$').hasMatch(code);
  }

  /// Validate currency amount (positive number with max 2 decimals)
  static bool isValidCurrencyAmount(String amount) {
    return RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(amount);
  }

  /// Validate temperature value
  static bool isValidTemperature(String temp) {
    final parsed = double.tryParse(temp);
    if (parsed == null) return false;

    // Reasonable temperature range: -273.15°C to 1000°C
    return parsed >= -273.15 && parsed <= 1000;
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  /// Check for SQL injection patterns
  static bool hasSqlInjection(String input) {
    final sqlPatterns = [
      r"('|(--)|;|\/\*|\*\/|xp_|sp_)",
      r'(\bOR\b|\bAND\b).*=',
      r'UNION.*SELECT',
      r'DROP.*TABLE',
    ];

    for (final pattern in sqlPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(input)) {
        return true;
      }
    }

    return false;
  }

  /// Check for XSS patterns
  static bool hasXssPatterns(String input) {
    final xssPatterns = [
      r'<script',
      r'javascript:',
      r'onerror=',
      r'onload=',
      r'<iframe',
    ];

    final lowercase = input.toLowerCase();
    return xssPatterns.any((pattern) => lowercase.contains(pattern));
  }

  /// Comprehensive security check
  static bool isSecure(String input) {
    return !hasSqlInjection(input) && !hasXssPatterns(input);
  }
}
