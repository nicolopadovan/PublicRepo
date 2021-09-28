//
//  AlgoliaAPI.swift
//  ios
//
//  Created by Nicolò Padovan on 29/08/21.
//

import UIKit
import Firebase
import InstantSearch

struct AlgoliaAPI: ErrorDelegate {
    init(errorView: UIView?, errorLabel: UILabel?) {
        self.errorView = errorView
        self.errorLabel = errorLabel
    }
    
    var errorView: UIView?
    var errorLabel: UILabel?
    var error: AuthErrorCode?
    var textField: UITextField?
    
    init(errorView: UIView?=nil, errorLabel: UILabel?=nil, textField: UITextField) {
        self.errorView = errorView
        self.errorLabel = errorLabel
        self.textField = textField
        
        AlgoliaManager.shared.searchQueryController.setTextField(textField: textField)
    }
    
    /// Result, shouldShowLoadingAnimation
    func subscribe(closure: (([Skill], Bool) -> Void)?) {
        
        AlgoliaManager.shared.searchQueryController.setTextField(textField: textField)
        
        AlgoliaManager.shared.subscribe { success, result, error, isLoading in
            
            if !isLoading {
                if success {
                    closure?(result, false)
                    return
                }
                self.showError(error: error)
            } else {
                closure?([], true)
            }
        }
    }
    
    func unsubscribe() {
        AlgoliaManager.shared.unsubscribe()
    }
    
}
