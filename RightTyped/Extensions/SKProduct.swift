//
//  SKProduct.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 09/09/23.
//

import Foundation
import StoreKit

extension SKProduct{
    func convertSubscriptionPeriod() -> SubscriptionType{
        guard let period = self.subscriptionPeriod else { return .notASubscription }
        switch period.unit{
        case SKProduct.PeriodUnit.month:
            return .montly
        case SKProduct.PeriodUnit.year:
            return .yearly
        case SKProduct.PeriodUnit.week:
            return .weekly
        case SKProduct.PeriodUnit.day:
            return .daily
        default:
            return .notASubscription
        }
    }
}
