import SwiftUI

public extension AnyTransition {
	/**
	 A custom transition using a scaling circle.
	 */
	static var circleShape: AnyTransition {
		.modifier(
			active: ClipShapeModifier(shape: CircleShape(animatableData: 0), style: FillStyle()),
			identity: ClipShapeModifier(shape: CircleShape(animatableData: 1), style: FillStyle())
		)
	}
}

/**
 A circle shape which size can be animated.

 Source inspired by
 - [Paul Hudson: Hacking with Swift](https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-custom-transition)
 - [SwiftUI-Lab](https://swiftui-lab.com/advanced-transitions)
 */
public struct CircleShape: Shape {
	public var animatableData: CGFloat

	public func path(in rect: CGRect) -> Path {
		let maximumCircleDiameter = sqrt(rect.width * rect.width + rect.height * rect.height)
		let circleDiameter = maximumCircleDiameter * animatableData

		let posX = rect.midX - circleDiameter / 2.0
		let posY = rect.midY - circleDiameter / 2.0

		let circleRect = CGRect(x: posX, y: posY, width: circleDiameter, height: circleDiameter)

		return Circle().path(in: circleRect)
	}
}
