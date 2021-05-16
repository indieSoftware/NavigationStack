import SwiftUI

/// The type of action performed on lifecycle events of views embedded in a NavigationView.
public typealias NavigationViewLifecycleAction = () -> Void

/// Wrapps a lifecycle action paired with an ID to make it equatable.
struct NavigationViewLifecycleActionWrapper: Equatable, Identifiable {
	/// A unique ID for each wrapper to make the associated action comparable.
	let id = UUID()
	/// The wrapped action.
	let action: NavigationViewLifecycleAction

	static func == (lhs: NavigationViewLifecycleActionWrapper, rhs: NavigationViewLifecycleActionWrapper) -> Bool {
		lhs.id == rhs.id
	}
}
