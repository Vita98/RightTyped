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
    static func addTransaction(for product: SKProduct, withTitle title: String, transactionId: String) -> Bool{
        let trans = InAppTransaction(context: DataModelManagerPersistentContainer.shared.context)
        trans.productId = product.productIdentifier
        trans.purchaseDate = Date()
        trans.pricePaid = (Double(truncating: product.price)) as NSNumber
        trans.locale = product.priceLocale.currencySymbol ?? ""
        trans.purchaseDescription = title
        trans.transactionId = transactionId
        return DataModelManagerPersistentContainer.shared.saveContextWithCheck()
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
        print(trans)
        return DataModelManagerPersistentContainer.shared.saveContextWithCheck()
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
