//
//  SceneDelegate.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 24/05/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        if UserDefaultManager.shared.isFirstBoot(){
            DefaultData.shared.saveDefaultData()
        }

        if UserDefaultManager.shared.getProPlanStatus() && ReceiptValidatorHelper.shared.checkReceipt(){
            ReceiptValidatorHelper.shared.updateProPlanStatus()
        }

        let window = UIWindow(windowScene: windowScene)
        let initialViewController: UIViewController?
        
        if let biometricLogEnabled = UserDefaultManager.shared.getBoolValue(key: UserDefaultManager.BIOMETRIC_ENABLED_KEY), biometricLogEnabled, let viewC: BiometricViewController = UIStoryboard.main().instantiate() {
            initialViewController = viewC
        }else{
            initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewControllerID") as! ViewController
            if !UserDefaultManager.shared.isKeyboardExtensionEnabled(), let boolVal = UserDefaultManager.shared.getBoolValue(key: UserDefaultManager.DONT_SHOW_ENABLE_KEYBOARD_AGAIN_KEY), !boolVal, let initialViewController = initialViewController as? ViewController{
                initialViewController.showTutorial = true
            }
        }
        
        let navController = UINavigationController(rootViewController: initialViewController!)
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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
    }

    static func goToHome(animated : Bool = false){
        if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate{
            scene.goToHome(animated: animated)
        }
    }
    
    func goToHome(animated: Bool = false){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "viewControllerID") as! ViewController
        
        if !UserDefaultManager.shared.isKeyboardExtensionEnabled(), let boolVal = UserDefaultManager.shared.getBoolValue(key: UserDefaultManager.DONT_SHOW_ENABLE_KEYBOARD_AGAIN_KEY), !boolVal{
            initialViewController.showTutorial = true
        }
        
        let navController = UINavigationController(rootViewController: initialViewController)
        navController.navigationBar.isHidden = true

        self.window?.rootViewController = navController
        if animated, let window = self.window{
            UIView.transition(with: window, duration: 0.3,options: UIView.AnimationOptions.transitionCrossDissolve, animations: {})
        }
    }

}

