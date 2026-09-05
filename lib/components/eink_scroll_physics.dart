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
    if (position.outOfRange) {
      // Instant snap to nearest edge: zero intermediate frames, no ghosting.
      // Chapter-change detection reads position during drag (onScroll),
      // so it does not rely on the release animation.
      final double target = position.pixels < position.minScrollExtent
          ? position.minScrollExtent
          : position.maxScrollExtent;
      return _SnapBackSimulation(target);
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

class _SnapBackSimulation extends Simulation {
  _SnapBackSimulation(this.target);

  final double target;

  @override
  double x(double time) => target;

  @override
  double dx(double time) => 0;

  @override
  bool isDone(double time) => true;
}
