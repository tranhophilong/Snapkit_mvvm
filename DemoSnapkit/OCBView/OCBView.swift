//
//  OCBView.swift
//  DemoSnapkit
//
//  Created by Long Tran on 10/10/2023.
//

import UIKit
import SnapKit

protocol OCBViewDelegate {
    func navToOtherView(item : QuickAccessibilityItem)
}

class OCBView: ViewForSelectionBar, QuickAccessibilityViewDelegate{
    func navToQuickAccessView(at index: Int) {
        delegate?.navToOtherView(item: items[index])
    }
    
    func expandQuickAccessibilityView() {
        viewWillLayoutSubviews()
    }
    
    let viewModel = MainViewModel()
    var delegate : OCBViewDelegate?
    private lazy var  backgroundView = UIImageView(frame: .zero)
    private let items : [QuickAccessibilityItem] = [
        QuickAccessibilityItem(image: UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))!, title: "Yêu thích"),
        QuickAccessibilityItem(image: UIImage(systemName: "person.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))!, title: "Tài khoản cá nhân"),
        QuickAccessibilityItem(image: UIImage(systemName: "qrcode", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))!, title: "Quét mã"),
        QuickAccessibilityItem(image: UIImage(systemName: "qrcode", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))!, title: "Quét mã"),
        QuickAccessibilityItem(image: UIImage(systemName: "qrcode", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))!, title: "Quét mã"),
        QuickAccessibilityItem(image: UIImage(systemName: "qrcode", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))!, title: "Quét mã"),
        QuickAccessibilityItem(image: UIImage(systemName: "qrcode", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))!, title: "Quét mã"),
        QuickAccessibilityItem(image: UIImage(systemName: "qrcode", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))!, title: "Quét mã"),
        QuickAccessibilityItem(image: UIImage(systemName: "qrcode", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))!, title: "Quét mã"),
    ]
    private lazy var quickAccessibilityView  = QuickAccessibilityView(frame: .zero, items: items, balance: "VND")
    private  var heightquickAccessibilityView : Constraint!
    private let label = UILabel(frame: .zero)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundView)
        view.addSubview(quickAccessibilityView)
        quickAccessibilityView.delegate = self

        layout()
        contrain()
        setupBinder()
//        viewModel.getUser()
    }
    
    
    func setupBinder(){
        viewModel.user.bind { [weak self] user in
            self!.quickAccessibilityView.balance = user.balance + " " +  self!.quickAccessibilityView.balance
        }
    }
    
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseIn) { [weak self] in
            let heightContentQuickAccessibilityView = self!.quickAccessibilityView.heightContent
            if heightContentQuickAccessibilityView != 0 {
                self!.heightquickAccessibilityView.update(offset: heightContentQuickAccessibilityView)
            }
        }
       
        
    }
    
//    private func layoutHeightQuickAccessibilityView(){
//        
//    }
    
    
    private func layout(){
//        layout background view
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.image = UIImage(named: "bitexco-ill.jpeg")
    }
    
    
    private func contrain(){
        backgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        quickAccessibilityView.snp.makeConstraints { [weak self] make in
            make.centerY.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(self!.view.frame.width * 90/100)
            heightquickAccessibilityView =  make.height.equalTo(self!.view.frame.height * 40/100).constraint
        }
        
     
        
    }
    

}

protocol QuickAccessibilityViewDelegate : AnyObject{
    func expandQuickAccessibilityView()
    func navToQuickAccessView(at index : Int)
}


