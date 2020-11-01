import NavigationStack
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	let argumentViewMapping = [
		"Experiment0": AnyView(Experiment0()),
		"Experiment1": AnyView(Experiment1()),
		"Experiment2": AnyView(Experiment2()),
		"Experiment3": AnyView(Experiment3()),
		"Experiment4": AnyView(Experiment4()),
		"Experiment5": AnyView(Experiment5()),
		"Experiment6": AnyView(Experiment6()),
		"Experiment7": AnyView(Experiment7()),
		"Experiment8": AnyView(Experiment8()),
		"Experiment9": AnyView(Experiment9())
	]

	func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
		var contentView: AnyView?
		if CommandLine.arguments.count >= 2 {
			contentView = argumentViewMapping[CommandLine.arguments[1]]
		}
		if contentView == nil {
			contentView = AnyView(
				ContentView1()
					.environmentObject(NavigationModel(silenceErrors: true))
			)
		}

		if let windowScene = scene as? UIWindowScene {
			let window = UIWindow(windowScene: windowScene)
			window.rootViewController = UIHostingController(rootView: contentView)
			self.window = window
			window.makeKeyAndVisible()
		}
	}

	func sceneDidDisconnect(_: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
	}

	func sceneDidBecomeActive(_: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
	}

	func sceneWillResignActive(_: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
	}

	func sceneWillEnterForeground(_: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
	}

	func sceneDidEnterBackground(_: UIScene) {
		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
		// to restore the scene back to its current state.
	}
}
