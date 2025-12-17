import 'package:flutter/material.dart';

/// Design System Spacing Constants
///
/// Provides consistent spacing values across the application.
/// All values are in logical pixels (dp/pt).
///
/// Usage:
/// ```dart
/// Padding(
///   padding: EdgeInsets.all(DSSpacing.md),
///   child: child,
/// )
/// ```
class DSSpacing {
  DSSpacing._();

  // Base spacing values
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 48.0;
  static const double massive = 64.0;

  // Common padding values
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);

  // Horizontal padding
  static const EdgeInsets paddingHorizontalXS = EdgeInsets.symmetric(
    horizontal: xs,
  );
  static const EdgeInsets paddingHorizontalSM = EdgeInsets.symmetric(
    horizontal: sm,
  );
  static const EdgeInsets paddingHorizontalMD = EdgeInsets.symmetric(
    horizontal: md,
  );
  static const EdgeInsets paddingHorizontalLG = EdgeInsets.symmetric(
    horizontal: lg,
  );
  static const EdgeInsets paddingHorizontalXL = EdgeInsets.symmetric(
    horizontal: xl,
  );
  static const EdgeInsets paddingHorizontalXXL = EdgeInsets.symmetric(
    horizontal: xxl,
  );

  // Vertical padding
  static const EdgeInsets paddingVerticalXS = EdgeInsets.symmetric(
    vertical: xs,
  );
  static const EdgeInsets paddingVerticalSM = EdgeInsets.symmetric(
    vertical: sm,
  );
  static const EdgeInsets paddingVerticalMD = EdgeInsets.symmetric(
    vertical: md,
  );
  static const EdgeInsets paddingVerticalLG = EdgeInsets.symmetric(
    vertical: lg,
  );
  static const EdgeInsets paddingVerticalXL = EdgeInsets.symmetric(
    vertical: xl,
  );
  static const EdgeInsets paddingVerticalXXL = EdgeInsets.symmetric(
    vertical: xxl,
  );

  // Common gaps for Flex widgets
  static const double gapXS = xs;
  static const double gapSM = sm;
  static const double gapMD = md;
  static const double gapLG = lg;
  static const double gapXL = xl;
  static const double gapXXL = xxl;

  // Screen margins
  static const double screenMargin = lg;
  static const EdgeInsets screenPadding = EdgeInsets.all(screenMargin);
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(
    horizontal: screenMargin,
  );
  static const EdgeInsets screenPaddingVertical = EdgeInsets.symmetric(
    vertical: screenMargin,
  );

  // Card padding
  static const double cardPadding = lg;
  static const EdgeInsets cardPaddingAll = EdgeInsets.all(cardPadding);

  // List item padding
  static const double listItemPadding = lg;
  static const EdgeInsets listItemPaddingAll = EdgeInsets.all(listItemPadding);
  static const EdgeInsets listItemPaddingHorizontal = EdgeInsets.symmetric(
    horizontal: listItemPadding,
  );
  static const EdgeInsets listItemPaddingVertical = EdgeInsets.symmetric(
    vertical: listItemPadding,
  );

  // Section spacing
  static const double sectionSpacing = xxl;
  static const double subsectionSpacing = lg;

  // Icon padding
  static const double iconPadding = sm;
  static const EdgeInsets iconPaddingAll = EdgeInsets.all(iconPadding);
}

/// Design System Border Radius Constants
class DSBorderRadius {
  DSBorderRadius._();

  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double circular = 999.0;

  // Common border radius values
  static const Radius radiusXS = Radius.circular(xs);
  static const Radius radiusSM = Radius.circular(sm);
  static const Radius radiusMD = Radius.circular(md);
  static const Radius radiusLG = Radius.circular(lg);
  static const Radius radiusXL = Radius.circular(xl);
  static const Radius radiusXXL = Radius.circular(xxl);

  // BorderRadius objects
  static const BorderRadius borderRadiusXS = BorderRadius.all(radiusXS);
  static const BorderRadius borderRadiusSM = BorderRadius.all(radiusSM);
  static const BorderRadius borderRadiusMD = BorderRadius.all(radiusMD);
  static const BorderRadius borderRadiusLG = BorderRadius.all(radiusLG);
  static const BorderRadius borderRadiusXL = BorderRadius.all(radiusXL);
  static const BorderRadius borderRadiusXXL = BorderRadius.all(radiusXXL);
  static const BorderRadius borderRadiusCircular = BorderRadius.all(
    Radius.circular(circular),
  );

