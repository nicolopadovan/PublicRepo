//
//  AlgoliaAPI.swift
//  ios
//
//  Created by Nicolò Padovan on 29/08/21.
//

import UIKit
import InstantSearch

struct AlgoliaAPI {
    init(errorView: UIView?, errorLabel: UILabel?) {
        self.errorView = errorView
        self.errorLabel = errorLabel
    }
    
    var errorView: UIView?
    var errorLabel: UILabel?
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
            // Does nothing
        }
    }
    
    func unsubscribe() {
        AlgoliaManager.shared.unsubscribe()
    }
    
}

struct Skill: Codable, Equatable {
    
    let objectID: String
    let name: String
    let tags: [String]
    let iconURL: String
    
    static func == (lhs: Skill, rhs: Skill) -> Bool {
        return lhs.objectID == rhs.objectID
    }
    
}
