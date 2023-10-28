//
//  PremiumModel.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 27/08/23.
//

import Foundation
import UIKit
import StoreKit


enum PremiumType{
    case base
    case pro
    case payPerUse
    
    var value: String {
        switch self {
        case .base:
            return AppString.Premium.Plans.baseText
        case .pro:
            return AppString.Premium.Plans.proText
        case .payPerUse:
            return AppString.Premium.Plans.ppuText
        }
    }
}

enum SubscriptionType{
    case included
    case yearly
    case montly
    case weekly
    case daily
    case notASubscription
    case aggregated
    
    var value: String {
        switch self {
        case .included:
            return AppString.Premium.SubscriptionType.included
        case .yearly:
            return AppString.Premium.SubscriptionType.yearly
        case .montly:
            return AppString.Premium.SubscriptionType.montly
        case .weekly:
            return AppString.Premium.SubscriptionType.weekly
        case .daily:
            return AppString.Premium.SubscriptionType.daily
        case .aggregated:
            return AppString.Premium.SubscriptionType.aggregated
        case .notASubscription:
            return ""
        }
    }
}

//MARK: Premium stack content models
enum PremiumStackContentType{
    case plainItem
    case selectableItem
}

struct PremiumStackContent{
    var associatedID: String?
    var product: SKProduct?
    let included: Bool
    let title: String
    let type: PremiumStackContentType
    var price: Double?
    var currencySymbol: String?
    
    internal init(associatedID: String? = nil, included: Bool, title: String, type: PremiumStackContentType, price: Double? = nil) {
        self.included = included
        self.title = title
        self.type = type
        self.price = price
        self.currencySymbol = nil
        self.associatedID = associatedID
        self.product = nil
    }
}

//MARK: Premium page model
struct PremiumPageModel{
    let associatedIDs: [String]?
    var products: [SKProduct]?
    let type: PremiumType
    let description: String
    let note: String?
    var price: Double?
    var currencySymbol: String?
    var subscriptionType: SubscriptionType?
    let buttonTitle: String
    var stackContent: [PremiumStackContent]
    
    /// Initializer for a base model
    init(description: String, buttonTitle: String, stackContent: [PremiumStackContent]){
        self.type = .base
        self.description = description
        self.subscriptionType = .included
        self.buttonTitle = buttonTitle
        self.stackContent = stackContent
        self.price = nil
        self.associatedIDs = nil
        self.currencySymbol = nil
        self.note = nil
    }
    
    /// Initializer for a pro model
    init(associatedID: String, description: String, note: String, buttonTitle: String, stackContent: [PremiumStackContent]) {
        self.description = description
        self.buttonTitle = buttonTitle
        self.price = nil
        self.stackContent = stackContent
        self.type = .pro
        self.associatedIDs = [associatedID]
        self.subscriptionType = nil
        self.currencySymbol = nil
        self.note = note
    }
    
    /// Initializer for a Pay per Use model
    init(associatedIDs: [String]? = nil, description: String, note: String, buttonTitle: String, stackContent: [PremiumStackContent]) {
        self.description = description
        self.buttonTitle = buttonTitle
        self.price = nil
        self.subscriptionType = .aggregated
        self.stackContent = stackContent
        self.type = .payPerUse
        self.associatedIDs = associatedIDs
        self.currencySymbol = nil
        self.note = note
    }
}



//MARK: - List of all the Premium Model
struct PremiumModel: ControllerAssociable{
    var pageModels: [PremiumPageModel]
    
    func getControllers(fromSettings: Bool, finalAction: (() -> Void)?, isFinal: Bool) -> [UIViewController] {
        var controllers: [UIViewController] = []
        
        for pageModel in pageModels.filter({ $0.type == .base || $0.products?.count ?? 0 > 0 || ($0.stackContent.filter({$0.product != nil}).count > 0) }) {
            switch pageModel.type{
            case .base, .pro:
                if let c: PlainPremiumViewController = UIStoryboard.premium().instantiate(){
                    c.model = pageModel
                    controllers.append(c)
                }
            case .payPerUse:
                if let c: SelectablePremiumViewController = UIStoryboard.premium().instantiate(){
                    c.model = pageModel
                    controllers.append(c)
                }
                break
            }
            
        }
        return controllers
    }
}

