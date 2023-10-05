//
//  StateSelectionBar.swift
//  DemoSnapkit
//
//  Created by Long Tran on 04/10/2023.
//

import Foundation

import UIKit

class StateSelectionBar{
    static let shared = StateSelectionBar()
    
    private let items = [ItemSelectionBar(title: "Cá nhân", img: UIImage(named: "person")!, typeView: .peronal), ItemSelectionBar(title: "Yêu thích", img: UIImage(named: "heart")!, typeView: .favorite)]
    
    var _items: [ItemSelectionBar]{
        return items
    }
    
    
    private init(){
        items.forEach { item in
            item.isHidden = true
        }
    }
    
    func addItemToSelectionBar(typeView : TypeView){
        items.forEach { item in
            if item.typeView == typeView{
                item.isHidden = false
            }
        }
    }
    
    func removeItemFromSelectionBar(typeView : TypeView){
        items.forEach { item in
            if item.typeView == typeView{
                item.isHidden = true
            }
        }
    }
}
