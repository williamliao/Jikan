//
//  SearchViewController.swift
//  CandyWithMVVMC
//
//  Created by William on 2020/12/25.
//  Copyright © 2020 William. All rights reserved.
//

import UIKit

//protocol SearchResultsViewControllerDelegate: class {
//   func reassureShowingList() -> Void
//}

class SearchViewController: UISearchController {
    
    //weak var searchResultsDelegate: SearchResultsViewControllerDelegate?
    var viewModel: TopViewModel!
    init(viewModel: TopViewModel) {
        self.viewModel = viewModel
        super.init(searchResultsController: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var searchViewModel: TopSearchViewModel!
   
    var isSearchBarEmpty: Bool {
        return self.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        let searchBarScopeIsFiltering = self.searchBar.selectedScopeButtonIndex != 0
        return self.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        searchViewModel = TopSearchViewModel(viewModel: self.viewModel)
        //searchViewModel.setSearchFooter(searchFooter: searchFooter)
        self.searchResultsUpdater = self
        self.searchBar.autocapitalizationType = .none
        //self.dimsBackgroundDuringPresentation = false
        self.searchBar.delegate = self
        self.searchBar.sizeToFit()
        self.obscuresBackgroundDuringPresentation = true
        self.searchBar.placeholder = "Search Candies"
        definesPresentationContext = true
        createTypeButtonView()
       // self.showsSearchResultsController = true
        //self.searchBar.scopeButtonTitles = SearchItem.ScopeTypeSection.allCases.map { $0.rawValue }
    }
    
    func createTypeButtonView() {
        let buttonContentView = UIStackView()
        buttonContentView.axis  = NSLayoutConstraint.Axis.horizontal
        buttonContentView.distribution  = UIStackView.Distribution.equalSpacing
        buttonContentView.alignment = UIStackView.Alignment.center
        //buttonContentView.spacing   = 16.0
        
        for title in SearchItem.ScopeTypeSection.allCases.map({ $0.rawValue }) {
            let button = UIButton()
            button.titleLabel?.text = title
            button.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)
            buttonContentView.addArrangedSubview(button)
        }
        
        let textField = self.searchBar.searchTextField
        
        textField.superview!.addSubview(buttonContentView)
        
        buttonContentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonContentView.topAnchor.constraint(equalTo: textField.bottomAnchor),
            buttonContentView.leadingAnchor.constraint(equalTo: textField.superview!.leadingAnchor),
            buttonContentView.trailingAnchor.constraint(equalTo: textField.superview!.trailingAnchor),
            buttonContentView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func pressed(sender: UIButton!) {
        
    }
    
    func reassureShowingList() {
        //searchController.searchResultsController!.view.hidden = false
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {

      // Always show the search result controller
        searchController.searchResultsController?.view.isHidden = false

      // Update your search results data and reload data
      
   }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text.isEmptyOrWhitespace() {
            return
        }
        
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString =
            searchText.trimmingCharacters(in: whitespaceCharacterSet)
       // let searchItems = strippedString.components(separatedBy: " ") as [String]
        
        let searchBar = searchController.searchBar
        let category = SearchItem.ScopeTypeSection(rawValue:
          searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        self.searchViewModel.category = category!
        self.searchViewModel.searchFor(text: strippedString, category: category!)
    }
}

extension SearchViewController :UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        closeSearchView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            closeSearchView()
        }
    }
    
    func closeSearchView() {
        //self.searchBar.showsScopeBar = false
        self.searchViewModel.didCloseSearchFunction()
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let category = SearchItem.ScopeTypeSection(rawValue:
          searchBar.scopeButtonTitles![selectedScope])
        self.searchViewModel.category = category
        self.searchViewModel.searchFor(text: searchBar.text!, category: category!)
    }
}
