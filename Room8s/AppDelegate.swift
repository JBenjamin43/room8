//
//  AppDelegate.swift
//  Room8s
//
//  Created by Jeremiah on 1/16/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
// ...
      
@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.\
        FirebaseApp.configure()
        let auth = Auth.auth()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        auth.addStateDidChangeListener { auth, user in
            if user == nil {
                // User is signed in.
                //designated the view controller the user should landon based on this
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let HomeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC")
                window.rootViewController = HomeVC
            }else {
                // no user is signed in.
                //designate the view controller the user should land onbased on this
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let LoginNavController = storyboard.instantiateViewController(withIdentifier: "LoginNavController")
                window.rootViewController = LoginNavController
            }
        }
        return true
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

