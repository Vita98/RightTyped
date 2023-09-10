//
//  UINavigationController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 01/07/23.
//

import Foundation
import UIKit

class RootNavController<T: UIViewController>{
    let navController: UINavigationController
    let root: T
    
    internal init(navController: UINavigationController, root: T) {
        self.navController = navController
        self.root = root
    }
}

extension UINavigationController {
    func pushViewController(viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }

    func popViewController(animated: Bool, completion: @escaping () -> Void) {
        popViewController(animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
    
    static func instantiateNavController<T : UIViewController>(withRoot viewController: T.Type) -> RootNavController<T>?{
        guard let viewC : T = UIStoryboard.main().instantiate() else { return nil }
        let navContr = UINavigationController(rootViewController: viewC)
        navContr.navigationBar.isHidden = true
        navContr.modalPresentationStyle = .fullScreen
        return RootNavController(navController: navContr, root: viewC)
    }
    
    static func instantiateNavController<T : UIViewController>(withRoot viewController: T.Type, from storyboard: UIStoryboard) -> RootNavController<T>?{
        guard let viewC : T = storyboard.instantiate() else { return nil }
        let navContr = UINavigationController(rootViewController: viewC)
        navContr.navigationBar.isHidden = true
        navContr.modalPresentationStyle = .fullScreen
        return RootNavController(navController: navContr, root: viewC)
    }
}
