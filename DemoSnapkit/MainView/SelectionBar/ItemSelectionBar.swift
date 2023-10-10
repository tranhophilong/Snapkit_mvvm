//
//  ItemSelectionBar.swift
//  DemoSnapkit
//
//  Created by Long Tran on 03/10/2023.
//


import UIKit

struct ItemSelectionBar{
     var title : String
     var img : UIImage
    var isSelected : Bool
    init(title: String, img: UIImage, isSelected : Bool) {
        self.title = title
        self.img = img
        self.isSelected = isSelected
    }
    
  
}
