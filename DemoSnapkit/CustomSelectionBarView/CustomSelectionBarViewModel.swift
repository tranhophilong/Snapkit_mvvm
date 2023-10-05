//
//  CustomSelectionBarViewModel.swift
//  DemoSnapkit
//
//  Created by Long Tran on 04/10/2023.
//

import Foundation


class CustomSelectionBarViewModel{
    var lstItem : ObservableObject<[ItemSelectionBar]> = ObservableObject([])
    
    func showLstItem(){
        lstItem.value =   StateSelectionBar.shared._items
    }
    
    func addItemToSelectionBar(typeView : TypeView){
        StateSelectionBar.shared.addItemToSelectionBar(typeView: typeView)
        showLstItem()
//        lstItem.value = StateSelectionBar.shared.addItemToSelectionBar(title: <#T##String#>)
    }
    
    func deleteItemFromSelectionBar(typeView : TypeView){
        StateSelectionBar.shared.removeItemFromSelectionBar(typeView: typeView)
        showLstItem()
    }
}
