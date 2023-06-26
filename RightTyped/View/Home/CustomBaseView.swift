//
//  CustomBaseView.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 26/06/23.
//

import UIKit

class CustomBaseView: UIView {
    
    public var touchInViewClosure: ((CGPoint) -> Void)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        touchInViewClosure?(point)
        return super.point(inside: point, with: event)
    }

}
