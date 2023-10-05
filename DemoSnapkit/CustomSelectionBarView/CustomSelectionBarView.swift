//
//  CustomSelectionBarView.swift
//  DemoSnapkit
//
//  Created by Long Tran on 04/10/2023.
//

import UIKit
import SnapKit

class CustomSelectionBarView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    
    private let viewModel = CustomSelectionBarViewModel()
    private lazy var titleView = UILabel(frame: .zero)
    private lazy var tableView = UITableView(frame: .zero)
    
    private lazy var items : [ItemSelectionBar] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = false
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(titleView)
        self.view.addSubview(tableView)
        contrainTableView()
        setupTableView()
        layoutTitle()
        setUpBinders()
        showlstItem()
    }
    
    private func setupTableView(){
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func showlstItem(){
        viewModel.showLstItem()
    }
    
    private func layoutTitle(){
        titleView.text = "Điều chỉnh thanh chuyển hướng"
        titleView.font = UIFont.systemFont(ofSize: 20)
        contrainTitleView()
    }
    
    private func contrainTitleView(){
        titleView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
    }
    
    private func contrainTableView(){
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleView).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setUpBinders(){
        viewModel.lstItem.bind { [weak self] lstItem in
            self?.items = lstItem
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        let item = items[indexPath.row]
        cell.lblCallback = { [weak self] in
            if item.isHidden{
                self?.viewModel.addItemToSelectionBar(typeView: item.typeView)

            }else{
                self?.viewModel.deleteItemFromSelectionBar(typeView: item.typeView)
            }
        }
        cell.config(title: item.title, img: item.img, isHidden: item.isHidden)
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    


}


class CustomTableViewCell : UITableViewCell{
    private lazy var imgView = UIImageView(frame: .zero)
    private lazy var titleView = UILabel(frame: .zero)
    private lazy var stackView = UIStackView(frame: .zero)
    private lazy var btnIshidden = UIButton(frame: .zero)
    
    var lblCallback : () -> () = {}
    
    static let identifier = "CustomTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutView()
        btnIshidden.addTarget(self, action: #selector(actionClick), for: .touchUpInside)
        
    }
    
    @objc func actionClick(){
        lblCallback()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       
    }
    

    func config(title : String, img : UIImage, isHidden : Bool){
        titleView.text = title
        imgView.image = img
        btnIshidden.setTitle(isHidden ? "Bật" : "Tắt", for: .normal)
    }

  private func layoutView(){
        imgView.contentMode =  .scaleAspectFit
      
      
        titleView.contentMode = .center
        btnIshidden.contentMode = .center
        btnIshidden.setTitleColor(UIColor.black, for: .normal)
        
        stackView.axis = .horizontal
        stackView.addArrangedSubview(imgView)
        stackView.addArrangedSubview(titleView)
//        stackView.addArrangedSubview(btnIshidden)
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.backgroundColor = UIColor.white
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        self.contentView.addSubview(stackView)
        self.contentView.addSubview(btnIshidden)
        contrain()
    }
    
    
    private func contrain(){
        

        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(40)
            make.width.equalTo(self.contentView.frame.width * 50/100)
        }
        
        btnIshidden.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
}
