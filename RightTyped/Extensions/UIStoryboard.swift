//
//  UIStoryboard.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 12/08/23.
//

import Foundation
import UIKit

extension UIStoryboard{
    static func main() -> UIStoryboard{
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func instantiate<T: UIViewController>(_ viewController: T.Type) -> T?{
        return self.instantiateViewController(withIdentifier: String(describing: viewController)) as? T
    }
    
    func instantiate<T: UIViewController>(_ viewController: T.Type) -> T{
        return self.instantiateViewController(withIdentifier: String(describing: viewController)) as! T
    }
}