class QuickAccessibilityView : UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let items : [QuickAccessibilityItem]
    let collectionViewForQuickAccess : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    var balance : String{
        
        didSet{
            collectionViewForQuickAccess.reloadInputViews()
        }
        
    }
    var isExpand : Bool = false
    var delegate : QuickAccessibilityViewDelegate?
    
    
    var heightContent : CGFloat{
        get{
            return collectionViewForQuickAccess.collectionViewLayout.collectionViewContentSize.height
        }
    }
    
    public init(frame: CGRect, items :[QuickAccessibilityItem], balance : String) {
        self.balance = balance
        self.items = items
       
        super.init(frame: frame)

        setup()
        layoutView()
        contrain()
    }
    
    
    
    
    func setup(){

        collectionViewForQuickAccess.register(QuickAccessibilityButton.self, forCellWithReuseIdentifier: QuickAccessibilityButton.identifier)
        collectionViewForQuickAccess.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionViewForQuickAccess.register(QuickAccessibilityFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: QuickAccessibilityFooter.identifier)
        collectionViewForQuickAccess.register(QuickAccessibilityHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: QuickAccessibilityHeader.identifier)
        collectionViewForQuickAccess.delegate = self
        collectionViewForQuickAccess.dataSource  = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   private func layoutView(){
         self.addSubview(collectionViewForQuickAccess)
         
        self.backgroundColor = UIColor.white
       self.clipsToBounds = true
    
       
        
//        add bottom shadow
       
       layer.cornerRadius = 20
       layer.masksToBounds = false
       layer.shadowRadius = 4
       layer.shadowOpacity = 0.4
       layer.shadowColor = UIColor.black.cgColor
       layer.shadowOffset = CGSize(width: 0 , height: 1)
       
//       collectionview
       var flowLayout = UICollectionViewFlowLayout()
       flowLayout.scrollDirection = .vertical
       flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
       flowLayout.minimumInteritemSpacing = 0
       flowLayout.minimumLineSpacing = 0
       collectionViewForQuickAccess.collectionViewLayout = flowLayout
       collectionViewForQuickAccess.isScrollEnabled = false
       collectionViewForQuickAccess.backgroundColor = UIColor.white
       
       
    }
    
    private func contrain(){
        collectionViewForQuickAccess.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isExpand {
            return items.count
        }else{
            return items.count - 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuickAccessibilityButton.identifier, for: indexPath) as! QuickAccessibilityButton
        let item = items[indexPath.item]
        cell.config(image: item.image, title: item.title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind{
        
        case  UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: QuickAccessibilityHeader.identifier, for: indexPath) as! QuickAccessibilityHeader
            header.configCurrentBalance(balance: balance)
            return header
            
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: QuickAccessibilityFooter.identifier, for: indexPath) as! QuickAccessibilityFooter
            footer.expandAccessibility = { [weak self] in
                self!.isExpand = !self!.isExpand
                self!.collectionViewForQuickAccess.reloadData()
                self!.delegate?.expandQuickAccessibilityView()
                footer.isExpand = !footer.isExpand
            }
            return footer
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = ( self.frame.width - 20 ) / 3
        return CGSize(width: width - 10, height: 90)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.navToQuickAccessView(at: indexPath.item)
    }
    
    
    
    
}

class QuickAccessibilityHeader : UICollectionReusableView {
    
    private lazy var btnNavToAccount = UIButton(frame: .zero)
    private lazy var btnCurrentBalance = UIButton(frame: .zero)
    private lazy var btnNotification = UIButton(frame: .zero)
    private lazy var stackView = UIStackView(frame: .zero)
    
    static let identifier = "QuickAccessibilityHeader"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contrain()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCurrentBalance(balance: String){
        btnCurrentBalance.setTitle(balance, for: .normal)
        btnCurrentBalance.setTitleColor(UIColor.black, for: .normal)
        btnCurrentBalance.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
    }
    
   private func layout(){
//        button nav
        stackView.axis = .vertical
       stackView.distribution = .fillProportionally
        stackView.spacing = 0
       stackView.alignment = .leading
       
        stackView.addArrangedSubview(btnNavToAccount)
        stackView.addArrangedSubview(btnCurrentBalance)
 
       btnNavToAccount.setTitle("Tài khoản của bạn", for: .normal)
       btnNavToAccount.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
       btnNavToAccount.setTitleColor(UIColor.darkGreen, for:  .normal)
       btnNavToAccount.setImage(UIImage(systemName: "chevron.forward", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), for: .normal)
       btnNavToAccount.imageView?.tintColor = UIColor.darkGreen
       btnNavToAccount.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
       btnNavToAccount.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
       btnNavToAccount.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
       btnNavToAccount.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)

       
//       btn current Balance
       btnCurrentBalance.setTitleColor(UIColor.black, for: .normal)
       btnCurrentBalance.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
       btnCurrentBalance.setImage(UIImage(systemName: "eye", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), for: .normal)
       btnCurrentBalance.imageView?.tintColor = UIColor.black
       btnCurrentBalance.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
       btnCurrentBalance.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
       btnCurrentBalance.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
       btnCurrentBalance.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)


        
