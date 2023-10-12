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
        searchView.itemSelectionBar = ItemSelectionBar(title: "Tìm kiếm", img: UIImage(named: "search")!, isSelected: false)
        searchView.view.backgroundColor = UIColor.blue
        
        let ocbView = OCBView()
        ocbView.itemSelectionBar = ItemSelectionBar(title: "", img: UIImage(named: "Icon OCB.png")!, isSelected: true)
        
        let discoverView = ViewForSelectionBar()
        discoverView.itemSelectionBar = ItemSelectionBar(title: "Khám phá", img: UIImage(named: "discover")!, isSelected: false)
        discoverView.view.backgroundColor = UIColor.brown
        defaultViewControllers = [searchView, ocbView, discoverView]
        viewControllers = defaultViewControllers
        
        
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        contentView.backgroundColor = UIColor.lightGray
        self.view.addSubview(contentView)
        selectionBar.delegate = self
        
        guard let viewControllers = viewControllers else{
            return
        }
        
        self.view.addSubview(selectionBar)
        contrainSelectionBar()
    
        selectionBar.items = viewControllers.map({  view in
            view.itemSelectionBar ?? ItemSelectionBar(title: "not set", img:  UIImage(named: "x")!, isSelected: false)
        })
        
        
    }
    

    private func contrainSelectionBar(){

        selectionBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.view.frame.width * 70/100)
            make.height.equalTo(57)
        }
        
        
        
    
    }
    
    
 
}

extension MainViewController : SelectionBarDelegate{
    func didSelectedItem(at index: Int) {
//        nav to other view
        self.contentView.addSubview(viewControllers![index].view)
        viewControllers![index].didMove(toParent: self)
    }
    
    
}
    
   
    
  
