//
//  ItemSelectionBar.swift
//  DemoSnapkit
//
//  Created by Long Tran on 03/10/2023.
//


import UIKit

final class ItemSelectionBar{
     var title : String
     var img : UIImage
        var isHidden : Bool = false
    let typeView : TypeView
    init(title: String, img: UIImage, typeView : TypeView) {
        self.title = title
        self.img = img
        self.typeView = typeView
    }
    
  
}
