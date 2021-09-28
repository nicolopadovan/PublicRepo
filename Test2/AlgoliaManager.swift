//
//  AlgoliaManager.swift
//  ios
//
//  Created by Nicolò Padovan on 29/08/21.
//

import Foundation
import AlgoliaSearchClient
import InstantSearch

class AlgoliaManager: NSObject {
    
    static let shared = AlgoliaManager()
    
    fileprivate static let appID: ApplicationID = "APP_ID"
    fileprivate static let apiKey: APIKey = APIKey(rawValue: "API_KEY")
    fileprivate static let indexName: IndexName = "skills_dev"
    fileprivate static let suggestionsIndexName: IndexName = "skills_dev_query_suggestions"
    fileprivate static let client = SearchClient(appID: appID, apiKey: apiKey)
    fileprivate let index = client.index(withName: "skills_dev")
    
    fileprivate var searcher: SingleIndexSearcher = SingleIndexSearcher(appID: AlgoliaManager.appID, apiKey: AlgoliaManager.apiKey, indexName: AlgoliaManager.indexName)
    fileprivate var suggestionsSearcher: SingleIndexSearcher = SingleIndexSearcher(appID: AlgoliaManager.appID, apiKey: AlgoliaManager.apiKey, indexName: AlgoliaManager.suggestionsIndexName)
    
    var hitsInteractor = HitsInteractor<Skill>(infiniteScrolling: .on(withOffset: 13), showItemsOnEmptyQuery: true)
    lazy var searchQueryController = SearchQueryController()
    fileprivate var queryInputInteractor = QueryInputInteractor()
    public var isLoading: Bool = false
    
    /// Success, results, error, isLoading
    var closure: ((Bool, [Skill], Error?, Bool) -> Void)? = nil
    var suggestionsClosure: ((Bool, [Skill], Error?, Bool) -> Void)? = nil
    func subscribe(closure: @escaping (Bool, [Skill], Error?, Bool) -> Void) {
        self.closure = closure
        
        queryInputInteractor.connectController(searchQueryController)
        queryInputInteractor.connectSearcher(searcher)
        hitsInteractor.connectSearcher(searcher)
        
//        searcher.onResults.subscribe(with: self) { vc, results in
//            let res = (try? results.extractHits() as [Skill]) ?? []
//            self.closure?(true, res, nil, false)
//        }
//
//        searcher.onError.subscribe(with: self) { _, error in
//            self.closure?(false, [], error, false)
//        }
//
//        searcher.isLoading.subscribe(with: self) { _, isLoading in
//            if isLoading {
//                self.closure?(false, [], nil, isLoading)
//            }
//        }
        
        searcher.search()
    }
    
    func unsubscribe() {
        searcher = SingleIndexSearcher(appID: AlgoliaManager.appID, apiKey: AlgoliaManager.apiKey, indexName: AlgoliaManager.indexName)
        hitsInteractor = HitsInteractor<Skill>(infiniteScrolling: .on(withOffset: 13), showItemsOnEmptyQuery: true)
        searchQueryController = SearchQueryController()
        queryInputInteractor = QueryInputInteractor()
    }
    
    func getUsers(query: String) {
        
    }
}

class SearchQueryController: NSObject, QueryInputController {
    
    var onQueryChanged: ((String?) -> Void)?
    var onQuerySubmitted: ((String?) -> Void)?
    
    var textField: UITextField?
    
    init(textField: UITextField?=nil) {
        self.textField = textField
        super.init()
        setupTextField()
    }
    
    func setTextField(textField: UITextField?) {
        self.textField = textField
        setupTextField()
    }
    
    func setQuery(_ query: String?) {
        textField?.text = query
    }
    
    private func setupTextField() {
        textField?.returnKeyType = .search
        textField?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField?.addTarget(self, action: #selector(textFieldDidReturn), for: .editingDidEndOnExit)
    }
 
    @objc private func textFieldDidChange() {
        onQueryChanged?(textField?.text)
    }
    
    @objc private func textFieldDidReturn() {
        textField?.resignFirstResponder()
        onQuerySubmitted?(textField?.text)
    }
    
}
