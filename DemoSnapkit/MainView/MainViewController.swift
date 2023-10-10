//
//  MainViewController.swift
//  DemoSnapkit
//
//  Created by Long Tran on 01/10/2023.
//

import UIKit
import SnapKit



class MainViewController: UIViewController{

    
    private var contentView = UIView(frame: .zero)
    private let viewModel =  MainViewModel()
    private lazy var selectionBar = SelectionBar(frame: .zero)
    private var viewControllers : [ViewForSelectionBar]?
    private var defaultViewControllers : [ViewForSelectionBar] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchView = ViewForSelectionBar()
        searchView.itemSelectionBar = ItemSelectionBar(title: "Tìm kiếm", img: UIImage(named: "search")!, typeView: .search)
        
        let centerView = ViewForSelectionBar()
        centerView.itemSelectionBar = ItemSelectionBar(title: "", img: UIImage(named: "refresh")!, typeView: .refresh)
        
        let discoverView = ViewForSelectionBar()
        discoverView.itemSelectionBar = ItemSelectionBar(title: "Khám phá", img: UIImage(named: "discover")!, typeView: .discover)
        defaultViewControllers = [searchView, centerView, discoverView]
        viewControllers = defaultViewControllers
        
        
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        contentView.backgroundColor = UIColor.lightGray
        self.view.addSubview(contentView)
        
        guard let viewControllers = viewControllers else{
            return
        }
        
        self.view.addSubview(selectionBar)
        contrainSelectionBar()
    
        selectionBar.items = viewControllers.map({  view in
            view.itemSelectionBar ?? ItemSelectionBar(title: "not set", img:  UIImage(named: "x")!, typeView: .non )
        })
        
        
    }
    

    private func contrainSelectionBar(){
        selectionBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.view.frame.width * 65/100)
            make.height.equalTo(50)
        }
    
    }
    


    
 
}
    
   
    
  
