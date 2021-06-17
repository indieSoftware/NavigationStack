// Issue report: https://github.com/indieSoftware/NavigationStack/issues/2
// Is it possible to use a timer or a dispatched action to trigger a navigation?

import NavigationStack
import SwiftUI

struct Experiment11: View {
	var body: some View {
		ContentView()
			.environmentObject(NavigationModel())
	}
}

private class ViewModel: ObservableObject {
	private var timer: Timer?
	@Published var ticks = 0
	func startTimer(navigationModel: NavigationModel) {
		ticks = 3
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
			self.ticks -= 1
			if self.ticks == 0 {
				timer.invalidate()
				self.timer = nil
				navigationModel.popContent(ContentView.id)
			}
		}
	}
}

private struct SecondScreen: View {
	@EnvironmentObject var navigationModel: NavigationModel
	@ObservedObject var model = ViewModel()
	var body: some View {
		ZStack {
			Color.orange
			VStack {
				Text("Timer: \(model.ticks)")
				Button(action: { // Don't press the button multiple times or multiple timers will be created
					print("Timer started")
					model.startTimer(navigationModel: navigationModel)
				}, label: {
					Text("Start pop in 3 seconds")
				})
			}
		}
	}
}

private struct ContentView: View {
	static let id = String(describing: Self.self)
	@EnvironmentObject var navigationModel: NavigationModel

	var body: some View {
		NavigationStackView(ContentView.id) {
			ZStack {
				Color.yellow
				Button(action: { // Don't press the button multiple times or the app will crash
					print("Timer started")
					DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
						print("Push executing")
						self.navigationModel.pushContent(ContentView.id) {
							SecondScreen()
						}
					}
				}, label: {
					Text("Start push in 3 seconds")
				})
			}
		}
	}
}
