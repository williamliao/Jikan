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
    
   // var category: SearchItem.ScopeTypeSection!
    
    var type: String!
    var subType: String!
    
    init(viewModel: TopViewModel) {
        self.viewModel = viewModel
    }
    
    func searchFor(text: String,  type: String, subType:String) {

        filterContentForSearchText(text, type: type, subType: subType)

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
        filterContentForSearchText(searchText, type: "", subType: "")
    }
    
    func filterContentForSearchText(_ searchText: String,
                                    type: String, subType:String) {

        guard let top = viewModel.respone.value?.top else {
            return
        }
        
        viewModel.filterRespone.value = top.filter({ (top: Top) -> Bool in
            filterTitleKeyword(top: top, searchText: searchText, type: type, subType: subType)
        })
        
        //print("filterRespone \(viewModel.filterRespone.value)")
    }
    
    func filterTitleKeyword(top: Top, searchText: String, type: String, subType:String) -> Bool {
        
      //  let doesCategoryMatch = top.type == type
        
        let isSearchBarEmpty: Bool = searchText.isEmpty
        
        //print("doesCategoryMatch \(doesCategoryMatch) \(self.type) \(category)")
        
        if isSearchBarEmpty {
          return false
        } else {
            
           // print("match \(top.title.lowercased()) \(doesCategoryMatch) \(top.type)")
            return top.title.lowercased()
              .contains(searchText.lowercased())

        }
        
    }
}
