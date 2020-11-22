import SwiftUI

public extension AnyTransition {
	/**
	 A custom transition using a 3D geometry effect.

	 Source by [SwiftUI-Lab](https://swiftui-lab.com/advanced-transitions)
	 */
	static var tiltAndFly: AnyTransition {
		AnyTransition.modifier(active: TiltAndFlyEffect(animatableData: 0), identity: TiltAndFlyEffect(animatableData: 1))
	}
}

/**
 A custom geomentry effect tilting a view and let it fly away.

 Source by [SwiftUI-Lab](https://swiftui-lab.com/advanced-transitions)
 */
struct TiltAndFlyEffect: GeometryEffect {
	public var animatableData: Double

	public func effectValue(size: CGSize) -> ProjectionTransform {
		let rotationPercent = animatableData
		let angle = CGFloat(Angle(degrees: 90 * (1 - rotationPercent)).radians)

		var transform3d = CATransform3DIdentity
		transform3d.m34 = -1 / max(size.width, size.height)

		transform3d = CATransform3DRotate(transform3d, angle, 1, 0, 0)
		transform3d = CATransform3DTranslate(transform3d, -size.width / 2.0, -size.height / 2.0, 0)

		let affineTransform1 = ProjectionTransform(CGAffineTransform(translationX: size.width / 2.0, y: size.height / 2.0))
		let affineTransform2 = ProjectionTransform(CGAffineTransform(scaleX: CGFloat(animatableData * 2), y: CGFloat(animatableData * 2)))

		if animatableData <= 0.5 {
			return ProjectionTransform(transform3d).concatenating(affineTransform2).concatenating(affineTransform1)
		} else {
			return ProjectionTransform(transform3d).concatenating(affineTransform1)
		}
	}
}
