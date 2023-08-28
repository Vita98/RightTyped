//
//  PremiumModel.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 27/08/23.
//

import Foundation

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
    case aggregated
    
    var value: String {
        switch self {
        case .included:
            return AppString.Premium.SubscriptionType.included
        case .yearly:
            return AppString.Premium.SubscriptionType.yearly
        case .montly:
            return AppString.Premium.SubscriptionType.montly
        case .aggregated:
            return AppString.Premium.SubscriptionType.aggregated
        }
    }
}

//MARK: Premium stack content models
enum PremiumStackContentType{
    case plainItem
    case selectableItem
}

struct PremiumStackContent{
    let included: Bool
    let title: String
    let type: PremiumStackContentType
}

//MARK: Premium model
struct PremiumModel{
    let type: PremiumType
    let description: String
    let price: Double? = nil
    let subscriptionType: SubscriptionType
    let buttonTitle: String
    let stackContent: [PremiumStackContent]
    
    /// Initializer for a base model
    init(description: String, buttonTitle: String, stackContent: [PremiumStackContent]){
        self.type = .base
        self.description = description
        self.subscriptionType = .included
        self.buttonTitle = buttonTitle
        self.stackContent = stackContent
    }
}



//MARK: - List of all the Premium Model
struct PremiumList{
    private init(){}
    
    static let firstBase: PremiumModel = PremiumModel(description: AppString.Premium.FirstBasePlan.description, buttonTitle: AppString.Premium.FirstBasePlan.buttonTitle, stackContent: [])
}
