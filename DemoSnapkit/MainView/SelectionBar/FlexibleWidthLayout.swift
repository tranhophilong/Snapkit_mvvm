//
//  FlexibleWidthLayout.swift
//  DemoSnapkit
//
//  Created by Long Tran on 10/10/2023.
//

import Foundation

import UIKit


protocol FlexibleWidthLayoutProtocol : AnyObject{
    func collectionView(_ collectionView: UICollectionView, sizeItemAtIndexPath indexPath: IndexPath) -> CGSize
    func collectionView(_ collectionView: UICollectionView, insetsForItemsInSection section: Int) -> UIEdgeInsets
    func collectionView(_ collectionView: UICollectionView, itemSpacingInSection section: Int) -> CGFloat
}


class FlexibleWidthLayout: UICollectionViewLayout {
    
    weak var delegate: FlexibleWidthLayoutProtocol?
    
    // Total height of the content. Will be used to configure the scrollview content
    var layoutHeight: CGFloat = 0.0
    
    
    
    private var itemCache: [UICollectionViewLayoutAttributes] = []
    
    override func prepare() {
        super.prepare()

        itemCache.removeAll()
        
        guard let collectionView = collectionView else {
            return
        }
        
        // Variable to track the width of the layout at the current state when the item is being drawn
       
        
        for section in 0..<collectionView.numberOfSections {
                        
            let insets: UIEdgeInsets = delegate?.collectionView(collectionView, insetsForItemsInSection: section) ?? UIEdgeInsets.zero
            let interItemSpacing: CGFloat = delegate?.collectionView(collectionView, itemSpacingInSection: section) ?? 0.0
            var itemSize: CGSize = .zero
            
            var layoutWidthIterator: CGFloat = 0.0
            
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                
                itemSize = delegate?.collectionView(collectionView, sizeItemAtIndexPath: IndexPath(item: item, section: section)) ?? .zero
                
                if (layoutWidthIterator + itemSize.width + insets.left + insets.right) > collectionView.frame.width {
                    layoutWidthIterator = 0.0
                    layoutHeight += itemSize.height + interItemSpacing
                }

                let frame = CGRect(x: layoutWidthIterator + insets.left, y: layoutHeight, width: itemSize.width, height: itemSize.height)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                attributes.center.y  = collectionView.center.y
                itemCache.append(attributes)
                layoutWidthIterator = layoutWidthIterator + frame.width + interItemSpacing
                
            }
            layoutHeight += itemSize.height + insets.bottom
            layoutWidthIterator = 0
            

        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect)-> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)
        
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in itemCache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }

        
        return visibleLayoutAttributes
    }
    

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        super.layoutAttributesForItem(at: indexPath)
        return itemCache[indexPath.row]
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: layoutHeight)
    }
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        layoutHeight = 0.0
        return true
    }
}
