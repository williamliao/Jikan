//
//  TopSearchViewModel.swift
//  Jikan
//
//  Created by 雲端開發部-廖彥勛 on 2021/2/9.
//  Copyright © 2021 William Liao. All rights reserved.
//

import Foundation

class TopSearchViewModel {
    
    var viewModel: TopViewModel!
    
    var category: SearchItem.ScopeTypeSection!
    
    init(viewModel: TopViewModel) {
        self.viewModel = viewModel
    }
    
    func searchFor(text: String,  category: SearchItem.ScopeTypeSection) {

        filterContentForSearchText(text, category: category)

        if viewModel.filterRespone.value.count > 0 {
            viewModel.isSearching.value = true
        } else {
            // 可加入一個查找不到的資料的label來告知使用者查不到資料...
        }
    }
    
    func didCloseSearchFunction() {
        viewModel.isSearching.value = false
        viewModel.filterRespone.value = []
    }
    
    func didChangeSelectedScopeButtonIndex(scopeButtonTitle: String, searchText:String) {
        filterContentForSearchText(searchText)
    }
    
    func filterContentForSearchText(_ searchText: String,
                                    category: SearchItem.ScopeTypeSection? = nil) {

        guard let top = viewModel.respone.value?.top else {
            return
        }
        
        viewModel.filterRespone.value = top.filter({ (top: Top) -> Bool in
            filterTitleKeyword(top: top, searchText: searchText, category: category)
        })
    }
    
    func filterTitleKeyword(top: Top, searchText: String, category: SearchItem.ScopeTypeSection? = nil) -> Bool {
        
        let doesCategoryMatch = self.category == category
        
        let isSearchBarEmpty: Bool = searchText.isEmpty
        
        print("doesCategoryMatch \(doesCategoryMatch) \(self.category) \(category)")
        
        if isSearchBarEmpty {
          return doesCategoryMatch
        } else {
            return doesCategoryMatch && top.title.lowercased()
              .contains(searchText.lowercased())
        }
        
    }
}
