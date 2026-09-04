part of 'components.dart';

/// E-Ink scroll physics: release to stop immediately, no ballistic inertia.
/// Only applied when eInkMode is enabled.

class EInkNoInertiaScrollPhysics extends ClampingScrollPhysics {
  const EInkNoInertiaScrollPhysics({super.parent});

  @override
  EInkNoInertiaScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      EInkNoInertiaScrollPhysics(parent: buildParent(ancestor));

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if (position.outOfRange) {
      return super.createBallisticSimulation(position, velocity);
    }
    return null;
  }
}

class EInkNoInertiaBouncingScrollPhysics extends BouncingScrollPhysics {
  const EInkNoInertiaBouncingScrollPhysics({super.parent});

  @override
  EInkNoInertiaBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      EInkNoInertiaBouncingScrollPhysics(parent: buildParent(ancestor));

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // Keep edge spring-back: chapter change detection relies on overscroll.
    if (position.outOfRange) {
      return super.createBallisticSimulation(position, velocity);
    }
    return null;
  }
}

class EInkScrollBehavior extends MaterialScrollBehavior {
  const EInkScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const EInkNoInertiaScrollPhysics();
}