//      btn notification
       btnNotification.setImage(UIImage(systemName: "bell", withConfiguration: UIImage.SymbolConfiguration(weight: .medium)), for: .normal)
       btnNotification.tintColor = UIColor.black
       btnNotification.backgroundColor = UIColor.white
       btnNotification.layer.borderWidth = 1
       btnNotification.layer.borderColor = UIColor.white.cgColor
       btnNotification.layer.cornerRadius = 25
       
       
       btnNotification.layer.masksToBounds = false
       btnNotification.layer.shadowRadius = 4
       btnNotification.layer.shadowOpacity = 0.6
       btnNotification.layer.shadowColor = UIColor.darkGray.cgColor
       btnNotification.layer.shadowOffset = CGSize(width: 0 , height: 2)

    }
    
    private func contrain(){
        self.addSubview(stackView)
        self.addSubview(btnNotification)
 
        stackView.snp.makeConstraints { [weak self] make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(self!.frame.width * 70/100)
            make.height.equalTo(self!.frame.height - 25)
        }
        
        btnNotification.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(stackView.snp.centerY)
            make.width.equalTo(50)
            make.height.equalTo(50)
            
        }
        
    }
}



class QuickAccessibilityFooter : UICollectionReusableView{
    
    private lazy var btnSeeAll = UIButton(frame: .zero)
    static let identifier = "QuickAccessibilityBottom"
    var expandAccessibility : (() -> ())?
    
    var isExpand : Bool = false{
        didSet{
            if isExpand{
                btnSeeAll.setTitle("Thu gọn", for: .normal)
                btnSeeAll.setImage(UIImage(systemName: "minus.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), for: .normal)
            }else{
                btnSeeAll.setTitle("Xem tất cả", for: .normal)
                btnSeeAll.setImage(UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        contrain()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        
        self.addSubview(btnSeeAll)
        
        btnSeeAll.setTitle("Xem tất cả", for: .normal)
        btnSeeAll.setTitleColor(UIColor.darkGreen, for: .normal)
        btnSeeAll.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
        btnSeeAll.setImage(UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), for: .normal)
        btnSeeAll.imageView?.tintColor = UIColor.darkGreen
        btnSeeAll.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        btnSeeAll.addTarget(self, action: #selector(evenClick), for: .touchUpInside)
        
    }
    
    @objc private func evenClick(){
        expandAccessibility?()
    }
    
    private func contrain(){
        btnSeeAll.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
//            make.bottom.equalToSuperview()
        }
    }
}

class QuickAccessibilityButton : UICollectionViewCell{
    
    private lazy var imgView = UIImageView(frame: .zero)
    private lazy var lbl = UILabel(frame: .zero)
    
    static let identifier = "QuickAccessibilityButton"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        contrain()

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func config(image : UIImage, title : String){
    
        imgView.image = image
        lbl.text = title
        
    }
    
    private func layout(){
        contentView.addSubview(imgView)
        contentView.addSubview(lbl)
        
        
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = UIColor.black
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = UIFont(name: "Roboto-Regular", size: 18)
        
        
    }
    

   private func contrain(){
     
       imgView.snp.makeConstraints { make in
           make.top.equalToSuperview().offset(5)
           make.left.equalToSuperview().offset(5)
           make.right.equalToSuperview().offset(5)
           make.height.equalTo(self.frame.height * 30/100)
       }
       
       lbl.snp.makeConstraints { make in
           make.top.equalTo(imgView.snp_bottomMargin).offset(15)
           make.left.equalToSuperview()
           make.right.equalToSuperview()
//           make.bottom.equalToSuperview()
       }
    }
    
}


struct QuickAccessibilityItem{
    let image : UIImage
    let title : String
    
    init(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }
}
