//
//  StoreKitModels.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 24/09/23.
//

import Foundation

public enum Products: String, CaseIterable{
    case YearlyProPlan = "com.vitAndreAS.RightTyped.pro.plan.yearly"
    case FiveCatTenAnsw = "com.vitAndreAS.RightTyped_5_cat_10_answe"
    case SingleCatTenAnsw = "com.vitAndreAS.RightTyped_single_cat_ten_answe"
    
    static var array : [String]{
        return Products.allCases.map({ return $0.rawValue })
    }
    
    static func fromId(id: String) -> Products?{
        return Products.allCases.filter({$0.rawValue == id}).first
    }
    
    static func isProPlan(_ id: String) -> Bool{
        return id.contains("pro.plan")
    }
}

enum PaymentStatus{
    case disabled
    case restored
    case purchased
    case failed
    case deferred
}