struct Premium{
    private init(){}
    
    static var PREMIUMS: PremiumModel = PremiumModel(pageModels: [
        PremiumPageModel( description: AppString.Premium.FirstBasePlan.description, buttonTitle: AppString.Premium.FirstBasePlan.buttonTitle, stackContent: [
            PremiumStackContent(included: true, title: String(format: AppString.Premium.FirstBasePlan.firstStackText, MAXIMUM_CATEGORIES_AVAILABLE), type: .plainItem),
            PremiumStackContent(included: true, title: String(format: AppString.Premium.FirstBasePlan.secondStackText, MAXIMUM_ANSWERS_FOR_CATEGORIES), type: .plainItem),
            PremiumStackContent(included: false, title: AppString.Premium.FirstBasePlan.thirdStackText, type: .plainItem),]),
        PremiumPageModel(associatedID: Products.YearlyProPlan.rawValue, description: AppString.Premium.FirstProPlan.description, note: AppString.Premium.FirstProPlan.note, buttonTitle: AppString.Premium.FirstProPlan.buttonTitle, stackContent: [
            PremiumStackContent(included: true, title: AppString.Premium.FirstProPlan.firstStackText, type: .plainItem),
            PremiumStackContent(included: true, title: AppString.Premium.FirstProPlan.secondStackText, type: .plainItem),
            PremiumStackContent(included: true, title: AppString.Premium.FirstProPlan.thirdStackText, type: .plainItem),]),
        PremiumPageModel(associatedIDs: nil, description: AppString.Premium.FirstPpuPlan.description, note: AppString.Premium.FirstPpuPlan.note, buttonTitle: AppString.Premium.FirstPpuPlan.buttonTitle, stackContent: [
            PremiumStackContent(associatedID: Products.SingleCatTenAnsw.rawValue, included: false, title: String(format: AppString.Premium.FirstPpuPlan.firstStackText, ANS_NUM_PPU_FIRST) , type: .selectableItem),
            PremiumStackContent(associatedID: Products.FiveCatTenAnsw.rawValue, included: false, title: String(format: AppString.Premium.FirstPpuPlan.secondStackText, CAT_NUM_PPU_SECOND, ANS_NUM_PPU_SECOND), type: .selectableItem),
        ]),])
    
    static func getProductTitle(for productId: String) -> String{
        if let title = PREMIUMS.pageModels.filter({$0.associatedIDs?.contains(productId) ?? false}).first?.type.value { return title }
        return PREMIUMS.pageModels.filter({$0.type == .payPerUse}).first?.stackContent.filter({$0.associatedID == productId}).first?.title ?? ""
    }
    
    static func inflateWith(products : [SKProduct]){
        for product in products {
            
            //iterating among the page model
            for i in 0..<PREMIUMS.pageModels.count{
                switch PREMIUMS.pageModels[i].type{
                case  .pro:
                    if PREMIUMS.pageModels[i].associatedIDs!.contains(product.productIdentifier){
                        if PREMIUMS.pageModels[i].products != nil{
                            PREMIUMS.pageModels[i].products?.append(product)
                        }else{
                            PREMIUMS.pageModels[i].products = [product]
                        }
                        PREMIUMS.pageModels[i].price = product.price.doubleValue
                        PREMIUMS.pageModels[i].currencySymbol = product.priceLocale.currencySymbol
                        PREMIUMS.pageModels[i].subscriptionType = product.convertSubscriptionPeriod()
                    }
                case .payPerUse:
                    for k in 0..<PREMIUMS.pageModels[i].stackContent.count{
                        if PREMIUMS.pageModels[i].stackContent[k].associatedID == product.productIdentifier {
                            PREMIUMS.pageModels[i].stackContent[k].product = product
                            PREMIUMS.pageModels[i].stackContent[k].price = product.price.doubleValue
                            PREMIUMS.pageModels[i].stackContent[k].currencySymbol = product.priceLocale.currencySymbol
                        }
                    }
                default:
                    break
                }
            }
        }
        
    }
}
