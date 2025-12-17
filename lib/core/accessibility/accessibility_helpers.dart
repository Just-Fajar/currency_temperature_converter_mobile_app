import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Accessibility helpers and semantic wrappers for better app accessibility.
///
/// Provides utilities to make the app more accessible for users with
/// disabilities, including screen readers, voice control, and more.

/// Semantic wrapper for buttons with proper accessibility labels
class AccessibleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String label;
  final String? hint;
  final bool enabled;

  const AccessibleButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.label,
    this.hint,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      hint: hint,
      enabled: enabled,
      onTap: onPressed,
      child: child,
    );
  }
}

/// Semantic wrapper for images with descriptions
class AccessibleImage extends StatelessWidget {
  final Widget child;
  final String label;
  final String? hint;

  const AccessibleImage({
    super.key,
    required this.child,
    required this.label,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: label,
      hint: hint,
      child: ExcludeSemantics(child: child),
    );
  }
}

/// Semantic wrapper for text fields with proper labels
class AccessibleTextField extends StatelessWidget {
  final Widget child;
  final String label;
  final String? hint;
  final String? value;
  final bool isObscured;

  const AccessibleTextField({
    super.key,
    required this.child,
    required this.label,
    this.hint,
    this.value,
    this.isObscured = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: label,
      hint: hint,
      value: value,
      obscured: isObscured,
      child: child,
    );
  }
}

/// Semantic wrapper for links
class AccessibleLink extends StatelessWidget {
  final Widget child;
  final String label;
  final VoidCallback? onTap;

  const AccessibleLink({
    super.key,
    required this.child,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(link: true, label: label, onTap: onTap, child: child);
  }
}

/// Semantic wrapper for headings
class AccessibleHeading extends StatelessWidget {
  final Widget child;
  final String text;

  const AccessibleHeading({super.key, required this.child, required this.text});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      label: text,
      child: ExcludeSemantics(child: child),
    );
  }
}

/// Announce text to screen readers
class ScreenReaderAnnouncement extends StatefulWidget {
  final String message;
  final Widget child;

  const ScreenReaderAnnouncement({
    super.key,
    required this.message,
    required this.child,
  });

  @override
  State<ScreenReaderAnnouncement> createState() =>
      _ScreenReaderAnnouncementState();
}

class _ScreenReaderAnnouncementState extends State<ScreenReaderAnnouncement> {
  @override
  void initState() {
    super.initState();
    _announce();
  }

  @override
  void didUpdateWidget(ScreenReaderAnnouncement oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message != widget.message) {
      _announce();
    }
  }

  void _announce() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Updated for new Flutter API - requires FlutterView
      final view = WidgetsBinding.instance.platformDispatcher.views.first;
      SemanticsService.sendAnnouncement(
        view,
        widget.message,
        TextDirection.ltr,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Helper class for accessibility utilities
class AccessibilityHelper {
  AccessibilityHelper._();

  /// Check if screen reader is enabled
  static bool isScreenReaderEnabled(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }

  /// Check if bold text is enabled
  static bool isBoldTextEnabled(BuildContext context) {
    return MediaQuery.of(context).boldText;
  }

  /// Get text scale factor
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.textScalerOf(context).scale(1.0);
  }

  /// Check if high contrast is enabled
  static bool isHighContrastEnabled(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }

  /// Check if reduce motion is enabled
  static bool isReduceMotionEnabled(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Get accessible duration (respects reduce motion setting)
  static Duration getAccessibleDuration(
    BuildContext context,
    Duration normalDuration,
  ) {
    return isReduceMotionEnabled(context) ? Duration.zero : normalDuration;
  }

  /// Announce message to screen reader
  static void announce(String message) {
    // Updated for new Flutter API - requires FlutterView
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    SemanticsService.sendAnnouncement(view, message, TextDirection.ltr);
  }

  /// Announce with assertiveness level
  static void announceWithPriority(
    String message, {
    Assertiveness assertiveness = Assertiveness.polite,
  }) {
    // Updated for new Flutter API - requires FlutterView
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    SemanticsService.sendAnnouncement(
      view,
      message,
      TextDirection.ltr,
      assertiveness: assertiveness,
    );
  }

  /// Create accessible hint for screen readers
  static String createHint({required String action, String? context}) {
    if (context != null) {
      return '$action, $context';
    }
    return action;
  }

  /// Format currency for screen readers
  static String formatCurrencyForScreenReader(
    double amount,
    String currencyCode,
  ) {
    return '$amount $currencyCode';
  }

  /// Format temperature for screen readers
  static String formatTemperatureForScreenReader(double value, String unit) {
    return '$value degrees $unit';
  }

  /// Format date for screen readers
  static String formatDateForScreenReader(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)}, ${date.year}';
  }

  static String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}

