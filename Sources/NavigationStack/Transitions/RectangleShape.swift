import SwiftUI

public extension AnyTransition {
	/**
	 A custom transition using a scaling rectangle.
	 */
	static var rectangleShape: AnyTransition {
		AnyTransition.modifier(
			active: ClipShapeModifier(shape: RectangleShape(animatableData: 1), style: FillStyle()),
			identity: ClipShapeModifier(shape: RectangleShape(animatableData: 0), style: FillStyle())
		)
	}
}

/**
 A rectangle shape which size can be animated.

 Source inspired by [SwiftUI-Lab](https://swiftui-lab.com/advanced-transitions)
 */
public struct RectangleShape: Shape {
	public var animatableData: CGFloat

	public func path(in rect: CGRect) -> Path {
		var path = Path()

		path.addRect(rect.insetBy(dx: animatableData * rect.width / 2.0, dy: animatableData * rect.height / 2.0))

		return path
	}
}
