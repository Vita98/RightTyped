//
//  BiometricHelper.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 16/08/23.
//

import Foundation
import LocalAuthentication

struct BiometricHelper{
    private init(){}
    
    static func biometricType() -> String?{
        let bT: BiometricType = biometricType()
        switch bT{
        case .face:
            return "Face ID"
        case .touch:
            return "Touch ID"
        default:
            return nil
        }
    }
    
    static func biometricType() -> BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                return .none
            case .touchID:
                return .touch
            case .faceID:
                return .face
            case .opticID:
                return .unknown
            @unknown default:
                return .unknown
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
        }
    }
    
    static func isBiometricPossible() -> Bool{
        let bT: BiometricType = biometricType()
        return bT == .face || bT == .touch
    }
    
    static func askForBiometric(completition: @escaping (Bool, LAError?) -> Void){
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: AppString.Biometric.reason) {
                success, authenticationError in

                DispatchQueue.main.async {
                    completition(success, authenticationError as? LAError)
                }
            }
        } else {
            completition(false, error as? LAError)
        }
    }

    enum BiometricType {
        case none
        case touch
        case face
        case unknown
    }
}
