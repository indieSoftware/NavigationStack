// Issue report: https://github.com/indieSoftware/NavigationStack/issues/1

import NavigationStack
import SwiftUI

struct Experiment10: View {
	var body: some View {
		if #available(iOS 14.0, *) {
			ContentView()
				.environmentObject(NavigationModel())
		} else {
			Text("iOS 14+ required")
		}
	}
}

@available(iOS 14.0, *)
private struct FirstStep: View {
	@EnvironmentObject var navigationModel: NavigationModel
	var body: some View {
		ZStack {
			Color.blue.ignoresSafeArea()
			VStack {
				Spacer()
				HStack {
					Spacer()
					VStack {
						Text("First Step")
							.foregroundColor(.white)
							.padding(.bottom, 40)
						Button(action: {
							print("NavStack: \(navigationModel)")
						}, label: {
							Text("Print nav stack")
								.foregroundColor(.white)
						})
					}
					Spacer()
				}
				Spacer()
			}
		}
	}
}

@available(iOS 14.0, *)
private struct ContentView: View {
	static let id = String(describing: Self.self)
	@EnvironmentObject var navigationModel: NavigationModel
	func showFirstStep() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			print("called me")
			self.navigationModel.pushContent(ContentView.id) {
				FirstStep()
			}
		}
	}

	var body: some View {
		NavigationStackView(ContentView.id) {
			ZStack {
				Color.red
				VStack {
					Spacer()
					HStack {
						Spacer()
						VStack {
							Text("test")
							Button(action: {
								print("NavStack: \(navigationModel)")
							}, label: {
								Text("Print nav stack")
							})
						}
						Spacer()
					}
					Spacer()
				}
			}.edgesIgnoringSafeArea(.all)
		}
		.onAppear {
			showFirstStep()
		}
	}
}
