//
//  LocalizableModel.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 11/07/23.
//

import Foundation

struct LocalizableString{
    var value: String = ""
    var locale: String {
        get{
            return self.value.withLocal()
        }
    }
    
    init(_ value: String){
        self.value = value
    }
}

extension String{
    public func withLocal() -> String{
        return NSLocalizedString(self, comment: "")
    }
}
