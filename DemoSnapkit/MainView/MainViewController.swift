//
//  MainViewController.swift
//  DemoSnapkit
//
//  Created by Long Tran on 01/10/2023.
//

import UIKit
import SnapKit



class MainViewController: UIViewController, SelectionBarDelegate, RefreshViewDelegate{

    
    private var contentView = UIView(frame: .zero)
    private let viewModel =  MainViewModel()
    private lazy var selectionBar = SelectionBar(frame: .zero)
    private var viewControllers : [ViewForSelectionBar]?
    private var defaultViewControllers : [ViewForSelectionBar] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionBar.delegate = self
        let searchView = SearchView()
        searchView.itemSelectionBar = ItemSelectionBar(title: "Tìm kiếm", img: UIImage(named: "search")!, typeView: .search)
        
        let refreshView = RefreshView()
        refreshView.delegate = self
        refreshView.itemSelectionBar = ItemSelectionBar(title: "", img: UIImage(named: "refresh")!, typeView: .refresh)
        
        let discoverView = DiscoverView()
        discoverView.itemSelectionBar = ItemSelectionBar(title: "Khám phá", img: UIImage(named: "discover")!, typeView: .discover)
        defaultViewControllers = [searchView, refreshView, discoverView]
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
        
        
        setupBinder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        viewModel.loadMoreView()
    
    }
    

    private func contrainSelectionBar(){
        selectionBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.view.frame.width * 83/100)
            make.height.equalTo(50)
        }
    
    }
    
    
    func setupBinder(){
        viewModel.views.bind { [weak self] lstView in
            var moreViews : [ViewForSelectionBar] = []
            var moreItems : [ItemSelectionBar] = []
            
//         
            lstView.forEach { view in
                moreViews.append(view)
                moreItems.append(view.itemSelectionBar!)
            }
            
            var defaultItem : [ItemSelectionBar] = []
            
            self?.defaultViewControllers.forEach { view in
                defaultItem.append(view.itemSelectionBar!)
            }
            
            self?.viewControllers = self!.defaultViewControllers + moreViews
            self?.selectionBar.items = defaultItem + moreItems

        }
    }
    

    
    func navtoCustomSelectionBar() {
        let customSelectionBarView = CustomSelectionBarView()

        self.navigationController?.pushViewController(customSelectionBarView, animated: true)
    }

    func didSelectedItem(index: Int) {
        contentView.addSubview(viewControllers![index].view)
        viewControllers![index].didMove(toParent: self)
    }


    
}
    
   
    
  
