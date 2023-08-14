//
//  UIImage.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 13/08/23.
//

import Foundation
import UIKit


extension UIImage{
    public enum Dimension{
        case width
        case height
    }
    
    public func getAspectRatio() -> Double{
        if self.size.height > self.size.width{
            return self.size.height / self.size.width
        }else{
            return self.size.width / self.size.height
        }
    }
    
    static func getAspectRatio(size: CGSize) -> Double{
        if size.height > size.width{
            return size.height / size.width
        }else{
            return size.width / size.height
        }
    }
    
    public func isDominant(_ dimension: Dimension) -> Bool{
        let exp = self.size.height >= self.size.width
        return dimension == .height ? exp : !exp
    }
    
    static func isDominant(size: CGSize, _ dimension: Dimension) -> Bool{
        let exp = size.height >= size.width
        return dimension == .height ? exp : !exp
    }
    
    static func loadFromBundle(_ name: String) -> UIImage?{
        return UIImage(named: name, in: Bundle.main, compatibleWith: nil)
    }
}

extension URL{
    var sizeOfImage: CGSize?{
        guard let imageSource = CGImageSourceCreateWithURL(self as CFURL, nil)
                , let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [AnyHashable: Any]
                , let pixelWidth = imageProperties[kCGImagePropertyPixelWidth as String] as! CFNumber?
                , let pixelHeight = imageProperties[kCGImagePropertyPixelHeight as String] as! CFNumber?
        else {return nil}
        var width: CGFloat = 0, height: CGFloat = 0
        CFNumberGetValue(pixelWidth, .cgFloatType, &width)
        CFNumberGetValue(pixelHeight, .cgFloatType, &height)
        return CGSize(width: width, height: height)
    }
}
