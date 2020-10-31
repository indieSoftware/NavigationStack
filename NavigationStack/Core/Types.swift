import SwiftUI

// The content view is put into a closure to defer its rendering until it's needed instead of evaluating it immediately on construction.
// Also when using `AnyView` directly instead of wrapping it then a created binding by the model would need a reference to the model itself.
typealias ContentBuilder = () -> AnyView
