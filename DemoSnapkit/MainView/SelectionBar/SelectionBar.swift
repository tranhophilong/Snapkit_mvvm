//
//  SelectionBar.swift
//  DemoSnapkit
//
//  Created by Long Tran on 05/10/2023.
//

import Foundation


import UIKit

protocol SelectionBarDelegate : AnyObject{
   func didSelectedItem(index: Int)
    
}

final class SelectionBar : UIView, UICollectionViewDelegate, UICollectionViewDataSource{
     
     var items : [ItemSelectionBar] = [] {
         didSet{
             
             print(333333)
             collectionViewTabBar.reloadData()
             for i in 0...items.count - 1{
                 if items[i].isSelected{
                     collectionViewTabBar.selectItem(at: IndexPath(item: i, section: 0), animated: false, scrollPosition: .right)
                     delegate?.didSelectedItem(index: 1)
                 }
             }
            
         }
     }
     
          
     weak  var delegate : SelectionBarDelegate?
     
     private let collectionViewTabBar = UICollectionView(frame: .zero, collectionViewLayout: FlexibleWidthLayout())
     
     
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutSelectionBar()
        collectionViewTabBar.register(CellForSelectionBar.self, forCellWithReuseIdentifier: CellForSelectionBar.identifier)
        collectionViewTabBar.delegate = self
        collectionViewTabBar.dataSource = self
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func layoutSelectionBar(){
        self.backgroundColor = UIColor.darkGray
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 23
        self.layer.masksToBounds = true
        self.addSubview(collectionViewTabBar)
        layoutCollectionView()
        
    }
    
    private func layoutCollectionView(){
        let flowlayout = FlexibleWidthLayout()
        flowlayout.delegate  = self
        collectionViewTabBar.contentMode =  .scaleToFill
        collectionViewTabBar.isScrollEnabled = false
        collectionViewTabBar.collectionViewLayout = flowlayout
        collectionViewTabBar.backgroundColor = UIColor.white
        contrainColletionView()
        
    }
    
    private func contrainColletionView(){
        collectionViewTabBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

         return items.count
     }
     func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 1
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellForSelectionBar.identifier, for: indexPath) as! CellForSelectionBar
         let itemTabbar = items[indexPath.item]
         
         cell.config(title: itemTabbar.title, img: itemTabbar.img)
         cell.isSelected = false
         if (indexPath.item >= items.count / 2){
             cell.isFristTitle = false
         }else{
             cell.isFristTitle = true
         }
         return cell
         
     }
     

     
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         delegate?.didSelectedItem(index: indexPath.item)
         items[indexPath.item].isSelected = true
         layoutIfNeeded()

         collectionViewTabBar.collectionViewLayout.invalidateLayout()
//         items.forEach { item in
//             print(item.isSelected)
//         }
//         
     }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        items[indexPath.item].isSelected = false
    }


     

 }

extension SelectionBar : FlexibleWidthLayoutProtocol{
    func collectionView(_ collectionView: UICollectionView, sizeItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        var widthForPresentItem = self.frame.width - 20
        var width  : CGFloat = 0
        if items[indexPath.item].isSelected == true{
            width = widthForPresentItem * 50/100
        }else if items[indexPath.item].isSelected == false{
            width = (widthForPresentItem / 2 ) / CGFloat(items.count - 1)
        }
    
        
       return CGSize(width: width,  height: self.frame.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, insetsForItemsInSection section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemSpacingInSection section: Int) -> CGFloat {
        return 0
    }
    
    
}
 
 class CellForSelectionBar : UICollectionViewCell{
     
     
    private  let titleView = UILabel()
    private  let imgView = UIImageView()
    private let stackView = UIStackView()
     var isFristTitle : Bool?{
         didSet{
             if isFristTitle == false{
                 stackView.addArrangedSubview(stackView.subviews[0])
                 layoutSubviews()
             }else{
                 stackView.addArrangedSubview(stackView.subviews[1])
                 layoutSubviews()
             }
         }
     }
     static let identifier = "CellForSelectionBar"
     
     override var isSelected: Bool{
         didSet{
             if isSelected{
                 UIView.animate(withDuration: 0.5) { [weak self] in
                     guard let self = self else{
                         return
                     }
                     stackView.backgroundColor = UIColor.customGreen
                     titleView.isHidden = false
                     
                     
                 }
             
             }else{
                 UIView.animate(withDuration: 0.5) {  [weak self] in
                     guard let self = self else{
                         return
                     }
                     stackView.backgroundColor = UIColor.white
                     titleView.isHidden = true
                 }
               
             }
             
         }
     }
     
     override init(frame: CGRect) {
         super.init(frame: frame)
         layoutCell()

     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     

     
     func config(title : String, img : UIImage){
         self.titleView.text = title
         imgView.image = img
     }
     
     private func layoutCell(){
         
         titleView.textColor = UIColor.black
         titleView.adjustsFontSizeToFitWidth = true
         titleView.contentMode = .right
         titleView.font = titleView.font.withSize(14)
         
         imgView.contentMode = .scaleAspectFit
         imgView.tintColor = UIColor.darkGreen
         
         stackView.distribution =  .fillProportionally
         stackView.alignment = .center
         stackView.backgroundColor = UIColor.customGreen
         stackView.axis = .horizontal
         stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
         stackView.isLayoutMarginsRelativeArrangement = true
         
             stackView.addArrangedSubview(titleView)
             stackView.addArrangedSubview(imgView)
         
         self.contentView.backgroundColor = UIColor.white
         self.contentView.addSubview(stackView)
         
         contrainStackView()
         self.layer.cornerRadius = self.frame.height / 2
         self.backgroundColor = UIColor.white
         self.layer.borderColor = UIColor.white.cgColor
         self.clipsToBounds = true
         
         
     }
     
     private func contrainStackView(){
         stackView.snp.makeConstraints { make in
             make.top.equalToSuperview()
             make.bottom.equalToSuperview()
             make.leading.equalToSuperview()
             make.trailing.equalToSuperview()
         }
     }
     
     
     
 }
 
 



