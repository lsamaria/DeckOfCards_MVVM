//
//  AppDelegate.swift
//  MVVM
//
//  Created by LanceMacBookPro on 11/3/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let homeViewModel = HomeViewModel()
        let homeVC = HomeController(with: homeViewModel)
        let navVC = UINavigationController(rootViewController: homeVC)
        
        window?.rootViewController = navVC
        
        return true
    }
}