/// Widget extension for accessibility
extension AccessibilityExtension on Widget {
  /// Add semantic label
  Widget withLabel(String label) {
    return Semantics(
      label: label,
      child: ExcludeSemantics(child: this),
    );
  }

  /// Add semantic hint
  Widget withHint(String hint) {
    return Semantics(hint: hint, child: this);
  }

  /// Mark as heading
  Widget asHeading() {
    return Semantics(header: true, child: this);
  }

  /// Mark as button
  Widget asButton({required String label, VoidCallback? onTap}) {
    return Semantics(button: true, label: label, onTap: onTap, child: this);
  }

  /// Exclude from semantics
  Widget excludeFromSemantics() {
    return ExcludeSemantics(child: this);
  }

  /// Add live region for dynamic content
  Widget asLiveRegion() {
    return Semantics(liveRegion: true, child: this);
  }
}

/// Accessible Icon with semantic label
class AccessibleIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final double? size;
  final Color? color;

  const AccessibleIcon({
    super.key,
    required this.icon,
    required this.label,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: ExcludeSemantics(
        child: Icon(icon, size: size, color: color),
      ),
    );
  }
}

/// Accessible progress indicator
class AccessibleProgressIndicator extends StatelessWidget {
  final String label;
  final double? value;

  const AccessibleProgressIndicator({
    super.key,
    required this.label,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final progressText = value != null
        ? '${(value! * 100).toStringAsFixed(0)}% complete'
        : 'Loading';

    return Semantics(
      label: label,
      value: progressText,
      child: CircularProgressIndicator(value: value),
    );
  }
}

/// Accessible slider with value announcements
class AccessibleSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final String label;
  final String Function(double)? valueFormatter;

  const AccessibleSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.label,
    this.valueFormatter,
  });

  @override
  Widget build(BuildContext context) {
    final formattedValue = valueFormatter?.call(value) ?? value.toString();

    return Semantics(
      slider: true,
      label: label,
      value: formattedValue,
      child: Slider(value: value, min: min, max: max, onChanged: onChanged),
    );
  }
}

/// Accessible card with tap feedback
class AccessibleCard extends StatelessWidget {
  final Widget child;
  final String label;
  final String? hint;
  final VoidCallback? onTap;

  const AccessibleCard({
    super.key,
    required this.child,
    required this.label,
    this.hint,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: label,
      hint: hint,
      onTap: onTap,
      child: Card(child: child),
    );
  }
}

/// Focus node manager for keyboard navigation
class FocusManager extends StatefulWidget {
  final Widget child;
  final List<FocusNode> focusNodes;

  const FocusManager({
    super.key,
    required this.child,
    required this.focusNodes,
  });

  @override
  State<FocusManager> createState() => _FocusManagerState();
}

class _FocusManagerState extends State<FocusManager> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.focusNodes.isNotEmpty) {
      widget.focusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void nextFocus() {
    if (_currentIndex < widget.focusNodes.length - 1) {
      _currentIndex++;
      widget.focusNodes[_currentIndex].requestFocus();
    }
  }

  void previousFocus() {
    if (_currentIndex > 0) {
      _currentIndex--;
      widget.focusNodes[_currentIndex].requestFocus();
    }
  }
}
