//
//  Product+CoreDataClass.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 16/09/23.
//
//

import Foundation
import CoreData

@objc(Product)
public class Product: NSManagedObject {

    static func getMaximumCategoriesCount() -> Int{
        let productFetc = Product.fetchRequest()
        let sorter = NSSortDescriptor(key: #keyPath(Product.productId), ascending: false)
        productFetc.sortDescriptors = [sorter]
        
        do {
            let managedContext = DataModelManagerPersistentContainer.shared.context
            let results = try managedContext.fetch(productFetc)
            return Int(results.reduce(0, {$0 + $1.maxCatNum }))
        } catch _ as NSError {
            return 0
        }
    }
    
    static func saveBoughtProduct(_ product: Products) -> Bool{
        var id = ""
        var count = 0
        switch product{
        case .SingleCatTenAnsw:
            id = product.rawValue
            count = 1
        case .FiveCatTenAnsw:
            id = Products.SingleCatTenAnsw.rawValue
            count = 5
        default:
            return false
        }
        guard let product = getProduct(with: id) else { return false }
        return updateCategoryCount(for: product, with: count)
    }
    
    private static func getProduct(with productId: String) -> Product?{
        let productFetc = Product.fetchRequest()
        let sorter = NSSortDescriptor(key: #keyPath(Product.productId), ascending: false)
        productFetc.predicate = NSPredicate(format: "productId == %@", productId)
        productFetc.sortDescriptors = [sorter]
        
        do {
            let managedContext = DataModelManagerPersistentContainer.shared.context
            let results = try managedContext.fetch(productFetc)
            return results.first
        } catch _ as NSError {
            return nil
        }
    }
    
    private static func updateCategoryCount(for product: Product, with count: Int) -> Bool{
        product.maxCatNum = product.maxCatNum + Int64(count)
        return DataModelManagerPersistentContainer.shared.saveContextWithCheck()
    }
    
    public static func getAllProduct() -> [Product]? {
        let productFetch = Product.fetchRequest()
        let sortById = NSSortDescriptor(key: #keyPath(Product.productId), ascending: false)
        productFetch.sortDescriptors = [sortById]
        var products : [Product]? = nil
        do {
            let managedContext = DataModelManagerPersistentContainer.shared.context
            let results = try managedContext.fetch(productFetch)
            products = results
        } catch _ as NSError {
            return nil
        }
        return products
    }
}
