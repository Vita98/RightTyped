//
//  LocalizableHelper.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 09/07/23.
//

import Foundation

struct AppString{
    private init(){}
    
    struct Language{
        private init(){}
        static let localizedLanguage: String = LocalizableString("LOCALIZED_LANGUAGE").locale
        
        enum InstalledLanguages: String{
            case IT = "IT"
            case EN = "EN"
        }
    }
    
    struct General{
        private init(){}
        static let category: String = LocalizableString("GENERAL_CATEGORY").locale
        static let categories: String = LocalizableString("GENERAL_CATEGORIES").locale
        static let edit: String = LocalizableString("GENERAL_EDIT").locale
        static let delete: String = LocalizableString("GENERAL_DELETE").locale
        static let answerSearchBarPlaceholder: String = LocalizableString("GENERAL_ANSW_SEARCH_BAR_PLACEHOLDER").locale
        static let answer: String = LocalizableString("GENERAL_ANSWER").locale
        static let next: String = LocalizableString("GENERAL_NEXT").locale
        static let done: String = LocalizableString("GENERAL_DONE").locale
    }
    
    struct Alerts{
        private init(){}
        static let yes: String = LocalizableString("Alerts_YES").locale
        static let no: String = LocalizableString("Alerts_NO").locale
        static let ok: String = LocalizableString("Alerts_OK").locale
        static let titleAreYouSure: String = LocalizableString("Alerts_TITLE_ARE_YOU_SURE").locale
        static let genericGoBackWithoutSaving: String = LocalizableString("Alerts_GO_BACK_WSAVING").locale
    }
    
    struct SettingsTypeEnum{
        private init(){}
        static let app: String = LocalizableString("SettingsTypeEnum_APP").locale
        static let keyboard: String = LocalizableString("SettingsTypeEnum_KEYBOARD").locale
        static let tutorial: String = LocalizableString("SettingsTypeEnum_TUTORIAL").locale
    }
    
    struct SettingsModel{
        private init(){}
        static let goBackToDefaultKeyboardText: String = LocalizableString("SettingsModel_GO_BACK_TO_DEFAULT_KEYBOARD").locale
        static let howToEnableKeyboardText: String = LocalizableString("SettingsModel_HOW_TO_ENABLE_KEYBOARD").locale
        static let howToUseKeyboardText: String = LocalizableString("SettingsModel_HOW_TO_USE_KEYBOARD").locale
        static let howToCustomizeKeyboardText: String = LocalizableString("SettingsModel_HOW_TO_CUSTOMIZE_KEYBOARD").locale
    }
    
    struct Biometric{
        private init(){}
        static let reason: String = LocalizableString("Biometric_REASON").locale
        
        struct Alerts{
            private init(){}
            static let biometricEnabledTitle: String = LocalizableString("Biometric_Alerts_BIOMETRIC_ENABLED_TITLE").locale
            static let biometricEnabledMessage: String = LocalizableString("Biometric_Alerts_BIOMETRIC_ENABLED_MESSAGE").locale
            static let biometricDisabledTitle: String = LocalizableString("Biometric_Alerts_BIOMETRIC_DISABLED_TITLE").locale
            static let biometricDisabledMessage: String = LocalizableString("Biometric_Alerts_BIOMETRIC_DISABLED_MESSAGE").locale
            static let authenticationFailedTitle: String = LocalizableString("Biometric_Alerts_AUTHENTICATION_FAILED_TITLE").locale
            static let authenticationFailedMessage: String = LocalizableString("Biometric_Alerts_AUTHENTICATION_FAILED_MESSAGE").locale
        }
    }
    
