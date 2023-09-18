//
//  StoreKitHelper.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 06/09/23.
//

import Foundation
import StoreKit

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
}

enum PaymentStatus{
    case disabled
    case restored
    case purchased
    case failed
    case deferred
}

protocol StoreKitRestoreHelperDelegate{
    func paymentRestored(with transaction: SKPaymentTransaction)
    func restoreEnded(with error: Error?)
}

protocol StoreKitFetchHelperDelegate{
    func productListFound(products: [String: SKProduct]?)
}

protocol StoreKitPaymentHelperDelegate{
    func paymentProcessDone(of productId: String, withStatus status: PaymentStatus)
    func paymentInProcess(of productId: String)
}

protocol StoreKitHelperDelegate : StoreKitFetchHelperDelegate, StoreKitPaymentHelperDelegate{}

class StoreKitHelper: NSObject{
    
    public static let shared = StoreKitHelper()
    
    private override init(){
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    var products: [String: SKProduct] = [:]
    
    private var fetchDelegate: StoreKitFetchHelperDelegate?
    private var paymentDelegate: StoreKitPaymentHelperDelegate?
    private var restorePaymentsDelegate: StoreKitRestoreHelperDelegate?
    
    public func fetchProducts(delegate: StoreKitHelperDelegate){
        let request = SKProductsRequest(productIdentifiers: Set(Products.array))
        request.delegate = self
        self.fetchDelegate = delegate
        self.paymentDelegate = delegate
        request.start()
    }
    
    public func buy(product: SKProduct, delegate: StoreKitPaymentHelperDelegate? = nil){
        if delegate != nil{
            self.paymentDelegate = delegate
        }
        guard SKPaymentQueue.canMakePayments() else {
            paymentDelegate?.paymentProcessDone(of: product.productIdentifier, withStatus: .disabled)
            return
        }
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(SKPayment(product: product))
    }
    
    public func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension StoreKitHelper: SKProductsRequestDelegate{
    internal func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products.removeAll()
        
        var found = false
        response.products.forEach { product in
            products[product.productIdentifier] = product
            found = true
        }

        if found{
            fetchDelegate?.productListFound(products: products)
        }else{
            fetchDelegate?.productListFound(products: nil)
        }
    }
    
    internal func request(_ request: SKRequest, didFailWithError error: Error) {
        fetchDelegate?.productListFound(products: nil)
    }
}

extension StoreKitHelper: SKPaymentTransactionObserver{
    internal func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState{
            case .purchased:
                paymentDelegate?.paymentProcessDone(of: transaction.payment.productIdentifier, withStatus: .purchased)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                paymentDelegate?.paymentProcessDone(of: transaction.payment.productIdentifier, withStatus: .failed)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                restorePaymentsDelegate?.paymentRestored(with: transaction)
                paymentDelegate?.paymentProcessDone(of: transaction.payment.productIdentifier, withStatus: .restored)
                print("RESTOREDDDDD")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .purchasing:
                paymentDelegate?.paymentInProcess(of: transaction.payment.productIdentifier)
            case .deferred:
                paymentDelegate?.paymentProcessDone(of: transaction.payment.productIdentifier, withStatus: .deferred)
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    internal func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        restorePaymentsDelegate?.restoreEnded(with: error)
        print("RESTOREDDDDD ERROR")
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        restorePaymentsDelegate?.restoreEnded(with: nil)
        print("RESTORE ENDED")
    }
    
    internal func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        if SKPaymentQueue.canMakePayments(){
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(SKPayment(product: product))
            return true
        }
        return false
    }
}
