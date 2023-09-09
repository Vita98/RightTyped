//
//  StoreKitHelper.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 06/09/23.
//

import Foundation
import StoreKit

//fileprivate let PRODUCT_IDS = ["com.vitAndreAS.RightTyped_5_cat_10_answ","com.vitAndreAS.RightTyped_single_cat_ten_answ","com.vitAndreAS.RightTyped.pro.plan.yearly"]

enum Products: String, CaseIterable{
    case YearlyProPlan = "com.vitAndreAS.RightTyped.pro.plan.yearly"
    case FiveCatTenAnsw = "com.vitAndreAS.RightTyped_5_cat_10_answ"
    case SingleCatTenAnsw = "com.vitAndreAS.RightTyped_single_cat_ten_answ"
    
    static var array : [String]{
        return Products.allCases.map({ return $0.rawValue })
    }
}

protocol StoreKitHelperDelegate{
    func productListFound(products: [String: SKProduct]?)
}

class StoreKitHelper: NSObject{
    private override init(){}
    public static let shared = StoreKitHelper()
    
    var products: [String: SKProduct] = [:]
    
    private var delegate: StoreKitHelperDelegate?
    
    public func fetchProducts(delegate: StoreKitHelperDelegate){
        let request = SKProductsRequest(productIdentifiers: Set(Products.array))
        request.delegate = self
        self.delegate = delegate
        request.start()
    }
}

extension StoreKitHelper: SKProductsRequestDelegate{
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products.removeAll()
        
        var found = false
        response.products.forEach { product in
            products[product.productIdentifier] = product
            found = true
        }

        if found{
            delegate?.productListFound(products: products)
        }else{
            delegate?.productListFound(products: nil)
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        delegate?.productListFound(products: nil)
    }
}