    struct Tutorials{
        private init(){}
        struct HOW_TO_USE_KEYBOARD{
            private init(){}
            static let title: String = LocalizableString("Tutorials_HOW_TO_USE_KEYBOARD_TITLE").locale
            static let openKeyboard: String = LocalizableString("Tutorials_HOW_TO_USE_KEYBOARD_openKeyboard").locale
            static let selectKeyboard: String = LocalizableString("Tutorials_HOW_TO_USE_KEYBOARD_selectKeyboard").locale
            static let selectAnswer: String = LocalizableString("Tutorials_HOW_TO_USE_KEYBOARD_selectAnswer").locale
            static let clickSend: String = LocalizableString("Tutorials_HOW_TO_USE_KEYBOARD_clickSend").locale
            static let mindChanged: String = LocalizableString("Tutorials_HOW_TO_USE_KEYBOARD_mindChanged").locale
            static let clickBack: String = LocalizableString("Tutorials_HOW_TO_USE_KEYBOARD_clickBack").locale
            static let personalizeKeyboard: String = LocalizableString("Tutorials_HOW_TO_USE_KEYBOARD_personalizeKeyboard").locale
            static let clickAppIcon: String = LocalizableString("Tutorials_HOW_TO_USE_KEYBOARD_clickAppIcon").locale
            static let finalTitle: String = LocalizableString("Tutorials_HOW_TO_USE_KEYBOARD_finalTitle").locale
            static let keyboardPopUp: String = LocalizableString("Tutorials_HOW_TO_USE_KEYBOARD_keyboardPopUp").locale
        }
        
        struct HOW_TO_CUSTOMIZE_KEYBOARD{
            private init(){}
            static let title: String = LocalizableString("Tutorials_HOW_TO_CUSTOMIZE_KEYBOARD_TITLE").locale
            static let dragAndDrop: String = LocalizableString("Tutorials_HOW_TO_CUSTOMIZE_KEYBOARD_dragAndDrop").locale
            static let orderInApp: String = LocalizableString("Tutorials_HOW_TO_CUSTOMIZE_KEYBOARD_orderInApp").locale
            static let answerDragAndDrop: String = LocalizableString("Tutorials_HOW_TO_CUSTOMIZE_KEYBOARD_answerDragAndDrop").locale
            static let possibleAction: String = LocalizableString("Tutorials_HOW_TO_CUSTOMIZE_KEYBOARD_possibleAction").locale
            static let finalTitle: String = LocalizableString("Tutorials_HOW_TO_CUSTOMIZE_KEYBOARD_finalTitle").locale
        }
    }
    
    //MARK: Controller - cell - xib
    struct HomeHeaderTableViewCell{
        private init(){}
        static let description: String = LocalizableString("HomeHeaderTableViewCell_DESC").locale
        static let enableCategory: String = LocalizableString("HomeHeaderTableViewCell_ENABLE_CATEGORY").locale
    }
    
    struct NewCategoryViewController{
        private init(){}
        static let newCategory: String = LocalizableString("NewCategoryViewController_NEW_CATEGORY").locale
        static let editCategory: String = LocalizableString("NewCategoryViewController_EDIT_CATEGORY").locale
        static let categoryNamePlaceholder: String = LocalizableString("NewCategoryViewController_CAT_NAME_PLACEHOLDER").locale
    }
    
    struct NewAnswerViewController{
        private init(){}
        static let answerTitlePlaceholder: String = LocalizableString("NewAnswerViewController_ANSW_TITLE_PLACEHOLDER").locale
        static let answerContentPlaceholder: String = LocalizableString("NewAnswerViewController_ANSW_CONTENT_PLACEHOLDER").locale
        static let deleteAnswerAlertDescription: String = LocalizableString("NewAnswerViewController_DEL_ANS_ALERT_DESCRIPTION").locale
    }
    
    struct ViewController{
        private init(){}
        static let deleteCategoryAlertDescription: String = LocalizableString("ViewController_DEL_CAT_ALERT_DESCRIPTION").locale
        static let emptyCategories: String = LocalizableString("ViewController_EMPTY_CATEGORIES").locale
        static let emptyAnswers: String = LocalizableString("ViewController_EMPTY_ANSWERS").locale
    }
    
    struct EnableKeyboardViewController{
        private init(){}
        static let keyboardDisabled: String = LocalizableString("EnableKeyboardViewController_KEYBOARD_DISABLED").locale
        static let keyboardEnabled: String = LocalizableString("EnableKeyboardViewController_KEYBOARD_ENABLED").locale
    }
    
    struct BiometricViewController{
        private init(){}
        static let middleMessage: String = LocalizableString("BiometricViewController_MIDDLE_MESSAGE").locale
        static let buttonText: String = LocalizableString("BiometricViewController_BUTTON_TEXT").locale
    }
}
