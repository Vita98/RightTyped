//
//  ReceiptValidatorHelper.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 17/09/23.
//

import Foundation
import StoreKit
import TPInAppReceipt

class ReceiptValidatorHelper{
    
    public static var shared = ReceiptValidatorHelper()
    private init(){}
    
    private var latestCheckReceiptStatus: Bool = false
    
    public var isRefreshingReceipt: Bool {
        get{
            return InAppReceipt.isReceiptRefreshingNow
        }
    }
    
    public var isReceiptValidated: Bool{
        get{
            return latestCheckReceiptStatus
        }
    }
    
    @discardableResult
    public func checkReceipt(retry: Bool = true) -> Bool{
        do {
            let receipt = try InAppReceipt.localReceipt()
            guard receipt.isValid else {
                refreshReceipt(){[weak self] in
                    self?.checkReceipt(retry: false)
                }
                return false
            }
            try receipt.verifyHash()
            try receipt.verifyBundleIdentifier()
            try receipt.verifyBundleVersion()
            try receipt.verifySignature()
            latestCheckReceiptStatus = true
            return true
        } catch let error{
            switch error{
            case IARError.validationFailed(reason: .hashValidation):
                print("Hash validation failed!")
            case IARError.validationFailed(reason: .bundleIdentifierVerification):
                print("Bundle Identifier verification failed!")
            case IARError.validationFailed(reason: .signatureValidation):
                print("Signature validation failed!")
            default:
                print("Generic error: \(error)")
            }
            refreshReceipt(){[weak self] in
                if retry { self?.checkReceipt(retry: false) }
            }
            latestCheckReceiptStatus = false
            return false
        }
    }
    
    public func refreshReceipt(retryClosure: (() -> Void)? = nil){
        InAppReceipt.refresh {(error) in
            retryClosure?()
        }
    }
    
    public func updateProPlanStatus(_ completion: ((Bool, Date?) -> Void)? = nil, retry: Bool = true){
        do {
            let receipt = try InAppReceipt.localReceipt()
            let activePurchases: [InAppPurchase] = receipt.activeAutoRenewableSubscriptionPurchases
            
            var found = false
            var expDate: Date? = nil
            for purchase in activePurchases {
                if purchase.productIdentifier == Products.YearlyProPlan.rawValue{
                    expDate = purchase.subscriptionExpirationDate
                    found = true
                    break
                }
            }
            
            if !found && UserDefaultManager.shared.getProPlanStatus(){
                //Means has been deactivated
                UserDefaultManager.shared.setBoolValue(key: UserDefaultManager.PRO_PLAN_ENABLED_KEY, enabled: false)
                UserDefaultManager.shared.setBoolValue(key: UserDefaultManager.PRO_PLAN_HAS_JUST_BEEN_DISABLED, enabled: true)
                UserDefaultManager.shared.setProPlanExpirationDate(nil)
                completion?(false, nil)
            }else if !found{
                UserDefaultManager.shared.setBoolValue(key: UserDefaultManager.PRO_PLAN_ENABLED_KEY, enabled: false)
                UserDefaultManager.shared.setBoolValue(key: UserDefaultManager.PRO_PLAN_HAS_JUST_BEEN_DISABLED, enabled: false)
                UserDefaultManager.shared.setProPlanExpirationDate(nil)
                completion?(false, nil)
            }else{
                UserDefaultManager.shared.setBoolValue(key: UserDefaultManager.PRO_PLAN_ENABLED_KEY, enabled: true)
                UserDefaultManager.shared.setBoolValue(key: UserDefaultManager.PRO_PLAN_HAS_JUST_BEEN_DISABLED, enabled: false)
                if let expDate = expDate { UserDefaultManager.shared.setProPlanExpirationDate(expDate) }
                completion?(true, expDate)
            }
        } catch _{
            if UserDefaultManager.shared.getProPlanStatus(){
                UserDefaultManager.shared.setBoolValue(key: UserDefaultManager.PRO_PLAN_ENABLED_KEY, enabled: false)
                UserDefaultManager.shared.setBoolValue(key: UserDefaultManager.PRO_PLAN_HAS_JUST_BEEN_DISABLED, enabled: true)
                UserDefaultManager.shared.setProPlanExpirationDate(nil)
            }
            refreshReceipt(){[weak self] in
                if retry { self?.updateProPlanStatus(completion, retry: false) } 
            }
        }
    }
    
    public func getAllProPlans(retry: Bool = false) -> [InAppPurchase]{
        do {
            let receipt = try InAppReceipt.localReceipt()
            return receipt.autoRenewablePurchases.sorted {$0.originalPurchaseDate < $1.originalPurchaseDate}
        } catch _{
            refreshReceipt(){}
            return []
        }
    }
    
    public func getProPlanExpirationDate() -> Date?{
        do {
            let receipt = try InAppReceipt.localReceipt()
            let activePurchases: [InAppPurchase] = receipt.activeAutoRenewableSubscriptionPurchases
            
            for purchase in activePurchases {
                if purchase.productIdentifier == Products.YearlyProPlan.rawValue{
                    return purchase.subscriptionExpirationDate
                }
            }
        } catch _{ refreshReceipt() }
        return nil
    }
}
