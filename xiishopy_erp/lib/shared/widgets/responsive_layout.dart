/// Xiishopy ERP - Responsive Layout Widget
/// Provides adaptive layouts that work across mobile, tablet, and desktop.
/// Uses breakpoints: mobile < 600, tablet 600-900, desktop > 900
library;

import 'package:flutter/material.dart';

/// Breakpoint constants for responsive design
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < mobile;
  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= mobile && MediaQuery.of(context).size.width < tablet;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= tablet;
  static bool isWide(BuildContext context) => MediaQuery.of(context).size.width >= tablet;

  static double width(BuildContext context) => MediaQuery.of(context).size.width;
  static double height(BuildContext context) => MediaQuery.of(context).size.height;

  /// Returns responsive padding based on screen width
  static EdgeInsets padding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(12);
    if (isTablet(context)) return const EdgeInsets.all(20);
    return const EdgeInsets.all(24);
  }

  /// Returns responsive font size
  static double fontSize(BuildContext context, double base) {
    if (isMobile(context)) return base;
    if (isTablet(context)) return base * 1.1;
    return base * 1.2;
  }
}

/// Adaptive layout that shows different widgets based on screen size
class AdaptiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const AdaptiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (Breakpoints.isMobile(context)) {
      return mobile;
    }
    if (Breakpoints.isTablet(context) && tablet != null) {
      return tablet!;
    }
    return desktop;
  }
}

/// Responsive grid that adjusts columns based on width
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width < 600 ? 1 : width < 900 ? 2 : width < 1200 ? 3 : 4;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(spacing),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: width < 600 ? 3 : 2,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Responsive sidebar that collapses to bottom nav on mobile
class ResponsiveScaffold extends StatelessWidget {
  final Widget? appBar;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Widget body;
  final List<BottomNavigationBarItem>? navItems;
  final int? currentIndex;
  final ValueChanged<int>? onNavTap;

  const ResponsiveScaffold({
    super.key,
    this.appBar,
    this.drawer,
    this.bottomNavigationBar,
    required this.body,
    this.navItems,
    this.currentIndex,
    this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: isMobile ? appBar as PreferredSizeWidget? : null,
      drawer: isMobile ? drawer : null,
      body: isMobile ? body : Row(
        children: [
          if (drawer != null) drawer!,
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: isMobile && navItems != null
          ? BottomNavigationBar(
              backgroundColor: const Color(0xFF16213E),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white54,
              currentIndex: currentIndex ?? 0,
              onTap: onNavTap,
              type: BottomNavigationBarType.fixed,
              items: navItems!,
            )
          : null,
    );
  }
}

/// Responsive data table that switches to card list on mobile
class ResponsiveDataTable<T> extends StatelessWidget {
  final List<T> items;
  final List<String> headers;
  final Widget Function(T item) cardBuilder;
  final DataRow Function(T item) rowBuilder;

  const ResponsiveDataTable({
    super.key,
    required this.items,
    required this.headers,
    required this.cardBuilder,
    required this.rowBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (Breakpoints.isMobile(context)) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) => cardBuilder(items[index]),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color(0xFF16213E)),
        dataRowColor: WidgetStateProperty.all(const Color(0xFF1A1A2E)),
        headingTextStyle: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
        dataTextStyle: const TextStyle(color: Colors.white),
        columns: headers.map((h) => DataColumn(label: Text(h))).toList(),
        rows: items.map(rowBuilder).toList(),
      ),
    );
  }
}