  // Top-only border radius
  static const BorderRadius borderRadiusTopMD = BorderRadius.vertical(
    top: radiusMD,
  );
  static const BorderRadius borderRadiusTopLG = BorderRadius.vertical(
    top: radiusLG,
  );

  // Bottom-only border radius
  static const BorderRadius borderRadiusBottomMD = BorderRadius.vertical(
    bottom: radiusMD,
  );
  static const BorderRadius borderRadiusBottomLG = BorderRadius.vertical(
    bottom: radiusLG,
  );
}

/// Design System Elevation Constants
class DSElevation {
  DSElevation._();

  static const double none = 0.0;
  static const double xs = 1.0;
  static const double sm = 2.0;
  static const double md = 4.0;
  static const double lg = 8.0;
  static const double xl = 12.0;
  static const double xxl = 16.0;
}

/// Design System Icon Sizes
class DSIconSize {
  DSIconSize._();

  static const double xs = 16.0;
  static const double sm = 20.0;
  static const double md = 24.0;
  static const double lg = 32.0;
  static const double xl = 40.0;
  static const double xxl = 48.0;
  static const double huge = 64.0;
  static const double massive = 96.0;
}

/// Design System Breakpoints for Responsive Design
class DSBreakpoints {
  DSBreakpoints._();

  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1800;

  /// Check if screen width is mobile
  static bool isMobile(double width) => width < tablet;

  /// Check if screen width is tablet
  static bool isTablet(double width) => width >= tablet && width < desktop;

  /// Check if screen width is desktop
  static bool isDesktop(double width) => width >= desktop;

  /// Check if screen width is large desktop
  static bool isLargeDesktop(double width) => width >= largeDesktop;
}

/// Design System Duration Constants for Animations
class DSDurations {
  DSDurations._();

  // Animation durations
  static const Duration instant = Duration(milliseconds: 0);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration verySlow = Duration(milliseconds: 500);

  // Page transitions
  static const Duration pageTransition = Duration(milliseconds: 300);

  // Snackbar/Toast durations
  static const Duration snackBarShort = Duration(seconds: 2);
  static const Duration snackBarMedium = Duration(seconds: 4);
  static const Duration snackBarLong = Duration(seconds: 6);

  // Debounce durations
  static const Duration debounceShort = Duration(milliseconds: 300);
  static const Duration debounceMedium = Duration(milliseconds: 500);
  static const Duration debounceLong = Duration(milliseconds: 1000);
}

/// Design System Curves for Animations
class DSCurves {
  DSCurves._();

  static const Curve standard = Curves.easeInOutCubic;
  static const Curve accelerate = Curves.easeIn;
  static const Curve decelerate = Curves.easeOut;
  static const Curve emphasized = Curves.easeInOutQuart;
  static const Curve bounce = Curves.bounceOut;
}

/// Design System Opacity Values
class DSOpacity {
  DSOpacity._();

  static const double disabled = 0.38;
  static const double inactive = 0.60;
  static const double hover = 0.08;
  static const double focus = 0.12;
  static const double selected = 0.16;
  static const double overlay = 0.90;
}

/// Design System Z-Index for Layering
class DSZIndex {
  DSZIndex._();

  static const int background = 0;
  static const int content = 1;
  static const int elevated = 10;
  static const int drawer = 50;
  static const int modal = 100;
  static const int dropdown = 150;
  static const int overlay = 200;
  static const int tooltip = 300;
  static const int snackbar = 400;
  static const int dialog = 500;
}

/// Design System Helper Methods
class DSHelpers {
  DSHelpers._();

  /// Get responsive padding based on screen width
  static EdgeInsets getResponsivePadding(double screenWidth) {
    if (DSBreakpoints.isMobile(screenWidth)) {
      return DSSpacing.paddingLG;
    } else if (DSBreakpoints.isTablet(screenWidth)) {
      return DSSpacing.paddingXL;
    } else {
      return DSSpacing.paddingXXL;
    }
  }

  /// Get responsive font scale based on screen width
  static double getResponsiveFontScale(double screenWidth) {
    if (DSBreakpoints.isMobile(screenWidth)) {
      return 1.0;
    } else if (DSBreakpoints.isTablet(screenWidth)) {
      return 1.1;
    } else {
      return 1.2;
    }
  }

  /// Get responsive columns for grid
  static int getResponsiveColumns(double screenWidth) {
    if (DSBreakpoints.isMobile(screenWidth)) {
      return 1;
    } else if (DSBreakpoints.isTablet(screenWidth)) {
      return 2;
    } else if (DSBreakpoints.isDesktop(screenWidth)) {
      return 3;
    } else {
      return 4;
    }
  }
}
