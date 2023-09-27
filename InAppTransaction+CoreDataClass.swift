//
//  InAppTransaction+CoreDataClass.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 24/09/23.
//
//

import Foundation
import CoreData
import StoreKit

@objc(InAppTransaction)
public class InAppTransaction: NSManagedObject {

    @discardableResult
    static func addTransaction(_ transaction: SKPaymentTransaction, for product: SKProduct, withTitle title: String) -> Bool{
        guard let tranId = transaction.transactionIdentifier , let tranDate = transaction.transactionDate else { return false }
        let trans = InAppTransaction(context: DataModelManagerPersistentContainer.shared.context)
        trans.productId = product.productIdentifier
        trans.purchaseDate = tranDate
        trans.pricePaid = (Double(truncating: product.price)) as NSNumber
        trans.locale = product.priceLocale.currencySymbol ?? ""
        trans.purchaseDescription = title
        trans.transactionId = tranId
        return DataModelManagerPersistentContainer.shared.saveContextWithRollback()
    }
    
    @discardableResult
    static func addTransactionFromOrigin(_ transaction: SKPaymentTransaction) -> Bool{
        guard let originalTransaction = transaction.original, let orTranId = originalTransaction.transactionIdentifier, let currTranId = transaction.transactionIdentifier, let transDate = transaction.transactionDate else { return false }
        guard let inAppOriginalTrans = getTransaction(forId: orTranId ) else { return false }
        let trans = InAppTransaction(context: DataModelManagerPersistentContainer.shared.context)
        trans.productId = transaction.payment.productIdentifier
        trans.purchaseDate = transDate
        trans.pricePaid = inAppOriginalTrans.pricePaid
        trans.locale = inAppOriginalTrans.locale
        trans.purchaseDescription = inAppOriginalTrans.purchaseDescription
        trans.transactionId = currTranId
        return DataModelManagerPersistentContainer.shared.saveContextWithRollback()
    }
    
    @discardableResult
    static func addRestoredTransaction(for transaction: SKPaymentTransaction, for product: SKProduct, withTitle title: String) -> Bool{
        let trans = InAppTransaction(context: DataModelManagerPersistentContainer.shared.context)
        trans.productId = transaction.payment.productIdentifier
        trans.purchaseDate = transaction.transactionDate ?? Date()
        trans.transactionId = transaction.original?.transactionIdentifier ?? ""
        trans.pricePaid = product.price
        trans.locale = product.priceLocale.currencySymbol ?? ""
        trans.purchaseDescription = title
        return DataModelManagerPersistentContainer.shared.saveContextWithRollback()
    }
    
    static func getTransaction(forId transactionId: String) -> InAppTransaction?{
        let transFetc = InAppTransaction.fetchRequest()
        let sorter = NSSortDescriptor(key: #keyPath(Product.productId), ascending: false)
        transFetc.sortDescriptors = [sorter]
        transFetc.predicate = NSPredicate(format: "transactionId == %@", transactionId)
        
        do {
            let managedContext = DataModelManagerPersistentContainer.shared.context
            return try managedContext.fetch(transFetc).first
        } catch _ as NSError {
            return nil
        }
    }
    
    static func getAllTransactions() -> [InAppTransaction]{
        let transFetc = InAppTransaction.fetchRequest()
        let sorter = NSSortDescriptor(key: #keyPath(Product.productId), ascending: false)
        transFetc.sortDescriptors = [sorter]
        
        do {
            let managedContext = DataModelManagerPersistentContainer.shared.context
            return try managedContext.fetch(transFetc)
        } catch _ as NSError {
            return []
        }
    }
    
}
