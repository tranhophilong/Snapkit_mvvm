//
//  RefreshView.swift
//  DemoSnapkit
//
//  Created by Long Tran on 04/10/2023.
//

import UIKit
import SnapKit


protocol RefreshViewDelegate{
    func navtoCustomSelectionBar()
}

class RefreshView: ViewForSelectionBar {
    
    private let viewModel = RefreshViewModel()
    
    private let btn = UIButton(frame: .zero)
    
    var delegate : RefreshViewDelegate?
    
    lazy var refreshViewNav = UINavigationController(rootViewController: self)
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        itemSelectionBar = ItemSelectionBar(title: "", img: UIImage(named: "refresh")!, typeView: .refresh)
        self.view.backgroundColor = UIColor.lightGray
        btn.setTitle("Điều chỉnh thanh chuyển hướng", for:  .normal)
        btn.backgroundColor = UIColor.white
        btn.tintColor = UIColor.black
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(goToCustomSelectionBarView), for: .touchUpInside)
        
//        refreshViewNav.viewControllers = [self, customSelectionBarView]
        self.view.addSubview(btn)
        contrainBtn()
    }
    
    private func contrainBtn(){
        btn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(33333)
    }
    
    @objc private func goToCustomSelectionBarView(){
//        let customSelectionBarView = CustomSelectionBarView()
//       
//        self.present(customSelectionBarView, animated: true)//example of usage
        delegate?.navtoCustomSelectionBar()
//
    }
    
    
    


}
