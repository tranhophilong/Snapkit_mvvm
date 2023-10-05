//
//  MainViewModel.swift
//  DemoSnapkit
//
//  Created by Long Tran on 03/10/2023.
//

import Foundation


class MainViewModel{
    
    var views : ObservableObject<[ViewForSelectionBar]> = ObservableObject([])
    func loadMoreView(){
        var tempViews : [ ViewForSelectionBar] = []
        StateSelectionBar.shared._items.forEach { item in
            if item.isHidden == false{
                if item.typeView == .favorite{
                    var favoriteView = FavoriteView()
                    favoriteView.itemSelectionBar = item
                    tempViews.append(favoriteView)
                }else if item.typeView == .peronal{
                    var personalView = PersonalView()
                    personalView.itemSelectionBar = item
                    tempViews.append(personalView)
                }
                
            }
        }
        
        views.value = tempViews
    }
    
    
}
