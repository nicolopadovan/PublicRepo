//
//  SearchViewController.swift
//  ios
//
//  Created by Nicolò Padovan on 27/08/21.
//

import UIKit
import AlgoliaSearchClient
import InstantSearch

class SearchViewController: ViewController, UISearchResultsUpdating {
    
    var searchController = UISearchController(searchResultsController: nil)
    lazy var API = AlgoliaAPI(errorView: view, textField: searchController.searchBar.searchTextField)
    var didShow = false
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var skillsDatasource: [Skill] = []
    
    override func setupConstraints() {
        super.setupConstraints()
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: .zero)
        
    }
    
    override func setupStyles() {
        super.setupStyles()
        
        collectionView.showsVerticalScrollIndicator = false
        
        view.backgroundColor = .lighterGray
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Categorie"
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
    }
    
    override func setupLogic() {
        super.setupLogic()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false

        definesPresentationContext = true
        navigationItem.searchController = searchController
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NestedSearchCell.self, forCellWithReuseIdentifier: "cellid")
        collectionView.allowsSelection = true
        
        hitsSource = HitsInteractor<Skill>(infiniteScrolling: .off, showItemsOnEmptyQuery: true)
        AlgoliaManager.shared.hitsInteractor.connectController(self)
        API.subscribe(closure: nil)
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.isActive {
            return
        }
    }
    
    public var hitsSource: HitsInteractor<Skill>?
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! NestedSearchCell
        guard let skill = hitsSource?.hit(atIndex: indexPath.row) else { return cell }
        
        cell.skillTitleLabel.text = skill.name
        cell.iconView.loadImageUsingCache(withUrl: skill.iconURL)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hitsSource?.numberOfHits() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 70)/3 , height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = MatchVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

extension SearchViewController: HitsController {
    func scrollToTop() {
        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    func reload() {
        self.collectionView.reloadData()
    }
}
