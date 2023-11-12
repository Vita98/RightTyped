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
        static let close: String = LocalizableString("GENERAL_CLOSE").locale
        static let save: String = LocalizableString("GENERAL_SAVE").locale
        static let enable: String = LocalizableString("GENERAL_ENABLE").locale
        static let doNotShowThisMessage: String = LocalizableString("GENERAL_NOT_SHOW_THIS_MESSAGE").locale
        static let skip: String = LocalizableString("GENERAL_SKIP").locale
    }
    
    struct Alerts{
        private init(){}
        static let yes: String = LocalizableString("Alerts_YES").locale
        static let no: String = LocalizableString("Alerts_NO").locale
        static let ok: String = LocalizableString("Alerts_OK").locale
        static let titleAreYouSure: String = LocalizableString("Alerts_TITLE_ARE_YOU_SURE").locale
        static let genericGoBackWithoutSaving: String = LocalizableString("Alerts_GO_BACK_WSAVING").locale
        static let noMoreCategoriesAvailable: String = LocalizableString("Alerts_NO_MORE_CATEGORIES_AVAILABLE").locale
        static let noMoreCategoriesAvailableDescription: String = LocalizableString("Alerts_NO_MORE_CATEGORIES_AVAILABLE_DESCR").locale
        static let noMoreAnswersAvailable: String = LocalizableString("Alerts_NO_MORE_ANSWERS_AVAILABLE").locale
        static let noMoreAnswersAvailableDescription: String = LocalizableString("Alerts_NO_MORE_ANSWERS_AVAILABLE_DESCR").locale
        static let goToPremiumSection: String = LocalizableString("Alerts_GO_TO_PREMIUM").locale
    }
    
    struct SettingsTypeEnum{
        private init(){}
        static let app: String = LocalizableString("SettingsTypeEnum_APP").locale
        static let keyboard: String = LocalizableString("SettingsTypeEnum_KEYBOARD").locale
        static let tutorial: String = LocalizableString("SettingsTypeEnum_TUTORIAL").locale
        static let support: String = LocalizableString("SettingsTypeEnum_SUPPORT").locale
        static let termsConditions: String = LocalizableString("SettingsTypeEnum_TERMS_CONDITION").locale
    }
    
    struct SettingsModel{
        private init(){}
        static let goBackToDefaultKeyboardText: String = LocalizableString("SettingsModel_GO_BACK_TO_DEFAULT_KEYBOARD").locale
        static let howToEnableKeyboardText: String = LocalizableString("SettingsModel_HOW_TO_ENABLE_KEYBOARD").locale
        static let howToUseKeyboardText: String = LocalizableString("SettingsModel_HOW_TO_USE_KEYBOARD").locale
        static let howToCustomizeKeyboardText: String = LocalizableString("SettingsModel_HOW_TO_CUSTOMIZE_KEYBOARD").locale
        static let premiumText: String = LocalizableString("SettingsModel_PREMIUM").locale
        static let myPurchasesText: String = LocalizableString("SettingsModel_MY_PURCHASES").locale
        static let contactSupportText: String = LocalizableString("SettingsModel_CONTACT_SUPPORT_TEXT").locale
        static let termsOfUse: String = LocalizableString("SettingsModel_TERMS_OF_USE_TEXT").locale
        static let privacyPolicy: String = LocalizableString("SettingsModel_PRIVACY_POLICY_TEXT").locale
    }
    
    
    struct SettingsLinks{
        private init(){}
        static let termsOfUse: String = LocalizableString("SettingsLinks_TERMS_OF_USE_LINK").locale
        static let privacyPolicy: String = LocalizableString("SettingsLinks_PRIVACY_POLICY_LINK").locale
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
    
    struct Support{
        private init(){}
        
        struct Alerts{
            private init(){}
            
            struct serviceNotAvailable{
                private init(){}
                static let title: String = LocalizableString("Support_Alerts_SERVICE_NOT_AVAILABLE_TITLE").locale
                static let descr: String = LocalizableString("Support_Alerts_SERVICE_NOT_AVAILABLE_DESCR").locale
            }
            struct emailSent{
                private init(){}
                static let title: String = LocalizableString("Support_Alerts_EMAIL_SENT_TITLE").locale
                static let descr: String = LocalizableString("Support_Alerts_EMAIL_SENT_DESCR").locale
            }
            struct emailError{
                private init(){}
                static let title: String = LocalizableString("Support_Alerts_EMAIL_ERROR_TITLE").locale
                static let descr: String = LocalizableString("Support_Alerts_EMAIL_ERROR_DESCR").locale
            }
        }
        
        static let mailSubject: String = LocalizableString("Support_MAIL_SUBJECT").locale
        static let mailBody: String = LocalizableString("Support_MAIL_BODY").locale
    }
    
    struct Premium{
        private init(){}
        
        struct Popup{
            private init(){}
            struct SuccessPpu{
                private init(){}
                static let title: String = LocalizableString("Premium_Popup_SuccessPpu_TITLE").locale
                static let description: String = LocalizableString("Premium_Popup_SuccessPpu_DESCRIPTION").locale
            }
            struct SuccessPro{
                private init(){}
                static let title: String = LocalizableString("Premium_Popup_SuccessPro_TITLE").locale
                static let description: String = LocalizableString("Premium_Popup_SuccessPro_DESCRIPTION").locale
            }
            struct Failure{
                private init(){}
                static let title: String = LocalizableString("Premium_Popup_Failure_TITLE").locale
                static let description: String = LocalizableString("Premium_Popup_Failure_DESCRIPTION").locale
            }
            struct SuccessProRestoration{
                private init(){}
                static let title: String = LocalizableString("Premium_Popup_SuccessProRestoration_TITLE").locale
                static let description: String = LocalizableString("Premium_Popup_SuccessProRestoration_DESCRIPTION").locale
            }
            struct NothingToRestore{
                private init(){}
                static let title: String = LocalizableString("Premium_Popup_NothingToRestore_TITLE").locale
                static let description: String = LocalizableString("Premium_Popup_NothingToRestore_DESCRIPTION").locale
            }
            struct ProNotRenewed{
                private init(){}
                static let title: String = LocalizableString("Alerts_ProNotRenewed_TITLE").locale
                static let description: String = LocalizableString("Alerts_ProNotRenewed_DESCRIPTION").locale
                static let selectCategoriesButton: String = LocalizableString("Alerts_ProNotRenewed_SELECT_CATEGORIES_TITLE").locale
            }
            struct ProNotRenewedNoCatSelection{
                private init(){}
                static let title: String = LocalizableString("Alerts_ProNotRenewedNoCatSelection_TITLE").locale
                static let description: String = LocalizableString("Alerts_ProNotRenewedNoCatSelection_DESCRIPTION").locale
                static let notInterested: String = LocalizableString("Alerts_ProNotRenewedNoCatSelection_NOT_INTERESTED").locale
            }
            struct ErrorRestoringPurchase{
                private init(){}
                static let title: String = LocalizableString("Alerts_ErrorRestoringPurchase_TITLE").locale
                static let description: String = LocalizableString("Alerts_ErrorRestoringPurchase_DESCRIPTION").locale
            }
            struct AreSureAboutSelection{
                private init(){}
                static let description: String = LocalizableString("Alerts_AreSureAboutSelection_DESCRIPTION").locale
            }
            struct CategoryDisabled{
                private init(){}
                static let title: String = LocalizableString("Premium_Popup_CategoryDisabled_TITLE").locale
                static let description: String = LocalizableString("Premium_Popup_CategoryDisabled_DESCRIPTION").locale
            }
            struct AnswerDisabled{
                private init(){}
                static let title: String = LocalizableString("Premium_Popup_AnswerDisabled_TITLE").locale
                static let description: String = LocalizableString("Premium_Popup_AnswerDisabled_DESCRIPTION").locale
            }
        }
        
        struct MyPurchases{
            private init(){}
            static let restorePurchasesButtonTitle: String = LocalizableString("Premium_MyPurchases_RESTORE_PURCHASES_BUTTON_TITLE").locale
            static let noPurchasesFound: String = LocalizableString("Premium_MyPurchases_NO_PURCHASES_FOUND").locale
            static let purchaseDate: String = LocalizableString("Premium_MyPurchases_PURCHASE_DATE").locale
            static let expirationDate: String = LocalizableString("Premium_MyPurchases_EXPIRATION_DATE").locale
        }
        
        struct PremiumPage{
            private init(){}
            static let noPremiumOptions: String = LocalizableString("Premium_Plans_NO_PREMIUM_OPTIONS").locale
            static let refreshButtonTitle: String = LocalizableString("Premium_Plans_REFRESH_BUTTON_TITLE").locale
        }
        
        struct SelectCategories{
            private init(){}
            static let mainTitle: String = LocalizableString("Premium_SelectCategories_MAIN_TITLE").locale
            static let mainDescription: String = LocalizableString("Premium_SelectCategories_MAIN_DESCRIPTION").locale
            static let selectionText: String = LocalizableString("Premium_SelectCategories_SELECTION_TEXT").locale
            static let infoPopupDescription: String = LocalizableString("Premium_SelectCategories_INFO_POPUP_DESCRIPTION").locale
        }
        
        struct Plans{
            private init(){}
            static let baseText: String = LocalizableString("Premium_Plans_BASE_TEXT").locale
            static let proText: String = LocalizableString("Premium_Plans_PRO_TEXT").locale
            static let ppuText: String = LocalizableString("Premium_Plans_PAYPERUSE_TEXT").locale
        }
        
        struct SubscriptionType{
            private init(){}
            static let included: String = LocalizableString("Premium_SubscriptionType_INCLUDED").locale
            static let yearly: String = LocalizableString("Premium_SubscriptionType_YEARLY").locale
            static let montly: String = LocalizableString("Premium_SubscriptionType_MONTLY").locale
            static let weekly: String = LocalizableString("Premium_SubscriptionType_WEEKLY").locale
            static let daily: String = LocalizableString("Premium_SubscriptionType_DAILY").locale
            static let aggregated: String = LocalizableString("Premium_SubscriptionType_AGGREGATED").locale
        }
        
        struct FirstBasePlan{
            private init(){}
            static let description: String = LocalizableString("Premium_Plans_FirstBasePlan_DESCRIPTION").locale
            static let buttonTitle: String = LocalizableString("Premium_Plans_FirstBasePlan_BUTTON_TITLE").locale
            static let firstStackText: String = LocalizableString("Premium_Plans_FirstBasePlan_FIRST_STACK_TEXT").locale
            static let secondStackText: String = LocalizableString("Premium_Plans_FirstBasePlan_SECOND_STACK_TEXT").locale
            static let thirdStackText: String = LocalizableString("Premium_Plans_FirstBasePlan_THIRD_STACK_TEXT").locale
        }
        
        struct FirstProPlan{
            private init(){}
            static let description: String = LocalizableString("Premium_Plans_FirstProPlan_DESCRIPTION").locale
            static let note: String = LocalizableString("Premium_Plans_FirstProPlan_NOTE").locale
            static let buttonTitle: String = LocalizableString("Premium_Plans_FirstProPlan_BUTTON_TITLE").locale
            static let firstStackText: String = LocalizableString("Premium_Plans_FirstProPlan_FIRST_STACK_TEXT").locale
            static let secondStackText: String = LocalizableString("Premium_Plans_FirstProPlan_SECOND_STACK_TEXT").locale
            static let thirdStackText: String = LocalizableString("Premium_Plans_FirstProPlan_THIRD_STACK_TEXT").locale
        }
        
        struct FirstPpuPlan{
            private init(){}
            static let description: String = LocalizableString("Premium_Plans_FirstPpuPlan_DESCRIPTION").locale
            static let note: String = LocalizableString("Premium_Plans_FirstPpuPlan_NOTE").locale
            static let buttonTitle: String = LocalizableString("Premium_Plans_FirstPpuPlan_BUTTON_TITLE").locale
            static let firstStackText: String = LocalizableString("Premium_Plans_FirstPpuPlan_FIRST_STACK_TEXT").locale
            static let secondStackText: String = LocalizableString("Premium_Plans_FirstPpuPlan_SECOND_STACK_TEXT").locale
        }
    }
    
    //MARK: Controller - cell - xib
    struct HomeHeaderTableViewCell{
        private init(){}
        static let description: String = LocalizableString("HomeHeaderTableViewCell_DESC").locale
        static let proDescription: String = LocalizableString("HomeHeaderTableViewCell_DESC_WITH_PRO").locale
        static let enableCategory: String = LocalizableString("HomeHeaderTableViewCell_ENABLE_CATEGORY").locale
    }
    
    struct NewCategoryViewController{
        private init(){}
        static let newCategory: String = LocalizableString("NewCategoryViewController_NEW_CATEGORY").locale
        static let editCategory: String = LocalizableString("NewCategoryViewController_EDIT_CATEGORY").locale
        static let categoryNamePlaceholder: String = LocalizableString("NewCategoryViewController_CAT_NAME_PLACEHOLDER").locale
        static let categoryNameTitle: String = LocalizableString("NewCategoryViewController_CATEGORY_NAME_TITLE").locale
        static let categoryNameDescription: String = LocalizableString("NewCategoryViewController_CATEGORY_NAME_DESCRIPTION").locale
    }
    
    struct NewAnswerViewController{
        private init(){}
        static let answerTitlePlaceholder: String = LocalizableString("NewAnswerViewController_ANSW_TITLE_PLACEHOLDER").locale
        static let answerContentPlaceholder: String = LocalizableString("NewAnswerViewController_ANSW_CONTENT_PLACEHOLDER").locale
        static let deleteAnswerAlertDescription: String = LocalizableString("NewAnswerViewController_DEL_ANS_ALERT_DESCRIPTION").locale
        static let useTitleAsBothText: String = LocalizableString("NewAnswerViewController_USE_TITLE_AS_BOTH_TEXT").locale
        static let answerDescription: String = LocalizableString("NewAnswerViewController_ANSWER_DESCRIPTION").locale
        static let answerTitle: String = LocalizableString("NewAnswerViewController_ANSWER_TITLE").locale
        static let answerTitleDescription: String = LocalizableString("NewAnswerViewController_ANSWER_TITLE_DESCRIPTION").locale
        static let contentTitle: String = LocalizableString("NewAnswerViewController_CONTENT_TITLE").locale
        static let contentDescription: String = LocalizableString("NewAnswerViewController_CONTENT_DESCRIPTION").locale
        
    }
    
    struct WelcomeViewController{
        private init(){}
        static let title: String = LocalizableString("WelcomeViewController_TITLE").locale
        static let desc1: String = LocalizableString("WelcomeViewController_DESC1").locale
        static let desc2: String = LocalizableString("WelcomeViewController_DESC2").locale
    }
    
    struct ViewController{
        private init(){}
        static let title: String = LocalizableString("ViewController_TITLE").locale
        static let deleteCategoryAlertDescription: String = LocalizableString("ViewController_DEL_CAT_ALERT_DESCRIPTION").locale
        static let emptyCategories: String = LocalizableString("ViewController_EMPTY_CATEGORIES").locale
        static let emptyAnswers: String = LocalizableString("ViewController_EMPTY_ANSWERS").locale
        static let noCategoryUsable: String = LocalizableString("ViewController_NO_CATEGORY_USABLE").locale
    }
    
    struct KeyboardEnabledViewController{
        private init(){}
        static let title: String = LocalizableString("KeyboardEnabledViewController_TITLE").locale
    }
    
    struct EnableKeyboardViewController{
        private init(){}
        static let firstStackText: String = LocalizableString("EnableKeyboardViewController_FIRST_STACK_TEXT").locale
        static let secondStackText: String = LocalizableString("EnableKeyboardViewController_SECOND_STACK_TEXT").locale
        static let thirdStackText: String = LocalizableString("EnableKeyboardViewController_THIRD_STACK_TEXT").locale
        static let orText: String = LocalizableString("EnableKeyboardViewController_OR_TEXT").locale
        static let goToSettings: String = LocalizableString("EnableKeyboardViewController_GO_TO_SETTINGS").locale
        static let keyboardDisabled: String = LocalizableString("EnableKeyboardViewController_KEYBOARD_DISABLED").locale
        static let keyboardEnabled: String = LocalizableString("EnableKeyboardViewController_KEYBOARD_ENABLED").locale
    }
    
    struct BiometricViewController{
        private init(){}
        static let middleMessage: String = LocalizableString("BiometricViewController_MIDDLE_MESSAGE").locale
        static let buttonText: String = LocalizableString("BiometricViewController_BUTTON_TEXT").locale
    }
    
    struct SettingsViewController{
        private init(){}
        static let title: String = LocalizableString("SettingsViewController_TITLE").locale
    }
}
