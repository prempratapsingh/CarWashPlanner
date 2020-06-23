//
//  SceneDelegate.swift
//  CarFit
//
//  Test Project
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
		guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        presentHomeViewController()
    }
	
	/**
	Instaniates HomeViewController with the required dependancy of CleanerListViewModel
	and makes the same as the as application window's root view controller
	
	CleanerListViewModel also has a required dependancy for a CleanerListService (Protocol) which we can pass as either of the two,
	1. CleanerListFileDataService - It loads the car wash list data from a local json file.
	2. CleanerListNetworkDataService - It communicates with NetworkDataService to get the car wash list from the backend API
	
	For now, we are passing CleanerListFileDataService as the dependancy for CleanerListViewModel
	*/
	private func presentHomeViewController() {
        guard let window = window else { return }
		
		let cleanerService = CleanerListFileDataService()
		let cleanerListModel = CleanerListViewModel(cleanerService: cleanerService)
		
		guard let homeViewController = HomeViewController.getInstance(with: cleanerListModel) else { return }
		window.rootViewController = homeViewController
		window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

