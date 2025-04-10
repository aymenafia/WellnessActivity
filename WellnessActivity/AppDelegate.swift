//
//  AppDelegate.swift
//  WellnessActivity
//
//  Created by aymen on 10.04.25.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize Realm.
        do {
            _ = try Realm()
        } catch {
            print("Error initializing Realm: \(error)")
        }
        
        // Configure repositories.
        let localRepository = RealmActivityRepository()
        let remoteRepository = MoyaActivityRepository()
        let activityRepository = SyncActivityRepository(local: localRepository, remote: remoteRepository)
        
        // Setup view model and main view controller.
        let activityListViewModel = ActivityListViewModel(activityRepository: localRepository)
        let activityListVC = ActivityListViewController(viewModel: activityListViewModel)
        let navController = UINavigationController(rootViewController: activityListVC)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
}
