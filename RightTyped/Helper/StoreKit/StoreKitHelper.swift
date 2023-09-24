//
//  StoreKitHelper.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 06/09/23.
//

import Foundation
import StoreKit


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
        self.fetchProducts()
    }
    
    var products: [String: SKProduct] = [:]
    
    private var fetchDelegate: StoreKitFetchHelperDelegate?
    private var paymentDelegate: StoreKitPaymentHelperDelegate?
    private var restorePaymentsDelegate: StoreKitRestoreHelperDelegate?
    
    public func fetchProducts(delegate: StoreKitHelperDelegate? = nil){
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
        SKPaymentQueue.default().add(SKPayment(product: product))
    }
    
    public func restorePurchase(delegate: StoreKitRestoreHelperDelegate? = nil){
        if let delegate = delegate{
            restorePaymentsDelegate = delegate
        }
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
            Premium.inflateWith(products: Array(products.values))
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
                if let prod = products[transaction.payment.productIdentifier]{
                    InAppTransaction.addTransaction(for: prod, withTitle: Premium.getProductTitle(for: prod.productIdentifier), transactionId: transaction.transactionIdentifier ?? "")
                }
                paymentDelegate?.paymentProcessDone(of: transaction.payment.productIdentifier, withStatus: .purchased)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                paymentDelegate?.paymentProcessDone(of: transaction.payment.productIdentifier, withStatus: .failed)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                if let prod = products[transaction.payment.productIdentifier]{
                    InAppTransaction.addRestoredTransaction(for: transaction, for: prod, withTitle: Premium.getProductTitle(for: prod.productIdentifier))
                }
                restorePaymentsDelegate?.paymentRestored(with: transaction)
                paymentDelegate?.paymentProcessDone(of: transaction.payment.productIdentifier, withStatus: .restored)
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
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        restorePaymentsDelegate?.restoreEnded(with: nil)
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
