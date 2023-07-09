//
//  LocalizableHelper.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 09/07/23.
//

import Foundation

extension String{
    public func withLocal() -> String{
        return NSLocalizedString(self, comment: "")
    }
}
