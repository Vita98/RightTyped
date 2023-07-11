//
//  LocalizableHelper.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 09/07/23.
//

import Foundation

struct AppString{
    
    struct General{
        static let category: String = LocalizableString("GENERAL_CATEGORY").locale
        static let categories: String = LocalizableString("GENERAL_CATEGORIES").locale
        static let edit: String = LocalizableString("GENERAL_EDIT").locale
        static let delete: String = LocalizableString("GENERAL_DELETE").locale
        static let answerSearchBarPlaceholder: String = LocalizableString("GENERAL_ANSW_SEARCH_BAR_PLACEHOLDER").locale
        static let answer: String = LocalizableString("GENERAL_ANSWER").locale
    }
    
    struct Alerts{
        static let yes: String = LocalizableString("Alerts_YES").locale
        static let no: String = LocalizableString("Alerts_NO").locale
        static let titleAreYouSure: String = LocalizableString("Alerts_TITLE_ARE_YOU_SURE").locale
        static let genericGoBackWithoutSaving: String = LocalizableString("Alerts_GO_BACK_WSAVING").locale
    }
    
    struct SettingsTypeEnum{
        static let app: String = LocalizableString("SettingsTypeEnum_APP").locale
        static let keyboard: String = LocalizableString("SettingsTypeEnum_KEYBOARD").locale
        static let tutorial: String = LocalizableString("SettingsTypeEnum_TUTORIAL").locale
    }
    
    struct SettingsModel{
        static let touchIDText: String = LocalizableString("SettingsModel_TOUCH_ID").locale
        static let goBackToDefaultKeyboardText: String = LocalizableString("SettingsModel_GO_BACK_TO_DEFAULT_KEYBOARD").locale
        static let howToEnableKeyboardText: String = LocalizableString("SettingsModel_HOW_TO_ENABLE_KEYBOARD").locale
        static let howToUseKeyboardText: String = LocalizableString("SettingsModel_HOW_TO_USE_KEYBOARD").locale
        static let howToCustomizeKeyboardText: String = LocalizableString("SettingsModel_HOW_TO_CUSTOMIZE_KEYBOARD").locale
    }
    
    //MARK: Controller - cell - xib
    struct HomeHeaderTableViewCell{
        static let description: String = LocalizableString("HomeHeaderTableViewCell_DESC").locale
        static let enableCategory: String = LocalizableString("HomeHeaderTableViewCell_ENABLE_CATEGORY").locale
    }
    
    struct NewCategoryViewController{
        static let newCategory: String = LocalizableString("NewCategoryViewController_NEW_CATEGORY").locale
        static let editCategory: String = LocalizableString("NewCategoryViewController_EDIT_CATEGORY").locale
        static let categoryNamePlaceholder: String = LocalizableString("NewCategoryViewController_CAT_NAME_PLACEHOLDER").locale
    }
    
    struct NewAnswerViewController{
        static let answerTitlePlaceholder: String = LocalizableString("NewAnswerViewController_ANSW_TITLE_PLACEHOLDER").locale
        static let answerContentPlaceholder: String = LocalizableString("NewAnswerViewController_ANSW_CONTENT_PLACEHOLDER").locale
        static let deleteAnswerAlertDescription: String = LocalizableString("NewAnswerViewController_DEL_ANS_ALERT_DESCRIPTION").locale
    }
    
    struct ViewController{
        static let deleteCategoryAlertDescription: String = LocalizableString("ViewController_DEL_CAT_ALERT_DESCRIPTION").locale
        static let emptyCategories: String = LocalizableString("ViewController_EMPTY_CATEGORIES").locale
    }
}
